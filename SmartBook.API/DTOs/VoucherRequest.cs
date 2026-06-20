


namespace SmartBook.API.DTOs  // تأكد من هذا السطر
{
    public class VoucherRequest
    {
        public decimal Amount { get; set; }
        public string Description { get; set; }
        public int FromAccountId { get; set; }
        public int ToAccountId { get; set; }
        public string VoucherType { get; set; }
    }
}