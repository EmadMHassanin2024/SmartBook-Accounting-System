namespace SmartBook.API.DTOs
{
    public class ProductDto
    {
        public string ProductNameAr { get; set; }
        public string? Barcode { get; set; }
        public decimal CostPrice { get; set; }
        public decimal SellingPrice { get; set; }
    }
}
