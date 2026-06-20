namespace SmartBook.API.DTOs
{
    public class AccountStatementResponse
    {

        public string AccountName { get; set; } = string.Empty;
        public decimal TotalDebit { get; set; }  // إجمالي المدين
        public decimal TotalCredit { get; set; } // إجمالي الدائن
        public decimal FinalBalance { get; set; } // الرصيد النهائي
        public List<AccountStatementDto> Details { get; set; } = new();
    }
}
