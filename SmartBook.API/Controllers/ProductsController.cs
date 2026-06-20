using Microsoft.AspNetCore.Mvc;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using SmartBook.API.Repositories;

namespace SmartBook.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly IProductRepository _repo;

        public ProductsController(IProductRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return Ok(await _repo.GetAllAsync());
        }

        [HttpPost("AddProduct")]
        public async Task<IActionResult> AddProduct([FromBody] Product product)
        {
            if (product == null)
                return BadRequest("بيانات المنتج غير صالحة");

            try
            {
                var result = await _repo.AddAsync(product);
                return Ok(result);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error in AddProduct Backend: {ex.Message} -> {ex.InnerException?.Message}");
                return StatusCode(500, new { error = ex.Message, inner = ex.InnerException?.Message });
            }
        }
        [HttpPost("adjust-stock")]
        public async Task<IActionResult> AdjustStock([FromBody] InventoryAdjustmentDto model)
        {
            // استدعاء الدالة التي ترجع string
            var result = await _repo.UpdateStockAndLogAdjustment(model);

            // التحقق مما إذا كان النص المرجع يحتوي على كلمة "خطأ"
            if (result != null && result.Contains("خطأ"))
            {
                // نستخدم BadRequest لإرجاع الخطأ مع رمز حالة 400
                return BadRequest(new { message = "فشلت عملية الجرد", details = result });
            }

            // إذا لم يكن هناك خطأ، نرجع Ok مع رمز حالة 200
            return Ok(new { message = result });
        }
    }
}