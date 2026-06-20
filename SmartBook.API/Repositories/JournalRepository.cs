using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using SmartBook.API.Repositories;

public class JournalRepository : IJournalRepository
{
    private readonly SmartBookDbContext _context;

    public JournalRepository(SmartBookDbContext context)
    {
        _context = context;
    }

  
    public async Task<bool> CreateJournalEntryAsync(CreateJournalEntryDto dto)
    {
        if (dto.Details == null || !dto.Details.Any())
            throw new Exception("لا يمكن حفظ قيد بدون أسطر تفصيلية.");

        decimal totalDebit = dto.Details.Sum(d => d.Debit);
        decimal totalCredit = dto.Details.Sum(d => d.Credit);

        if (Math.Abs(totalDebit - totalCredit) > 0.001m) // استخدام Math.Abs لتفادي أخطاء التقريب
            throw new Exception("القيد غير متوازن ماليًا!");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var entry = new JournalEntry
            {
                EntryDate = dto.EntryDate,
                ReferenceNo = dto.ReferenceNo,
                Description = dto.Description,
                CreatedAt = DateTime.UtcNow
            };

            _context.JournalEntries.Add(entry);
            await _context.SaveChangesAsync();

            foreach (var detailDto in dto.Details)
            {
                var detail = new JournalDetail
                {
                    EntryId = entry.EntryId,
                    AccountId = detailDto.AccountId,
                    Debit = detailDto.Debit,
                    Credit = detailDto.Credit,
                    Description = detailDto.Description
                };
                _context.JournalDetails.Add(detail);
            }

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();
            return true;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    public async Task<bool> DeleteJournalEntryAsync(int entryId)
    {
        var entry = await _context.JournalEntries.FindAsync(entryId);
        if (entry == null) return false;
        _context.JournalEntries.Remove(entry);
        return await _context.SaveChangesAsync() > 0;
    }

    public async Task<bool> UpdateJournalEntryAsync(int entryId, CreateJournalEntryDto dto)
    {
        // تأكد من اسم الخاصية هنا: هل هي Id أم EntryId؟
        var entry = await _context.JournalEntries.Include(j => j.JournalDetails).FirstOrDefaultAsync(j => j.EntryId == entryId);
        if (entry == null) return false;

        entry.Description = dto.Description;
        entry.EntryDate = dto.EntryDate;
        entry.ReferenceNo = dto.ReferenceNo;

        _context.JournalDetails.RemoveRange(entry.JournalDetails);
        foreach (var detail in dto.Details)
        {
            entry.JournalDetails.Add(new JournalDetail
            {
                AccountId = detail.AccountId,
                Debit = detail.Debit,
                Credit = detail.Credit,
                Description = detail.Description
            });
        }
        return await _context.SaveChangesAsync() > 0;
    }

    public async Task<LedgerResultDto> GetAccountLedgerAsync(int accountId, DateTime from, DateTime to)
    {
        // 1. حساب الرصيد الافتتاحي (كل الحركات قبل تاريخ البداية)
        var openingBalance = await _context.JournalDetails
            .Where(d => d.AccountId == accountId && d.Entry.EntryDate < from)
            .SumAsync(d => (d.Debit ?? 0) - (d.Credit ?? 0));

        // 2. جلب حركات الفترة المحددة
        var entries = await _context.JournalEntries
            .Include(e => e.JournalDetails)
            .ThenInclude(d => d.Account)
            .Where(e => e.JournalDetails.Any(d => d.AccountId == accountId)
                     && e.EntryDate >= from && e.EntryDate <= to)
            .OrderBy(e => e.EntryDate)
            .ToListAsync();

        var transactions = new List<LedgerTransactionDto>();
        decimal runningBalance = openingBalance;

        foreach (var entry in entries)
        {
            var myDetail = entry.JournalDetails.First(d => d.AccountId == accountId);
            var contraDetails = entry.JournalDetails.Where(d => d.AccountId != accountId).ToList();

            // تحديث الرصيد التراكمي
            runningBalance += (myDetail.Debit ?? 0) - (myDetail.Credit ?? 0);

            transactions.Add(new LedgerTransactionDto
            {
                EntryId = entry.EntryId,
                Date = entry.EntryDate ?? DateTime.MinValue,
                ContraAccountName = contraDetails.Any()
                    ? string.Join(", ", contraDetails.Select(c => c.Account?.AccountNameAr))
                    : "قيد عام",
                Debit = myDetail.Debit ?? 0,
                Credit = myDetail.Credit ?? 0,
                RunningBalance = runningBalance // إرسال الرصيد التراكمي للواجهة
            });
        }

        return new LedgerResultDto
        {
            OpeningBalance = openingBalance,
            Transactions = transactions
        };
    }


    public async Task<IEnumerable<JournalEntryResponseDto>> GetAllJournalEntriesAsync()
    {
        var entries = await _context.JournalEntries
            .Include(j => j.JournalDetails)
            .ThenInclude(d => d.Account)
            .OrderByDescending(j => j.CreatedAt)
            .ToListAsync();

        return entries.Select(entry => new JournalEntryResponseDto
        {
            EntryId = entry.EntryId,
            ReferenceNo = entry.ReferenceNo,
            Description = entry.Description,
            EntryDate = (DateTime)entry.EntryDate,
            TotalDebit = (decimal)entry.JournalDetails.Sum(l => l.Debit),
            TotalCredit = (decimal)entry.JournalDetails.Sum(l => l.Credit),
            Details = entry.JournalDetails.Select(line => new JournalDetailResponseDto
            {
                AccountId = (int)line.AccountId,
                AccountName = line.Account?.AccountNameAr,
                Description = line.Description,
                Debit = (decimal)line.Debit,
                Credit = (decimal)line.Credit
            }).ToList()
        }).ToList();
    }
}
