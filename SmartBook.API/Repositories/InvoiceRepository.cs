using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public class InvoiceRepository : IInvoiceRepository
    {
        private readonly SmartBookDbContext _context;
        public InvoiceRepository(SmartBookDbContext context)
        {
            _context = context;
        }

        // 1. إضافة فاتورة جديدة مع توليد قيد آلي
        public async Task<bool> AddInvoiceAsync(Invoice invoice)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                if (string.IsNullOrEmpty(invoice.InvoiceNumber))
                {
                    invoice.InvoiceNumber = "INV-" + DateTime.Now.ToString("yyyyMMddHHmmss");
                }

                // 1. إعادة حساب الإجماليات والضرائب وتأمين أسطر الفاتورة
                decimal subTotal = 0;
                decimal totalTax = 0;

                if (invoice.InvoiceDetails != null && invoice.InvoiceDetails.Any())
                {
                    foreach (var detail in invoice.InvoiceDetails)
                    {
                        var lineSubTotal = (detail.Quantity ?? 0) * (detail.UnitPrice ?? 0);
                        var lineTax = detail.TaxAmount ?? 0;

                        detail.TotalLine = lineSubTotal + lineTax;

                        subTotal += lineSubTotal;
                        totalTax += lineTax;

                        // تأمين ربط المعرفات
                        detail.ItemName = string.IsNullOrEmpty(detail.ItemName) ? "صنف مستودع نقدي" : detail.ItemName;
                    }

                    invoice.SubTotal = subTotal;
                    invoice.TaxAmount = totalTax;
                    invoice.TotalAmount = subTotal + totalTax;
                }

                // 2. حفظ الفاتورة وتفاصيلها في قاعدة البيانات مباشرة
                await _context.Invoices.AddAsync(invoice);
                await _context.SaveChangesAsync(); // حفظ للحصول على الـ InvoiceId للأصناف

                // 3. بناء قيد اليومية التلقائي مع تأمين الحسابات
                try
                {
                    // جلب حساب المبيعات (تأمين الكود 4101 أو أول حساب إيرادات)
                    var salesAccount = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountCode == "4101")
                                       ?? await _context.Accounts.FirstOrDefaultAsync(a => a.AccountNameAr.Contains("مبيعات"));

                    // جلب حساب ضريبة المبيعات (تأمين الكود 2204 أو أول حساب ضريبة)
                    var taxAccount = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountCode == "2204")
                                     ?? await _context.Accounts.FirstOrDefaultAsync(a => a.AccountNameAr.Contains("ضريبة"));

                    // جلب حساب الصندوق/النقدي (تأمين الكود 1101 أو أول حساب نقدية)
                    var cashAccount = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountCode == "1101")
                                      ?? await _context.Accounts.FirstOrDefaultAsync(a => a.AccountNameAr.Contains("صندوق") || a.AccountNameAr.Contains("نقدي"));

                    if (salesAccount != null && cashAccount != null)
                    {
                        var journalEntry = new JournalEntry
                        {
                            EntryDate = invoice.InvoiceDate ?? DateTime.UtcNow,
                            Description = $"قيد إثبات فاتورة مبيعات رقم {invoice.InvoiceNumber}",
                      
                            JournalDetails = new List<JournalDetail>()
                        };

                        // الطرف المدين: من حساب الصندوق بقيمة الإجمالي
                        journalEntry.JournalDetails.Add(new JournalDetail
                        {
                            AccountId = cashAccount.AccountId,
                            Debit = invoice.TotalAmount ?? 0,
                            Credit = 0,
                            Description = $"من حـ/ الصندوق - فاتورة {invoice.InvoiceNumber}"
                        });

                        // الطرف الدائن: إلى حساب المبيعات بقيمة الصافي
                        journalEntry.JournalDetails.Add(new JournalDetail
                        {
                            AccountId = salesAccount.AccountId,
                            Debit = 0,
                            Credit = invoice.SubTotal ?? 0,
                            Description = $"إلى حـ/ المبيعات - فاتورة {invoice.InvoiceNumber}"
                        });

                        // الطرف الدائن الإضافي: إلى حساب الضريبة (إن وجدت)
                        if (totalTax > 0 && taxAccount != null)
                        {
                            journalEntry.JournalDetails.Add(new JournalDetail
                            {
                                AccountId = taxAccount.AccountId,
                                Debit = 0,
                                Credit = totalTax,
                                Description = $"إلى حـ/ ضريبة القيمة المضافة - فاتورة {invoice.InvoiceNumber}"
                            });
                        }

                        await _context.JournalEntries.AddAsync(journalEntry);
                        await _context.SaveChangesAsync();
                    }
                    else
                    {
                        Console.WriteLine("⚠️ تنبيه: لم يتم إنشاء قيد المحاسبة الآلي لعدم وجود الحسابات الافتراضية (4101 أو 1101) في الشجرة، ولكن تم حفظ الفاتورة بنجاح.");
                    }
                }
                catch (Exception jEx)
                {
                    // منع انهيار حفظ الفاتورة إذا فشل القيد المحاسبي بسبب الشجرة
                    Console.WriteLine($"⚠️ خطأ غير مؤثر في قيد المحاسبة: {jEx.Message}");
                }

                // 4. اعتماد الحفظ النهائي للـ Transaction
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                Console.WriteLine($"❌ خطأ فادح أثناء حفظ الفاتورة بالكامل: {ex.Message}");
                if (ex.InnerException != null)
                {
                    Console.WriteLine($"❌ التفاصيل الداخلية: {ex.InnerException.Message}");
                }
                return false;
            }
        }
        // 2. جلب كل الفواتير
        public async Task<IEnumerable<Invoice>> GetAllInvoicesAsync()
        {
            return await _context.Invoices
                .Include(i => i.Contact)
                .Include(i => i.InvoiceDetails)
                .OrderByDescending(i => i.InvoiceId)
                .ToListAsync();
        }

        // 3. جلب تفاصيل فاتورة واحدة مع المنتجات
        public async Task<Invoice> GetInvoiceByIdAsync(int id)
        {
            return await _context.Invoices
                .Include(i => i.Contact)
                .Include(i => i.InvoiceDetails)
                    .ThenInclude(d => d.Product)
                .FirstOrDefaultAsync(i => i.InvoiceId == id);
        }

        // 4. التعديل الذكي للفاتورة والقيد المرتبط بها
        public async Task<bool> UpdateInvoiceAsync(Invoice invoice)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // تحديث رأس الفاتورة
                _context.Invoices.Update(invoice);

                // البحث عن القيد المرتبط لتحديث مبالغه
                var journalEntry = await _context.JournalEntries
                    .Include(j => j.JournalDetails)
                    .FirstOrDefaultAsync(j => j.Description.Contains(invoice.InvoiceNumber));

                if (journalEntry != null)
                {
                    foreach (var detail in journalEntry.JournalDetails)
                    {
                        // تحديث الطرف المدين (الصندوق) والطرف الدائن (المبيعات)
                        if (detail.Debit > 0) detail.Debit = invoice.TotalAmount ?? 0;
                        if (detail.Credit > 0) detail.Credit = invoice.TotalAmount ?? 0;
                    }
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                Console.WriteLine($"Update Error: {ex.Message}");
                return false;
            }
        }

        // 5. الحذف النهائي (الفاتورة + التفاصيل + القيد)
        public async Task<bool> DeleteInvoiceAsync(int id)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var invoice = await _context.Invoices
                    .Include(i => i.InvoiceDetails)
                    .FirstOrDefaultAsync(i => i.InvoiceId == id);

                if (invoice == null) return false;

                // حذف القيد
                if (!string.IsNullOrEmpty(invoice.InvoiceNumber))
                {
                    var journalEntry = await _context.JournalEntries
                        .FirstOrDefaultAsync(j => j.Description.Contains(invoice.InvoiceNumber));

                    if (journalEntry != null) _context.JournalEntries.Remove(journalEntry);
                }

                // حذف التفاصيل أولاً
                if (invoice.InvoiceDetails != null)
                {
                    _context.InvoiceDetails.RemoveRange(invoice.InvoiceDetails);
                }

                _context.Invoices.Remove(invoice);

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                Console.WriteLine($"Delete Error: {ex.Message}");
                return false;
            }
        }
    }
}