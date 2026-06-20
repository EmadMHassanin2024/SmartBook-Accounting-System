using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class JournalDetail
{
    public int DetailId { get; set; }
    public int? EntryId { get; set; } // هذا هو الحقل الأساسي للربط
    public int? AccountId { get; set; }
    public decimal? Debit { get; set; }
    public decimal? Credit { get; set; }
    public string? Description { get; set; }

    // العلاقات
    public virtual Account? Account { get; set; }
    public virtual JournalEntry? Entry { get; set; }


}
