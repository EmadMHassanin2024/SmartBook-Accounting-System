using SmartBook.API.DTOs;
using SmartBook.API.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SmartBook.API.Repositories
{
    public interface IAccountRepository
    {
      

        // تم توحيد الاسم هنا
        Task<IEnumerable<AccountDTO>> GetAllAccountsWithBalancesAsync();

        Task<Account?> GetAccountByIdAsync(int id);
        Task<Account?> GetAccountDetailsAsync(int id);
        Task<bool> AddAccountAsync(Account account);
        Task<IEnumerable<User>> GetUsersAsync();
        Task<IEnumerable<Account>> GetAllAccountsWithDetailsAsync();
        Task<AccountStatementResponse> GetAccountStatementAsync(int accountId, DateTime startDate, DateTime endDate);
    }
}