using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using SmartBook.API.DTOs;
using SmartBook.API.Repositories;

namespace SmartBook.API.Controllers // تأكد من وجود مسار الـ Namespace
{
    [Route("api/[controller]")]
    [ApiController]
    public class FinancialReportsController : ControllerBase
    {
        private readonly IFinancialReportsRepository _repo;

        public FinancialReportsController(IFinancialReportsRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("trial-balance")]
        public async Task<IActionResult> GetTrialBalance([FromQuery] DateTime? date)
        {
            var trialBalance = await _repo.GetTrialBalanceAsync(date ?? DateTime.UtcNow);
            return Ok(trialBalance);
        }

        // تم تعديل الدالة لترجع IActionResult ولها مسار [HttpGet]
        [HttpGet("adjustments")]
        public async Task<IActionResult> GetAdjustmentsAsync([FromQuery] DateTime date)
        {
            // الكنترولر يطلب البيانات من الـ Repository الجاهز
            var result = await _repo.GetAdjustmentsAsync(date);
            return Ok(result);
        }

        // تم تعديل الدالة لترجع IActionResult ولها مسار [HttpPost]
        [HttpPost("adjustments/save")]
        public async Task<IActionResult> SaveAdjustmentAsync([FromBody] AdjustmentEntryDto dto)
        {
            // الكنترولر يرسل البيانات للـ Repository ليقوم هو بالحفظ
            await _repo.SaveAdjustmentAsync(dto);
            return Ok(new { message = "تم حفظ التسوية بنجاح" });
        }

        [HttpGet("income-statement")]
        public async Task<ActionResult<IncomeStatementResponseDto>> GetIncomeStatement(DateTime fromDate, DateTime toDate)
        {
            var result = await _repo.GetIncomeStatementAsync(fromDate, toDate);
            return Ok(result);
        }

        [HttpGet("Accounts")]
  
        public async Task<IActionResult> GetAccounts()
        {
        
           var accounts = await _repo.GetAllAccountsAsync(); // أو اسم الدالة عندك
            return Ok(new { success = true, data = accounts });
        }
       

        [HttpGet("Ledger")]
        public async Task<IActionResult> GetLedger(int accountId, DateTime from, DateTime to)
        {
            // هذا هو الرابط الذي سنختبره في Postman لاحقاً
            var ledger = await _repo.GetAccountLedgerAsync(accountId, from, to);
            return Ok(new { success = true, data = ledger }); // إرجاع القائمة داخل كائن لتطابق "المنطق الذكي" في Flutter
        }


    }
}