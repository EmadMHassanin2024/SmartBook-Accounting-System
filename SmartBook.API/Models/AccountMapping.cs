namespace SmartBook.API.Models
{
    public class AccountMapping
    {
        public int Id { get; set; }

        // نوع الحركة: (مثل: Sales, Purchase, Return, Expense)
        public string MovementType { get; set; } = null!;

        // الحساب الذي سيتأثر عند حدوث هذه الحركة
        public int AccountId { get; set; }
        public virtual Account? Account { get; set; }

        // ملاحظة إضافية (مثلاً: حساب المبيعات، حساب الصندوق الافتراضي)
        public string? Description { get; set; }
    }
}
