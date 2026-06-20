using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class JournalEntry
{
    public int EntryId { get; set; }

    public DateTime? EntryDate { get; set; }

    public string? ReferenceNo { get; set; }

    public string? Description { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<JournalDetail> JournalDetails { get; set; } = new List<JournalDetail>();
}
