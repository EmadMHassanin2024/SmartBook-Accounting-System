namespace SmartBook.API.DTOs
{
    
  
  
        public class CreateInvoiceDto
        {
            public string CustomerName { get; set; } = "عميل نقدي";
            public decimal TotalAmount { get; set; }
            public List<InvoiceItemDto> InvoiceItems { get; set; } = new();
        }

       
    }


