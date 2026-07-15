using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;

namespace SmartBook.API.Controllers
{


    [Route("api/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly SmartBookDbContext _context;
        public ContactsController(SmartBookDbContext context) => _context = context;



        [HttpGet]
        public async Task<IActionResult> GetContacts([FromQuery] string type)
        {
            var contacts = await _context.Contacts.Where(c => c.ContactType == type).ToListAsync();
            return Ok(new { data = contacts }); // لاحظ أننا نرجع كائن يحتوي على المفتاح "data"
        }
        [HttpPost]
        public async Task<IActionResult> AddContact([FromBody] ContactDto contactDto)
        {
            // التحقق من صحة البيانات المرسلة
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // تحويل الـ DTO إلى الـ Model الأساسي
            var contact = new Contact
            {
                Name = contactDto.Name,
                Phone = contactDto.Phone,
                TaxNumber = contactDto.TaxNumber,
                OpeningBalance = contactDto.OpeningBalance,
                CurrentBalance = contactDto.CurrentBalance,
                ContactType = contactDto.ContactType // سيتم حفظ هذه القيمة في قاعدة البيانات
            };

            _context.Contacts.Add(contact);
            await _context.SaveChangesAsync();

            return Ok(contact); // سيرجع الـ Contact بعد توليد الـ ID من قاعدة البيانات
        }




        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateContact(int id, [FromBody] ContactUpdateDto contactDto)
        {
            // 1. جلب العميل الحالي من قاعدة البيانات


            var hasInvoices = await _context.Invoices.AnyAsync(i => i.ContactId == id);
            var contact = await _context.Contacts.FindAsync(id);
            if (contact == null)
                return NotFound("العميل غير موجود");

            // 2. تحديث البيانات (فقط إذا كانت القيمة المرسلة ليست فارغة)
            if (!string.IsNullOrEmpty(contactDto.Name))
            {
                // التحقق المحاسبي: هل يوجد حركات لمنع تغيير الاسم؟
                if (contact.Invoices.Any())
                    return BadRequest("لا يمكن تعديل اسم العميل لوجود حركات مالية مرتبطة به");

                contact.Name = contactDto.Name;
            }

            // 3. تحديث بيانات الاتصال (تحديث فقط إذا أرسل المستخدم قيمة جديدة)
            if (!string.IsNullOrEmpty(contactDto.Phone))
                contact.Phone = contactDto.Phone;

            if (!string.IsNullOrEmpty(contactDto.TaxNumber))
                contact.TaxNumber = contactDto.TaxNumber;

            if (!string.IsNullOrEmpty(contactDto.Address))
                contact.Address = contactDto.Address;

            // 4. الحفظ
            await _context.SaveChangesAsync();
            return Ok(new { message = "تم تحديث البيانات بنجاح" });
        }


    }
}