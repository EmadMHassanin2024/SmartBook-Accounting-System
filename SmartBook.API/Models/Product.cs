using System.ComponentModel.DataAnnotations;

namespace SmartBook.API.Models
{
    public class Product
    {

        [Key]
        public int ProductId { get; set; }

        [Required]
        [StringLength(200)]
        public string ProductNameAr { get; set; }

        public string? Barcode { get; set; }

        // الكمية الإجمالية في المخزن (تحسب دائماً بأصغر وحدة - الكيلو مثلاً)
        public decimal TotalStockQuantity { get; set; }

        [Required]
        public decimal CostPrice { get; set; }

        // علاقة مع جدول الوحدات
        public virtual ICollection<ProductUnit> ProductUnits { get; set; } = new List<ProductUnit>();
    }
}
