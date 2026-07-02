using SmartBook.API.DTOs;
using SmartBook.API.Data;
using SmartBook.API.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SmartBook.API.Models.Enums;

namespace SmartBook.API.Repositories
{
    public class FinancialReportsRepository : IFinancialReportsRepository
    {
        private readonly SmartBookDbContext _context;

        public FinancialReportsRepository(SmartBookDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TrialBalanceDTO>> GetTrialBalanceAsync(DateTime targetDate)
        {
            return await _context.Accounts
                .Select(a => new
                {
                    a.AccountCode,
                    a.AccountNameAr,
                    Debit = a.JournalDetails.Where(jd => jd.Entry.EntryDate <= targetDate).Sum(jd => jd.Debit ?? 0),
                    Credit = a.JournalDetails.Where(jd => jd.Entry.EntryDate <= targetDate).Sum(jd => jd.Credit ?? 0)
                })
                .Where(x => x.Debit != 0 || x.Credit != 0)
                .Select(x => new TrialBalanceDTO
                {
                    AccountCode = x.AccountCode,
                    AccountName = x.AccountNameAr,
                    TotalDebit = x.Debit,
                    TotalCredit = x.Credit,
                    BalanceDebit = x.Debit > x.Credit ? (x.Debit - x.Credit) : 0,
                    BalanceCredit = x.Credit > x.Debit ? (x.Credit - x.Debit) : 0
                })
                .ToListAsync();
        }

        public async Task<IEnumerable<AdjustmentEntryDto>> GetAdjustmentsAsync(DateTime date)
        {
            return await _context.Adjustments
                .Where(a => a.Date.Month == date.Month && a.Date.Year == date.Year)
                .Select(a => new AdjustmentEntryDto
                {
                    Id = a.Id,
                    Description = a.Description,
                    Amount = a.Amount,
                    Date = a.Date,
                    Type = a.Type
                })
                .ToListAsync();
        }

        public async Task SaveAdjustmentAsync(AdjustmentEntryDto dto)
        {
            var entry = new AdjustmentEntry
            {
                Id = string.IsNullOrEmpty(dto.Id) ? Guid.NewGuid().ToString() : dto.Id,
                Description = dto.Description,
                Amount = dto.Amount,
                Date = dto.Date,
                Type = dto.Type,
                CreatedAt = DateTime.UtcNow
            };

            _context.Adjustments.Add(entry);
            await _context.SaveChangesAsync();
        }

        public async Task<IncomeStatementResponseDto> GetIncomeStatementAsync(DateTime fromDate, DateTime toDate)
        {
            var journalEntries = await _context.JournalEntries
                .Include(je => je.JournalDetails)
                    .ThenInclude(jd => jd.Account)
                .Where(je => je.EntryDate >= fromDate && je.EntryDate <= toDate)
                .ToListAsync();

            var dto = new IncomeStatementResponseDto();
            var allDetails = journalEntries.SelectMany(je => je.JournalDetails);

            var groupedData = allDetails
                .GroupBy(jd => new { jd.Account.AccountNameAr, jd.Account.AccountType })
                .Select(g => new
                {
                    g.Key.AccountNameAr,
                    g.Key.AccountType,
                    TotalAmount = g.Sum(x => (x.Debit ?? 0) - (x.Credit ?? 0))
                })
                .ToList();

            foreach (var item in groupedData)
            {
                var dtoItem = new IncomeStatementItemDto
                {
                    AccountName = item.AccountNameAr,
                    Amount = Math.Abs((double)item.TotalAmount)
                };

                switch (item.AccountType)
                {
                    case AccountType.Revenue: dto.Revenues.Add(dtoItem); break;
                    case AccountType.CostOfSales: dto.CostOfSales.Add(dtoItem); break;
                    case AccountType.Expense: dto.Expenses.Add(dtoItem); break;
                    case AccountType.OtherRevenue: dto.OtherRevenues.Add(dtoItem); break;
                    case AccountType.OtherExpense: dto.OtherExpenses.Add(dtoItem); break;
                }
            }
            return dto;
        }

        public async Task<List<LedgerTransactionDto>> GetAccountLedgerAsync(int accountId, DateTime from, DateTime to)
        {
            return await _context.JournalDetails
                .Include(d => d.Entry) // تم التعديل لاستخدام العلاقة المعرفة بـ Entry
                .Where(d => d.AccountId == accountId
                         && d.Entry.EntryDate >= from
                         && d.Entry.EntryDate <= to)
                .Select(d => new LedgerTransactionDto
                {
                    EntryId = d.EntryId ?? 0,
                    Date = d.Entry.EntryDate ?? DateTime.MinValue,
                    Description = d.Entry.Description,
                    Debit = d.Debit ?? 0,
                    Credit = d.Credit ?? 0,
                })
                .OrderBy(d => d.Date)
                .ToListAsync();
        }


        // في الـ Repository الخاص بك
        public async Task<IEnumerable<AccountDTO>> GetAllAccountsAsync()
        {
            return await _context.Accounts.Select(a => new AccountDTO
            {
                AccountId = a.AccountId,
                AccountNameAr = a.AccountNameAr,
                AccountCode = a.AccountCode,
                AccountType = (int)a.AccountType,

                // التعديل هنا: نجمع من JournalDetails (التي تحتوي على الحركات الفعلية)
                CurrentBalance =(int) a.JournalDetails.Sum(j => j.Debit - j.Credit)
            }).ToListAsync();
        }


    }
}