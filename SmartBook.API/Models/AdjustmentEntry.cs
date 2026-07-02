using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SmartBook.API.Models
{
    public class AdjustmentEntry
    {
        [Key]
        public string Id { get; set; } // استخدمنا String لأنك تولده في فلاتر عبر milliseconds

        [Required]
        [MaxLength(255)]
        public string Description { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal Amount { get; set; } // decimal مفضل للعمليات المالية

        public DateTime Date { get; set; }

        public int Type { get; set; } // يمثل الـ Enum القادم من فلاتر

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;


    }
}
