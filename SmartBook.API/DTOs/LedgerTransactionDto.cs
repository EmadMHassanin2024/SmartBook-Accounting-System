namespace SmartBook.API.DTOs
{
    public class LedgerTransactionDto
    {
         public int EntryId { get; set; }

        public DateTime Date { get; set; }
        public string Description { get; set; }
        public decimal Debit { get; set; }
        public string ContraAccountName { get; set; }
        public decimal Credit { get; set; }
        public decimal RunningBalance { get; set; }  
 
    }
}
