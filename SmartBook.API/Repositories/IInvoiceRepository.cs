using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public interface IInvoiceRepository
    {

        Task<IEnumerable<Invoice>> GetAllInvoicesAsync();
        Task<Invoice> GetInvoiceByIdAsync(int id);
        Task<bool> AddInvoiceAsync(Invoice invoice); // هذا هو الأهم للحساب الآلي
        Task<bool> UpdateInvoiceAsync(Invoice invoice);
        Task<bool> DeleteInvoiceAsync(int id);


    }
}
