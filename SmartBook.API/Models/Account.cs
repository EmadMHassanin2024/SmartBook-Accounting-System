using SmartBook.API.Models.Enums;
using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class Account
{
    public int AccountId { get; set; }

    public string AccountCode { get; set; } = null!;

    public string AccountNameAr { get; set; } = null!;

    public string? AccountNameEn { get; set; }

    public int? ParentAccountId { get; set; }

    public AccountType AccountType { get; set; }

    public int? Level { get; set; }

    public bool? IsMain { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public virtual ICollection<Contact> Contacts { get; set; } = new List<Contact>();

    public virtual ICollection<Account> InverseParentAccount { get; set; } = new List<Account>();

    public virtual ICollection<JournalDetail> JournalDetails { get; set; } = new List<JournalDetail>();

    public virtual Account? ParentAccount { get; set; }

    public decimal CalculateBalance()
    {
        if (JournalDetails == null || !JournalDetails.Any())
            return 0m;

        // نفترض أن JournalDetail يحتوي على Debit و Credit
        // قم بتعديل أسماء الحقول حسب الموجود فعلياً في JournalDetail لديك
        decimal totalDebit = (decimal)JournalDetails.Sum(j => j.Debit);
        decimal totalCredit = (decimal)JournalDetails.Sum(j => j.Credit);

        return totalDebit - totalCredit;
    }
}