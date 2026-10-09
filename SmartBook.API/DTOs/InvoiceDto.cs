namespace SmartBook.API.DTOs
{
    public class InvoiceDto
    {
     

        // قائمة الأصناف (هنا يتم إرسال كل المنتجات داخل الفاتورة دفعة واحدة)
        public List<InvoiceItemDto> Items { get; set; } = new List<InvoiceItemDto>();

        // تاريخ الفاتورة
        public DateTime InvoiceDate { get; set; }

        // إجمالي الفاتورة
        public decimal TotalAmount { get; set; }

        // نوع الدفع (Cash / Credit)
        public string PaymentType { get; set; } = "Cash";

        // معرف العميل
        public int? ContactId { get; set; }

        // وصف اختياري
        public string Description { get; set; }
    }
}
