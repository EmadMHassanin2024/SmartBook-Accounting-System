namespace SmartBook.API.DTOs
{
    public class TrialBalanceDTO
    {

        public string AccountName { get; set; } = string.Empty;
        public decimal Debit { get; set; }
        public decimal Credit { get; set; }

        public decimal Balance => Debit - Credit;
    }
}
