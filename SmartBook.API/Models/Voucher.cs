using SmartBook.API.Models;
using System.ComponentModel.DataAnnotations.Schema;

//وهذا الـ Model يخزن بيانات هذا السند.
public partial class Voucher
{
    public int VoucherId { get; set; }
    public string VoucherNumber { get; set; } = null!;
    public string? VoucherType { get; set; }
    public DateTime VoucherDate { get; set; }
    public decimal TotalAmount { get; set; } // تأكد من الاسم هنا هل هو TotalAmount أم Amount كما في Swagger؟
    public string? Description { get; set; }
    public int? CreatedBy { get; set; }
    public DateTime? CreatedAt { get; set; }
    //الحساب المرسل منه
    public int? FromAccountId { get; set; }
    //الحساب المرسل إليه
    public int? ToAccountId { get; set; }


    [ForeignKey("FromAccountId")]
    public virtual Account? FromAccount { get; set; }
    [ForeignKey("ToAccountId")]
    public virtual Account? ToAccount { get; set; }
    public virtual User? CreatedByNavigation { get; set; }


    public int? EntryId { get; set; } // رقم القيد المرتبط
    [ForeignKey("EntryId")]
    public virtual JournalEntry? Entry { get; set; }
}