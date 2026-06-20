namespace SmartBook.API.DTOs
{
    public class AccountDTO
    {
        public int AccountId { get; set; }
        public string AccountNameAr { get; set; }
        public string AccountCode { get; set; }
        public int AccountType { get; set; }
        public decimal CurrentBalance { get; set; }
    }
}
