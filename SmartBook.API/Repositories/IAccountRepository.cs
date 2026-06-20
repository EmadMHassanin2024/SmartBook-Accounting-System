
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using System.Threading.Tasks;

namespace SmartBook.API.Repositories
{
    public interface IAccountRepository
    {
        Task<IEnumerable<TrialBalanceDTO>>GetTrialBalanceAsync(DateTime targetDate);
        Task<IEnumerable<Account>> GetAllAccountsAsync();
        Task<Account?> GetAccountByIdAsync(int id);
        Task<Account?> GetAccountDetailsAsync(int id);
        Task<bool> AddAccountAsync(Account account);
        Task<IEnumerable<User>> GetUsersAsync();

        // هذه هي الدالة الوحيدة المطلوبة لكشف الحساب
 
        Task<IEnumerable<Account>> GetAllAccountsWithDetailsAsync();
        Task<AccountStatementResponse> GetAccountStatementAsync(int accountId, DateTime startDate, DateTime endDate);
    }

}
