using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SmartBook.API.Models
{
    public class InventoryLog
    {
        [Key]
        public int LogId { get; set; }

        [Required]
        public int ProductId { get; set; }

        // ربط السجل بالمنتج
        [ForeignKey("ProductId")]
        public virtual Product Product { get; set; }

        public decimal OldStock { get; set; } // الرصيد قبل التسوية
        public decimal NewStock { get; set; } // الرصيد بعد التسوية

        [StringLength(500)]
        public string? Note { get; set; } // سبب التسوية

        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}
