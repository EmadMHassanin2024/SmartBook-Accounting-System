namespace SmartBook.API.DTOs
{
    public class InvoiceItemUploadDto
    {
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal VatAmount { get; set; }
    }
}
