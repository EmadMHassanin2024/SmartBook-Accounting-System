namespace SmartBook.API.DTOs
{
    public class AdjustmentEntryDto
    {
        public string Id { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public int Type { get; set; }


    }
}
