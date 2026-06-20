using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using SmartBook.API.Repositories;

namespace SmartBook.API.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly SmartBookDbContext _context;
        private readonly IJournalRepository _journalRepo;

        public ProductRepository(SmartBookDbContext context, IJournalRepository journalRepo)
        {
            _context = context;
            _journalRepo = journalRepo;
        }

        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            return await _context.Products
                .Include(p => p.ProductUnits)
                .ToListAsync();
        }

        public async Task<Product> AddAsync(Product product)
        {
            await _context.Products.AddAsync(product);
            await _context.SaveChangesAsync();
            return product;
        }

        // تم دمج التوقيع ليطابق الواجهة (Interface)
        public async Task<string> UpdateStockAndLogAdjustment(InventoryAdjustmentDto model)
        {
            try
            {
                var product = await _context.Products.FindAsync(model.ProductId);
                if (product == null) return "خطأ: المنتج غير موجود";

                decimal oldStock = product.TotalStockQuantity;
                decimal difference = model.NewStock - oldStock;
                product.TotalStockQuantity = model.NewStock;

                // 1. تسجيل حركة الجرد
                var log = new InventoryLog
                {
                    ProductId = model.ProductId,
                    OldStock = oldStock,
                    NewStock = model.NewStock,
                    Note = model.Note,
                    CreatedAt = model.Date
                };
                await _context.InventoryLogs.AddAsync(log);
                await _context.SaveChangesAsync();

                // 2. إنشاء القيد (فقط إذا كان هناك فرق)
                if (difference != 0)
                {
                    decimal cost = product.CostPrice; // تأكد أن CostPrice معرف في الموديل
                    decimal val = Math.Abs(difference * cost);

                    var entry = new JournalEntry
                    {
                        EntryDate = model.Date,
                        Description = $"تسوية جرد - LogId:{log.LogId}",
                        CreatedAt = DateTime.Now
                    };
                    await _context.JournalEntries.AddAsync(entry);
                    await _context.SaveChangesAsync(); // ضروري للحصول على EntryId

                    // إضافة تفاصيل القيد
                    var d1 = new JournalDetail { EntryId = entry.EntryId, AccountId = (difference < 0 ? 500 : 100), Debit = (difference < 0 ? val : 0), Credit = (difference > 0 ? val : 0) };
                    var d2 = new JournalDetail { EntryId = entry.EntryId, AccountId = (difference < 0 ? 100 : 500), Debit = (difference > 0 ? val : 0), Credit = (difference < 0 ? val : 0) };

                    await _context.JournalDetails.AddRangeAsync(d1, d2);
                    await _context.SaveChangesAsync();
                }

                return "تمت تسوية المخزون والقيود بنجاح";
            
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
                return "خطأ: " + ex.Message;
            }
        }

        public async Task<bool> ReverseAdjustment(int logId)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var originalLog = await _context.InventoryLogs.FindAsync(logId);
                if (originalLog == null) return false;

                // يجب أن يطابق نمط الوصف ما تم إنشاؤه في الدالة السابقة
                string descPattern = $"LogId:{logId}";
                var originalEntry = await _context.JournalEntries
                    .Include(e => e.JournalDetails)
                    .FirstOrDefaultAsync(e => e.Description.Contains(descPattern));

                if (originalEntry == null) return false;

                var reversalEntry = new JournalEntry
                {
                    EntryDate = DateTime.Now,
                    Description = $"قيد عكسي لتسوية الجرد رقم {logId}",
                    CreatedAt = DateTime.Now
                };

                await _context.JournalEntries.AddAsync(reversalEntry);
                await _context.SaveChangesAsync();

                var reversedDetails = originalEntry.JournalDetails.Select(d => new JournalDetail
                {
                    EntryId = reversalEntry.EntryId,
                    AccountId = d.AccountId,
                    Debit = d.Credit,
                    Credit = d.Debit
                }).ToList();

                await _context.JournalDetails.AddRangeAsync(reversedDetails);
                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                System.Diagnostics.Debug.WriteLine($"Reversal Error: {ex.ToString()}");
                return false;
            }
        }
    }
}