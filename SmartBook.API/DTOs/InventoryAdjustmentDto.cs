namespace SmartBook.API.DTOs
{
    public class InventoryAdjustmentDto
    {

        public int ProductId { get; set; }
        public int NewStock { get; set; }
        public string Note { get; set; }
        public DateTime Date { get; set; }
    }
}
