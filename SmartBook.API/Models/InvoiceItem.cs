namespace SmartBook.API.Models
{
    public class InvoiceItem
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid InvoiceId { get; set; }
        public string ProductId { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal VatAmount { get; set; }

        // Navigation Property
        public Invoice? Invoice { get; set; }
    }
}
