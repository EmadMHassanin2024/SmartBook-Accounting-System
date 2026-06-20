using SmartBook.API.Data;
using SmartBook.API.DTOs;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.Models;

namespace SmartBook.API.Services
{
    public class PosService
    {
        private readonly SmartBookDbContext _context;

        public PosService(SmartBookDbContext context)
        {
            _context = context;
        }

        public async Task<bool> SaveInvoiceAndSyncStock(InvoiceDto invoiceDto)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    // 1. خصم المخزون
                    foreach (var item in invoiceDto.Items)
                    {
                        var product = await _context.Products.FirstOrDefaultAsync(p => p.ProductId == item.ProductId);
                        if (product == null) throw new Exception($"المنتج رقم {item.ProductId} غير موجود");
                        if (product.TotalStockQuantity < (decimal)item.Quantity)
                            throw new Exception($"الكمية غير كافية للصنف: {product.ProductNameAr}");

                        product.TotalStockQuantity -= (decimal)item.Quantity;
                    }

                    // 2. إنشاء الفاتورة الأساسية والتفاصيل
                    var invoice = new Invoice
                    {
                        InvoiceDate = DateTime.Now,
                        TotalAmount = invoiceDto.TotalAmount,
                        InvoiceDetails = invoiceDto.Items.Select(item => new InvoiceDetail
                        {
                            ProductId = item.ProductId,
                            Quantity = (decimal)item.Quantity,
                            UnitPrice = (decimal)item.UnitPrice,
                            TaxAmount = (decimal)item.VatAmount,
                            TotalLine = (decimal)item.Quantity * (decimal)item.UnitPrice
                        }).ToList()
                    };

                    _context.Invoices.Add(invoice);
                    await _context.SaveChangesAsync();

                    // 3. جلب حساب المبيعات الديناميكي أو استخدام المعرف الصحيح من جدولك
                    var mapping = await _context.AccountMappings
                        .FirstOrDefaultAsync(m => m.MovementType == "Sales");

                    // تعديل الأرقام لتطابق جدول الحسابات الخاص بك تماماً
                    int cashAccountId = 1;                        // الصندوق من جدولك = 1
                    int salesAccountId = mapping?.AccountId ?? 3; // المبيعات من جدولك = 3 (بدلاً من 4001)

                    var entry = new JournalEntry
                    {
                        EntryDate = DateTime.Now,
                        Description = $"مبيعات فاتورة رقم {invoice.InvoiceNumber}",
                        JournalDetails = new List<JournalDetail>()
                    };

                    // ربط الحسابات مباشرة بالقيد لتجنب أي مشاكل Validation في الذاكرة
                    var details = new List<JournalDetail>
            {
                // الطرف المدين (الصندوق دخلت له فلوس)
                new JournalDetail { AccountId = cashAccountId, Debit = invoice.TotalAmount, Credit = 0, Entry = entry },
                
                // الطرف الدائن (المبيعات زادت)
                new JournalDetail { AccountId = salesAccountId, Debit = 0, Credit = invoice.TotalAmount, Entry = entry }
            };

                    entry.JournalDetails = details;

                    _context.JournalEntries.Add(entry);
                    await _context.SaveChangesAsync();

                    // 4. الربط النهائي وتحديث الفاتورة برقم القيد
                    invoice.EntryId = entry.EntryId;
                    await _context.SaveChangesAsync();

                    await transaction.CommitAsync();
                    return true;
                }
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    // إرجاع الخطأ الحقيقي الصافي للـ Controller ليظهر بوضوح
                    throw new Exception(ex.InnerException?.Message ?? ex.Message);
                }
            }
        }
    }
}
