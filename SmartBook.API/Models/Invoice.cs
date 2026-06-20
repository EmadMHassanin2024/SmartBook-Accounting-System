using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class Invoice
{
    public int InvoiceId { get; set; }

    public string? InvoiceNumber { get; set; }

    public DateTime? InvoiceDate { get; set; }

    public int? ContactId { get; set; }

    public decimal? SubTotal { get; set; }

    public decimal? TaxAmount { get; set; }

    public decimal? TotalAmount { get; set; }

    public string? PaymentType { get; set; }

    public int? UserId { get; set; }

    public virtual Contact? Contact { get; set; }

    // 💡 هذه هي العلاقة الرسمية والوحيدة المعتمدة في قاعدة بياناتك
    public virtual ICollection<InvoiceDetail> InvoiceDetails { get; set; } = new List<InvoiceDetail>();

    public virtual User? User { get; set; }

    public Guid Id { get; set; } = Guid.NewGuid();

    public string CustomerName { get; set; } = "عميل نقدي";

    public string Status { get; set; } = "مدفوعة";

    // 💡 إضافة الربط مع القيد المحاسبي
    public int? EntryId { get; set; }
    public virtual JournalEntry? Entry { get; set; }
}