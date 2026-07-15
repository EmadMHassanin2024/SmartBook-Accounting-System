namespace SmartBook.API.Models
{
    public class CompanySetting
    {
        public int Id { get; set; }
        public string CompanyName { get; set; }
        public string Currency { get; set; } // مثال: SAR, USD
        public DateTime FiscalYearStart { get; set; }
        public DateTime FiscalYearEnd { get; set; }
    }
}
