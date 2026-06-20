using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class InvoiceDetail
{
    public int DetailId { get; set; }
    public int? ProductId { get; set; } // المفتاح الأجنبي
 
    public int? InvoiceId { get; set; }

    [ValidateNever]
    public virtual Product? Product { get; set; }
 
    public string? ItemName { get; set; }

    public decimal? Quantity { get; set; }

    public decimal? UnitPrice { get; set; }

    public decimal? TaxAmount { get; set; }

    public decimal? TotalLine { get; set; }
    [ValidateNever]
    public virtual Invoice? Invoice { get; set; }
}
