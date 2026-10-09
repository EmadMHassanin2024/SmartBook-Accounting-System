using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;

namespace SmartBook.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SalesController : ControllerBase
    {
        private readonly SmartBookDbContext _context;

        public SalesController(SmartBookDbContext context)
        {
            _context = context;
        }

        // GET: api/Sales/analytics
        [HttpGet("analytics")]
        public async Task<IActionResult> GetSalesAnalytics()
        {
            try
            {
                // 1. جلب الفواتير
                var invoicesList = await _context.Invoices.ToListAsync();

                // 2. تجميع أفضل العملاء وترتيبهم رقمياً بشكل صحيح
                var rawCustomers = invoicesList
                    .GroupBy(i => i.ContactId)
                    .Select(g => new {
                        Name = "عميل رقم " + (g.Key.HasValue ? g.Key.Value.ToString() : "نقدي"),
                        TotalSum = g.Sum(x => x.TotalAmount)
                    })
                    .OrderByDescending(x => x.TotalSum)
                    .Take(5)
                    .ToList();

                var topCustomers = rawCustomers.Select(c => new {
                    name = c.Name,
                    val = $"{c.TotalSum / 1000:0.0}K"
                }).ToList();

                // 3. جلب الأصناف الأكثر طلباً مع ربط جدول المنتجات لجلب الاسم الصحيح ProductNameAr
                var rawProducts = await _context.InvoiceDetails
                    .Include(item => item.Product)
                    .GroupBy(item => new {
                        item.ProductId,
                        ProductName = item.Product != null ? item.Product.ProductNameAr : "منتج غير معروف"
                    })
                    .Select(g => new {
                        productName = g.Key.ProductName,
                        totalQty = g.Sum(x => (double?)x.Quantity) ?? 0,
                        totalPrice = g.Sum(x => (decimal?)((double)x.Quantity * (double)x.UnitPrice)) ?? 0
                    })
                    .OrderByDescending(x => x.totalQty)
                    .Take(5)
                    .ToListAsync();

                var topProducts = rawProducts.Select(p => new {
                    name = p.productName,
                    qty = p.totalQty + " قطعة",
                    total = p.totalPrice.ToString("0.00") + " ر.س"
                }).ToList();

                // 4. أداء المبيعات الشهرية للرسم البياني
                var chartData = new
                {
                    months = new[] { "يناير", "فبراير", "مارس", "أبريل" },
                    values = new[] { 20000, 35000, 50000, 80000 }
                };

                var result = new
                {
                    topProducts,
                    topCustomers,
                    chartData
                };

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "حدث خطأ في السيرفر", error = ex.Message });
            }
        }
    }
 }