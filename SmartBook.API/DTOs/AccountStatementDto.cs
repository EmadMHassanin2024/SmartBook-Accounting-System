


namespace SmartBook.API.DTOs
{
    public class AccountStatementDto
    {
        public DateTime Date { get; set; }
        public string Description { get; set; } = string.Empty;
        public decimal Debit { get; set; }  // مدين
        public decimal Credit { get; set; } // دائن
        public decimal Balance { get; set; } // الرصيد بعد الحركة

 
        public string Reference { get; set; } = string.Empty; // رقم السند أو القيد
 
 
        public decimal BalanceAfter { get; set; } // الرصيد بعد الحركة
      
    }
}


