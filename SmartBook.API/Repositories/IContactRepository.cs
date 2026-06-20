using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public class ContactRepository : IContactRepository
    {
        private readonly SmartBookDbContext _context;
        public ContactRepository(SmartBookDbContext context) => _context = context;

        public async Task<IEnumerable<Contact>> GetAllAsync() => await _context.Contacts.ToListAsync();

        public async Task<Contact> AddAsync(Contact contact)
        {
            await _context.Contacts.AddAsync(contact);
            await _context.SaveChangesAsync();
            return contact;
        }
    }
}
