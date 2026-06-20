namespace SmartBook.API.DTOs
{
    public class LedgerResultDto
    {
        public decimal OpeningBalance { get; set; }
        public IEnumerable<LedgerTransactionDto> Transactions { get; set; }
    }
}
