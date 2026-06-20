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

            // يتحقق إذا كانت الفاتورة فارغة
            // أو لا تحتوي على أي عناصر (Items)
          
            if (invoiceDto == null || !invoiceDto.Items.Any())
                    return BadRequest("بيانات الفاتورة فارغة");

                var result = await _posService.SaveInvoiceAndSyncStock(invoiceDto);

                if (result)
                    return Ok(new { message = "تم حفظ الفاتورة وتحديث المخزن بنجاح" });

                return StatusCode(500, "حدث خطأ أثناء معالجة الفاتورة أو نقص في المخزون");
            }
        }
    


}

