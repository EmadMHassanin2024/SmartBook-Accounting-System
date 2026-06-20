using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using SmartBook.API.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SmartBook.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InvoicesController : ControllerBase
    {
        private readonly IInvoiceRepository _repo;

        public InvoicesController(IInvoiceRepository repo)
        {
            _repo = repo;
        }

        // 1. إضافة فاتورة جديدة وحفظها فعلياً في الـ SQL Server
        [HttpPost]
        [Route("save-invoice")]
        public async Task<IActionResult> CreateInvoice([FromBody] InvoiceUploadDto dto)
        {
            if (dto == null) return BadRequest(new { message = "البيانات المرسلة فارغة تماماً" });

            if (!ModelState.IsValid) return BadRequest(ModelState);

            try
            {
                // حساب الحقول الإجمالية بدقة متناهية قبل الحفظ لملء الحقول الأصلية بالقاعدة
                decimal totalTax = dto.InvoiceItems?.Sum(x => (decimal)x.VatAmount) ?? 0;
                decimal totalAmount = (decimal)dto.TotalAmount;
                decimal subTotal = totalAmount - totalTax;

                // بناء رأس الفاتورة وتطهير المسميات لتركب على قاعدة البيانات مباشرة
                var invoice = new Invoice
                {
                    CustomerName = string.IsNullOrEmpty(dto.CustomerName) ? "عميل نقدي" : dto.CustomerName,
                    TotalAmount = totalAmount,
                    SubTotal = subTotal,
                    TaxAmount = totalTax,
                    PaymentType = dto.PaymentMethod ?? "نقدي",
                    InvoiceDate = DateTime.UtcNow,
                    Status = "مدفوعة",
                    InvoiceNumber = $"INV-{DateTime.Now.ToString("yyyyMMddHHmmss")}",
                    InvoiceDetails = new List<InvoiceDetail>() // تأمين القائمة الأصلية المتوافقة مع الـ Snapshot
                };

                // تحويل وعمل Mapping دقيق لعناصر الفاتورة
                if (dto.InvoiceItems != null && dto.InvoiceItems.Any())
                {
                    foreach (var item in dto.InvoiceItems)
                    {
                        decimal lineUnitPrice = (decimal)item.UnitPrice;
                        decimal lineQuantity = (decimal)item.Quantity;
                        decimal lineTax = (decimal)item.VatAmount;
                        decimal lineTotal = (lineUnitPrice * lineQuantity) + lineTax;

                        invoice.InvoiceDetails.Add(new InvoiceDetail
                        {
                            ProductId = item.ProductId,
                            Quantity = lineQuantity,
                            UnitPrice = lineUnitPrice,
                            TaxAmount = lineTax,
                            TotalLine = lineTotal, // ملء حقل الحساب الإجمالي للسطر المطلوب في الـ Snapshot
                            ItemName = "صنف مستودع نقدي"
                        });
                    }
                }
                else
                {
                    return BadRequest(new { message = "لا يمكن حفظ فاتورة بدون أصناف" });
                }

                // تمرير الكائن النظيف إلى الـ Repository وتنفيذ الحفظ
                var result = await _repo.AddInvoiceAsync(invoice);

                if (result)
                {
                    return Ok(new { message = "تم الحفظ بنجاح وتحديث رصيد المخزن والقيود", invoiceNumber = invoice.InvoiceNumber });
                }

                return BadRequest(new { message = "فشل الحفظ: تأكد من صحة قيود قاعدة البيانات أو الـ Repository" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message, inner = ex.InnerException?.Message });
            }
        }

        // 2. جلب جميع الفواتير
        [HttpGet]
        public async Task<IActionResult> GetInvoices([FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
        {
            var invoices = await _repo.GetAllInvoicesAsync();
            if (startDate.HasValue) invoices = invoices.Where(i => i.InvoiceDate >= startDate.Value.Date);
            if (endDate.HasValue) invoices = invoices.Where(i => i.InvoiceDate <= endDate.Value.Date.AddDays(1).AddTicks(-1));

            var invoiceList = invoices.Select(i => new {
                number = i.InvoiceNumber ?? $"INV-{i.InvoiceId}",
                customer = i.CustomerName ?? "عميل نقدي",
                amount = i.TotalAmount ?? 0,
                paymentMethod = i.PaymentType ?? "نقدي",
                date = i.InvoiceDate.HasValue ? $"{i.InvoiceDate.Value.Year}/{i.InvoiceDate.Value.Month:D2}/{i.InvoiceDate.Value.Day:D2}" : DateTime.Now.ToString("yyyy/MM/dd"),
                status = i.Status ?? "مدفوعة"
            }).ToList();

            return Ok(invoiceList);
        }

        // 3. جلب فاتورة محددة بالـ ID
        [HttpGet("{id}")]
        public async Task<IActionResult> GetInvoice(int id)
        {
            var invoice = await _repo.GetInvoiceByIdAsync(id);
            if (invoice == null) return NotFound("الفاتورة غير موجودة");
            return Ok(invoice);
        }

        // 4. تحديث فاتورة قائمة
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateInvoice(int id, [FromBody] Invoice invoice)
        {
            if (id != invoice.InvoiceId) return BadRequest("رقم الفاتورة غير متطابق");

            var result = await _repo.UpdateInvoiceAsync(invoice);
            if (result) return Ok(new { message = "تم التعديل بنجاح وتحديث القيود المالية" });

            return BadRequest("فشل عملية التعديل");
        }

        // 5. حذف فاتورة
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInvoice(int id)
        {
            var result = await _repo.DeleteInvoiceAsync(id);
            if (result) return Ok(new { message = "تم حذف الفاتورة والقيود المرتبطة بها بنجاح" });

            return BadRequest("فشل الحذف أو الفاتورة غير موجودة");
        }
    }
}