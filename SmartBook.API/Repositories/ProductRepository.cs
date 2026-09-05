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
            if (product.ProductUnits != null && product.ProductUnits.Any())
            {
                foreach (var unit in product.ProductUnits)
                {
                    unit.Product = product;
                }
            }

            await _context.Products.AddAsync(product);
            await _context.SaveChangesAsync();

            await _context.Entry(product).Collection(p => p.ProductUnits).LoadAsync();

            return product;
        }

        public async Task<string> UpdateStockAndLogAdjustment(InventoryAdjustmentDto model)
        {
            try
            {
                var product = await _context.Products.FindAsync(model.ProductId);
                if (product == null) return "خطأ: المنتج غير موجود";

                decimal oldStock = product.TotalStockQuantity;
                decimal difference = model.NewStock - oldStock;
                product.TotalStockQuantity = model.NewStock;

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

                if (difference != 0)
                {
                    decimal cost = product.CostPrice;
                    decimal val = Math.Abs(difference * cost);

                    var entry = new JournalEntry
                    {
                        EntryDate = model.Date,
                        Description = $"تسوية جرد - LogId:{log.LogId}",
                        CreatedAt = DateTime.Now
                    };
                    await _context.JournalEntries.AddAsync(entry);
                    await _context.SaveChangesAsync();

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

        public async Task<bool> DeleteAsync(int id)
        {
            var product = await _context.Products
                .Include(p => p.ProductUnits)
                .FirstOrDefaultAsync(p => p.ProductId == id);

            if (product == null) return false;

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Product> UpdateAsync(int id, Product product)
        {
            var existingProduct = await _context.Products
                .Include(p => p.ProductUnits)
                .FirstOrDefaultAsync(p => p.ProductId == id);

            if (existingProduct == null) throw new Exception("المنتج غير موجود");

            existingProduct.ProductNameAr = product.ProductNameAr;
            existingProduct.Barcode = product.Barcode;
            existingProduct.CostPrice = product.CostPrice;
            existingProduct.TotalStockQuantity = product.TotalStockQuantity;
            existingProduct.ItemType = product.ItemType;

            // تحديث الوحدات المرتبطة بطريقة سليمة (إزالة القديم وإضافة الجديد أو التعديل)
            _context.ProductUnits.RemoveRange(existingProduct.ProductUnits);

            if (product.ProductUnits != null && product.ProductUnits.Any())
            {
                foreach (var unit in product.ProductUnits)
                {
                    unit.ProductId = id;
                    unit.Product = null;
                    _context.ProductUnits.Add(unit);
                }
            }

            await _context.SaveChangesAsync();

            // إعادة تحميل الوحدات المحدثة للاستجابة
            await _context.Entry(existingProduct).Collection(p => p.ProductUnits).LoadAsync();

            return existingProduct;
        }
    }
}