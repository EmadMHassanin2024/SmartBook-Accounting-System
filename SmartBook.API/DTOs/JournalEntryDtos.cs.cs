namespace SmartBook.API.DTOs
{
    // 1. الـ DTOs الخاصة بالإنشاء (المستلمة من الفلاتر)
    public class CreateJournalEntryDto
    {
        public DateTime EntryDate { get; set; }
        public string? ReferenceNo { get; set; }
        public string? Description { get; set; }
        public List<JournalDetailRequestDto> Details { get; set; } = new();
    }

    public class JournalDetailRequestDto
    {
        public int AccountId { get; set; }
        public decimal Debit { get; set; }
        public decimal Credit { get; set; }
        public string? Description { get; set; }
    }

    // 2. الـ DTOs الخاصة بالجلب (المرسلة لشاشة دفتر اليومية في الفلاتر)
    public class JournalEntryResponseDto
    {
        public int EntryId { get; set; }
        public string? ReferenceNo { get; set; }
        public string? Description { get; set; }
        public DateTime EntryDate { get; set; }
        public decimal TotalDebit { get; set; }
        public decimal TotalCredit { get; set; }
        public List<JournalDetailResponseDto> Details { get; set; } = new();
    }

    public class JournalDetailResponseDto
    {
        public int AccountId { get; set; }
        public string? AccountName { get; set; }
        public string? Description { get; set; }
        public decimal Debit { get; set; }
        public decimal Credit { get; set; }
    }
}