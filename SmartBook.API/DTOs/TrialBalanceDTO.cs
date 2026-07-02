namespace SmartBook.API.DTOs
{
    public class TrialBalanceDTO
    {

        public string AccountCode { get; set; } // إضافة الكود
        public string AccountName { get; set; }
        public decimal TotalDebit { get; set; }
        public decimal TotalCredit { get; set; }
        public decimal BalanceDebit { get; set; }  // رصيد مدين
        public decimal BalanceCredit { get; set; } // رصيد دائن
    }
}
