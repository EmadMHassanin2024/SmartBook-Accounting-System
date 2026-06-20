using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using SmartBook.API.Repositories;
using SmartBook.API.Models;
using Microsoft.EntityFrameworkCore;
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
            var accounts = await _repo.GetAllAccountsAsync();
            var accountDtos = accounts.Select(a => new AccountDTO
            {
                AccountId = a.AccountId,
                AccountCode = a.AccountCode,
                AccountNameAr = a.AccountNameAr,
                AccountType = (int)a.AccountType,
                CurrentBalance = a.CalculateBalance()
            }).ToList();
            return Ok(accountDtos);
        }

        /// <summary> جلب بيانات حساب محدد عن طريق معرفه </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAccount(int id)
        {
            // ملاحظة: يُفضل هنا استدعاء ميثود تجلب حساباً واحداً من الـ Repository بدلاً من جلب الكل
            var account = await _repo.GetAccountByIdAsync(id);
            if (account == null) return NotFound();
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

        /// <summary> جلب ميزان المراجعة حتى تاريخ محدد </summary>
        [HttpGet("trial-balance")]
        public async Task<IActionResult> GetTrialBalance([FromQuery] DateTime? date)
        {
            var targetDate = date ?? DateTime.UtcNow;
            var trialBalance = await _repo.GetTrialBalanceAsync(targetDate);
            return Ok(trialBalance);
        }

        /// <summary> جلب كشف حساب تفصيلي للحركات المالية خلال فترة زمنية </summary>
        [HttpGet("{id}/statement")]
        public async Task<IActionResult> GetAccountStatement(int id, [FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
        {
            // هذا المسار هو المسؤول عن جلب "حساب الأستاذ" للحساب المحدد بالـ id
            var statement = await _repo.GetAccountStatementAsync(id, startDate, endDate);
            if (statement == null || statement.Details == null || !statement.Details.Any())
                return NotFound("لا توجد حركات لهذا الحساب في الفترة المحددة.");

            return Ok(statement);
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