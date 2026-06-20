using System;
using System.Collections.Generic;

namespace SmartBook.API.Models;

public partial class CompanyProfile
{
    public int Id { get; set; }

    public string NameAr { get; set; } = null!;

    public string? NameEn { get; set; }

    public string? TaxNumber { get; set; }

    public string? Address { get; set; }

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public string? LogoPath { get; set; }

    public string? Currency { get; set; }

    public DateTime? CreatedAt { get; set; }
}
