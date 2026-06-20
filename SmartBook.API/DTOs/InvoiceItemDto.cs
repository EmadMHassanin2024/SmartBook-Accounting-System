namespace SmartBook.API.DTOs
{
    public class InvoiceItemDto
    {
        public int ProductId { get; set; }
        public double Quantity { get; set; }
        public double Price { get; set; }


        public decimal UnitPrice { get; set; }
        public decimal VatAmount { get; set; }
    }
}
