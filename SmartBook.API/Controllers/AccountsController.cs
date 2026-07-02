using Microsoft.AspNetCore.Mvc;
using SmartBook.API.Repositories;
using SmartBook.API.Models;
using SmartBook.API.DTOs;

namespace SmartBook.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        private readonly IAccountRepository _repo;

        public AccountsController(IAccountRepository repo)
        {
            _repo = repo;
        }

        /// <summary> جلب قائمة بجميع الحسابات مع أرصدتها الحالية </summary>
        [HttpGet("all")]
        public async Task<IActionResult> GetAllAccounts()
        {
            // نستخدم الدالة المحسنة التي تجلب الأرصدة من الـ DB مباشرة
            var accountDtos = await _repo.GetAllAccountsWithBalancesAsync();
            return Ok(accountDtos);
        }

        /// <summary> جلب بيانات حساب محدد عن طريق معرفه </summary>
        [HttpGet("{id}")] // تم تصحيح المسار هنا
        public async Task<IActionResult> GetAccount(int id)
        {
            var account = await _repo.GetAccountByIdAsync(id);
            if (account == null) return NotFound("الحساب غير موجود");

            return Ok(account);
        }

        /// <summary> إضافة حساب جديد إلى قاعدة البيانات </summary>
        [HttpPost]
        public async Task<IActionResult> AddAccount([FromBody] Account account)
        {
            if (account == null) return BadRequest("بيانات الحساب غير صحيحة");
            var result = await _repo.AddAccountAsync(account);
            return result ? Ok(new { message = "تم إضافة الحساب بنجاح" }) : BadRequest("فشل في إضافة الحساب");
        }

        /// <summary> جلب قائمة بجميع المستخدمين المسجلين في النظام </summary>
        [HttpGet("users")]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _repo.GetUsersAsync();
            return Ok(users);
        }
    }
}