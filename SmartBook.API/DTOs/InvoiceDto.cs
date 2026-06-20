namespace SmartBook.API.DTOs
{
    public class InvoiceDto
    {
        // قائمة الأصناف
        public List<InvoiceItemDto> Items { get; set; } = new List<InvoiceItemDto>();

        // تاريخ الفاتورة
        public DateTime InvoiceDate { get; set; }

        // إجمالي الفاتورة (مهم للقيد المحاسبي)
        public decimal TotalAmount { get; set; }

        // نوع الدفع (مهم لتحديد هل نربط القيد بحساب الصندوق أم حساب العميل)
        public string PaymentType { get; set; } = "Cash";

        // معرف العميل (إذا كانت فاتورة آجلة)
        public int? ContactId { get; set; }

        // وصف اختياري
        public string? Description { get; set; }

        public string ProductId { get; set; } = string.Empty;

        public int Quantity { get; set; }

        public decimal UnitPrice { get; set; }

        public decimal VatAmount { get; set; }
    }
}
