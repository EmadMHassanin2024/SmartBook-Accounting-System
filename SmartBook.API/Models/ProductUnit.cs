using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SmartBook.API.Models
{
    public class ProductUnit
    {
        [Key]
        public int UnitId { get; set; }

        [Required]
        public string UnitName { get; set; } // كيلو، شكارة، كرتونة

        [Column(TypeName = "decimal(18, 2)")]
        public decimal SalePrice { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal PurchasePrice { get; set; }

        // معامل التحويل: الشكارة معاملها 50 (لأنها تحتوي 50 كيلو)
        // الكيلو معامله 1 (لأنه الوحدة الأساسية)
        public decimal ConversionFactor { get; set; }

        public bool IsBaseUnit { get; set; } // هل هي الوحدة الأصغر؟

        // الربط بالمنتج
        public int ProductId { get; set; }
        [ForeignKey("ProductId")]
        public virtual Product Product { get; set; }
    }
}

