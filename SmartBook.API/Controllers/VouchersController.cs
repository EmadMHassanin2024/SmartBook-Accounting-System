using Microsoft.AspNetCore.Mvc;
using SmartBook.API.DTOs;
using SmartBook.API.Repositories;

namespace SmartBook.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VouchersController : ControllerBase
    {
        private readonly IVoucherRepository _repo;
        public VouchersController(IVoucherRepository repo) { _repo = repo; }





        [HttpPost]
        public async Task<IActionResult> CreateVoucher(VoucherRequest request)
        {
            try
            {
                // استخراج الـ ID من التوكن (المطالب/Claims)
                var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

                if (userIdClaim == null)
                {
                    return Unauthorized("لا يمكن تحديد هوية المستخدم من التوكن.");
                }

                int userId = int.Parse(userIdClaim.Value);

                // تمرير الـ userId للـ Repository
                var result = await _repo.CreateVoucherAsync(request, userId);

                return Ok(new { message = "تم تسجيل السند والقيد بنجاح" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}