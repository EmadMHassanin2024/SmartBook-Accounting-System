using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{


    public interface IContactRepository
    {
        Task<IEnumerable<Contact>> GetAllAsync();
        Task<Contact> AddAsync(Contact contact);
    }
}
