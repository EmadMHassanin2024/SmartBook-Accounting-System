using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.Models;
using SmartBook.API.DTOs;

namespace SmartBook.API.Repositories
{
    public class VoucherRepository : IVoucherRepository
    {
        private readonly SmartBookDbContext _context;

        public VoucherRepository(SmartBookDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Voucher>> GetAllVouchersAsync()
        {
            return await _context.Vouchers.ToListAsync();
        }

        public async Task<Voucher> GetVoucherByIdAsync(int id)
        {
            return await _context.Vouchers.FindAsync(id);
        }

        // الدالة الموحدة لإنشاء السند والقيود وتحديث الأرصدة
        public async Task<bool> CreateVoucherAsync(VoucherRequest request , int userId)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // 1. إنشاء السند وربط الحسابات (حل مشكلة الـ NULL في قاعدة البيانات)
                var voucher = new Voucher
                {
                    VoucherNumber = Guid.NewGuid().ToString().Substring(0, 8),
                    VoucherType = request.VoucherType,
                    VoucherDate = DateTime.Now,
                    TotalAmount = request.Amount,
                    Description = request.Description,
                    FromAccountId = request.FromAccountId, // الربط المباشر
                    ToAccountId = request.ToAccountId,     // الربط المباشر
                    CreatedBy = userId, // الملحوظة رقم 1: نستخدم المعرف القادم من الـ Controller
                    CreatedAt = DateTime.Now,
                };

                _context.Vouchers.Add(voucher);
                await _context.SaveChangesAsync(); // حفظ السند أولاً للحصول على الـ Id إذا لزم الأمر

                // 2. إنشاء رأس القيد المحاسبي (Journal Entry Header)
                var journalEntry = new JournalEntry
                {
                    EntryDate = voucher.VoucherDate,
                    ReferenceNo = voucher.VoucherNumber,
                    Description = $"قيد تلقائي: {voucher.VoucherType} - {voucher.Description}",
                    CreatedAt = DateTime.Now
                };
                _context.JournalEntries.Add(journalEntry);
                await _context.SaveChangesAsync();

                // 3. إضافة تفاصيل القيد (مدين ودائن)
                var details = new List<JournalDetail>
                {
                    new JournalDetail
                    {
                        EntryId = journalEntry.EntryId,
                        AccountId = request.ToAccountId, // الحساب المستلم (مدين)
                        Debit = request.Amount,
                        Credit = 0
                    },
                    new JournalDetail
                    {
                        EntryId = journalEntry.EntryId,
                        AccountId = request.FromAccountId, // الحساب الصادر منه (دائن)
                        Debit = 0,
                        Credit = request.Amount
                    }
                };
                _context.JournalDetails.AddRange(details);

                // 4. تحديث أرصدة الحسابات في جدول Accounts
                var fromAcc = await _context.Accounts.FindAsync(request.FromAccountId);
                var toAcc = await _context.Accounts.FindAsync(request.ToAccountId);
                //تتأكد من وجود الحساب فقط (بدون تحديث
                if (fromAcc == null || toAcc == null)
                {
                    throw new Exception("أحد الحسابات المطلوبة غير موجود في قاعدة البيانات.");
                }

                if (fromAcc == null || toAcc == null)
                {
                    throw new Exception("أحد الحسابات المطلوبة غير موجود.");
                }

                // حفظ كافة التغييرات النهائية
                await _context.SaveChangesAsync();

                // اعتماد العملية بالكامل
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception ex)
            {
                // في حال حدوث أي خطأ، يتم التراجع عن كل شيء (Rollback)
                await transaction.RollbackAsync();

                // إرسال تفاصيل الخطأ بدقة لـ Postman للمساعدة في التشخيص
                var innerMsg = ex.InnerException != null ? " | Inner Error: " + ex.InnerException.Message : "";
                throw new Exception($"فشلت العملية: {ex.Message}{innerMsg}");
            }
        }

        // ملاحظة: تم دمج منطق AddVoucherAsync داخل CreateVoucherAsync لتبسيط العمل وضمان التزامن

        public async Task<bool> SaveVoucherWithEntryAsync(Voucher voucher, JournalEntry entry)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // 1. إضافة القيد أولاً للحصول على الـ EntryId
                _context.JournalEntries.Add(entry);
                await _context.SaveChangesAsync();

                // 2. ربط السند بالقيد الذي تم إنشاؤه
                voucher.EntryId = entry.EntryId;

                // 3. حفظ السند
                _context.Vouchers.Add(voucher);
                await _context.SaveChangesAsync();

                // 4. تأكيد العملية
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                return false;
            }
        }

    }
}