using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace SmartBook.API.Models;

public partial class JournalDetail
{
    public int DetailId { get; set; }

    // المفتاح الأجنبي
    public int? EntryId { get; set; }
    public int? AccountId { get; set; }

    public decimal? Debit { get; set; }
    public decimal? Credit { get; set; }
    public string? Description { get; set; }

    // العلاقات
    public virtual Account? Account { get; set; }

    // هنا قمنا بتوحيد اسم العلاقة ليكون "Entry" كما هو معرف في الـ Fluent API الخاص بك
    [ForeignKey("EntryId")]
    public virtual JournalEntry Entry { get; set; } = null!;
}