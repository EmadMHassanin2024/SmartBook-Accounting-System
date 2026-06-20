using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public class AccountRepository : IAccountRepository
    {
        private readonly SmartBookDbContext _context;

        public AccountRepository(SmartBookDbContext context)
        {
            _context = context;
        }

        // 1. كشف الحساب
        public async Task<AccountStatementResponse> GetAccountStatementAsync(int accountId, DateTime startDate, DateTime endDate)
        {
            var account = await _context.Accounts.FindAsync(accountId);
            var details = await _context.JournalDetails
                .Where(d => d.AccountId == accountId && d.Entry.EntryDate >= startDate && d.Entry.EntryDate <= endDate)
                .OrderBy(d => d.Entry.EntryDate)
                .Select(d => new
                {
                    Debit = d.Debit ?? 0m,
                    Credit = d.Credit ?? 0m,
                    EntryDate = d.Entry.EntryDate,
                    Reference = d.Entry.ReferenceNo,
                    Description = d.Entry.Description
                }).ToListAsync();

            var response = new AccountStatementResponse
            {
                AccountName = account?.AccountNameAr ?? "حساب غير معروف",
                Details = new List<AccountStatementDto>(),
                TotalDebit = 0,
                TotalCredit = 0
            };

            decimal runningBalance = await _context.JournalDetails
                .Where(d => d.AccountId == accountId && d.Entry.EntryDate < startDate)
                .SumAsync(d => (d.Debit ?? 0m) - (d.Credit ?? 0m));

            response.Details.Add(new AccountStatementDto
            {
                Date = startDate,
                Reference = "رصيد افتتاحي",
                Description = "Opening Balance",
                Debit = 0,
                Credit = 0,
                BalanceAfter = runningBalance
            });

            foreach (var detail in details)
            {
                runningBalance += (detail.Debit - detail.Credit);
                response.TotalDebit += detail.Debit;
                response.TotalCredit += detail.Credit;
                response.Details.Add(new AccountStatementDto
                {
                    Date = detail.EntryDate ?? DateTime.Now,
                    Reference = detail.Reference ?? "N/A",
                    Description = detail.Description ?? "",
                    Debit = detail.Debit,
                    Credit = detail.Credit,
                    BalanceAfter = runningBalance
                });
            }
            response.FinalBalance = runningBalance;
            return response;
        }

        // 2. ميزان المراجعة
        public async Task<IEnumerable<TrialBalanceDTO>> GetTrialBalanceAsync(DateTime targetDate)
        {
            return await _context.Accounts
                .Select(a => new TrialBalanceDTO
                {
                    AccountName = a.AccountNameAr,
                    Debit = a.JournalDetails
                        .Where(jd => jd.Entry.EntryDate <= targetDate)
                        .Sum(jd => jd.Debit ?? 0),
                    Credit = a.JournalDetails
                        .Where(jd => jd.Entry.EntryDate <= targetDate)
                        .Sum(jd => jd.Credit ?? 0)
                })
                .Where(x => x.Debit != 0 || x.Credit != 0)
                .ToListAsync();
        }

        // 3. الدوال الأخرى الأساسية
        public async Task<Account?> GetAccountByIdAsync(int id) => await _context.Accounts.FindAsync(id);

        public async Task<IEnumerable<Account>> GetAllAccountsAsync() =>
            await _context.Accounts.OrderBy(a => a.AccountNameAr).AsNoTracking().ToListAsync();

        public async Task<Account?> GetAccountDetailsAsync(int id) =>
            await _context.Accounts.AsNoTracking().FirstOrDefaultAsync(a => a.AccountId == id);

        public async Task<bool> AddAccountAsync(Account account)
        {
            _context.Accounts.Add(account);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<IEnumerable<User>> GetUsersAsync() =>
            await _context.Users.AsNoTracking().ToListAsync();

        public async Task<IEnumerable<Account>> GetAllAccountsWithDetailsAsync() =>
            await _context.Accounts.Include(a => a.JournalDetails).ToListAsync();
    }
}