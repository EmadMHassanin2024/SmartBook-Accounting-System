using Microsoft.AspNetCore.Mvc;
using SmartBook.API.Data;
using SmartBook.API.Models;

namespace SmartBook.API.Controllers
{


    [Route("api/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly SmartBookDbContext _context;
        public ContactsController(SmartBookDbContext context) => _context = context;

        [HttpPost]
        public async Task<IActionResult> AddContact(Contact contact)
        {
            _context.Contacts.Add(contact);
            await _context.SaveChangesAsync();
            return Ok(contact);
        }
    }
}