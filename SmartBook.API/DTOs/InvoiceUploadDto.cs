namespace SmartBook.API.DTOs
{
    public class InvoiceUploadDto
    {
        public string CustomerName { get; set; }
        public double TotalAmount { get; set; }
        public string PaymentMethod { get; set; }
        public List<InvoiceItemUploadDto> InvoiceItems { get; set; }
    }
}
