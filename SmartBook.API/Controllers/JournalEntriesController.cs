using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartBook.API.DTOs;
using SmartBook.API.Repositories;
using System;
using System.Threading.Tasks;

namespace SmartBook.API.Controllers
{
    [Authorize] 
    [Route("api/[controller]")]
    [ApiController]
    public class JournalEntriesController : ControllerBase
    {
        private readonly IJournalRepository _repo;

        public JournalEntriesController(IJournalRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                // استدعاء دالة الجلب من الـ Repository
                var entries = await _repo.GetAllJournalEntriesAsync();
                return Ok(new { success = true, data = entries });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

      
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateJournalEntryDto dto)
        {
            // 1. التحقق من سلامة كائن البيانات المرسل
            if (dto == null)
            {
                return BadRequest(new { success = false, message = "البيانات المرسلة فارغة أو غير صالحة." });
            }

            // 2. التحقق من شروط الـ Validation المكتوبة داخل الـ DTO تلقائياً
            if (!ModelState.IsValid)
            {
                return BadRequest(new { success = false, message = "فشل التحقق من صحة حقول القيد.", errors = ModelState });
            }

            try
            {
                // 3. استدعاء الـ Repository لتنفيذ عملية الإدراج داخل قاعدة البيانات (Transaction الآمن)
                var result = await _repo.CreateJournalEntryAsync(dto);

                if (result)
                {
                    // إرجاع حالة 200 نجاح جاهزة للاستقبال في الفلاتر
                    return Ok(new { success = true, message = "تم تسجيل قيد اليومية بنجاح وتأمين التوازن المالي في النظام." });
                }

                return BadRequest(new { success = false, message = "فشل في حفظ القيد، يرجى مراجعة توازن الحسابات المدائن والمدين." });
            }
            catch (Exception ex)
            {
                // 4. إرجاع رسالة الخطأ الصريحة والواضحة ليراها الكيوبيت في الـ Flutter أو في Postman فوراً
                return BadRequest(new { success = false, message = $"خطأ داخلي في السيرفر: {ex.Message}" });
            }
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