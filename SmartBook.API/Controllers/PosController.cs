using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using SmartBook.API.DTOs;
using SmartBook.API.Services;

namespace SmartBook.API.Controllers
{

        [Route("api/[controller]")]
        [ApiController]
        public class PosController : ControllerBase
        {
            private readonly PosService _posService;

            public PosController(PosService posService)
            {
                _posService = posService;
            }


        [HttpPost("save-invoice")]
        public async Task<IActionResult> SaveInvoice([FromBody] InvoiceDto invoiceDto)
        {
            if (invoiceDto == null || !invoiceDto.Items.Any())
                return BadRequest("بيانات الفاتورة فارغة");

            try
            {
                var result = await _posService.SaveInvoiceAndSyncStock(invoiceDto);
                if (result)
                    return Ok(new { message = "تم حفظ الفاتورة وتحديث المخزن بنجاح" });

                return StatusCode(500, "حدث خطأ أثناء معالجة الفاتورة");
            }
            catch (Exception ex)
            {
                // 🔍 طباعة الخطأ كاملاً في الـ Console الخاص بالباك إند
                Console.WriteLine($"❌ ERROR IN SAVE INVOICE: {ex.Message} -> {ex.InnerException?.Message}");

                // 💡 إرجاع تفاصيل الخطأ للواجهة الأمامية لنراه بوضوح
                return StatusCode(500, new { error = ex.Message, inner = ex.InnerException?.Message });
            }
        }

    }
    


}

