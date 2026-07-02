using SmartBook.API.DTOs;

namespace SmartBook.API.Repositories
{
    public interface IFinancialReportsRepository
    {
        Task<IEnumerable<TrialBalanceDTO>> GetTrialBalanceAsync(DateTime targetDate);

        Task<IEnumerable<AdjustmentEntryDto>> GetAdjustmentsAsync(DateTime date);
        Task SaveAdjustmentAsync(AdjustmentEntryDto dto);
        Task<IncomeStatementResponseDto> GetIncomeStatementAsync(DateTime fromDate, DateTime toDate);

        Task<List<LedgerTransactionDto>> GetAccountLedgerAsync(int accountId, DateTime from, DateTime to);
     
        Task<IEnumerable<AccountDTO>> GetAllAccountsAsync();



    }
}
