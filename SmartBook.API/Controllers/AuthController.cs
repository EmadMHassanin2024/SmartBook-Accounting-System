using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using SmartBook.API.Repositories;

namespace SmartBook.API.DTOs
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthRepository _repo;

        public AuthController(IAuthRepository repo)
        {
            _repo = repo;
        }

        // 1. تسجيل مستخدم جديد
        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<IActionResult> Register([FromBody] RegisterRequest regRequest)
        {
            // توحيد اسم المستخدم ليصبح أحرف صغيرة
            regRequest.Username = regRequest.Username.ToLower();

            // التحقق إذا كان المستخدم موجود مسبقاً
            if (await _repo.UserExists(regRequest.Username))
                return BadRequest(new { message = "اسم المستخدم موجود بالفعل" });

            // تحويل الـ DTO إلى الموديل الفعلي (User)
            var userToCreate = new User
            {
                Username = regRequest.Username,
                FullName = regRequest.FullName,
                // يمكنك إضافة Email هنا إذا كان موجوداً في الـ RegisterRequest
            };

            // إرسال الكائن والكلمة السرية للمستودع (سيتم تخزينها في PasswordHash)
            var createdUser = await _repo.Register(userToCreate, regRequest.Password);

            return Ok(new
            {
                message = "تم إنشاء الحساب بنجاح",
                username = createdUser.Username
            });
        }

        // 2. تسجيل الدخول
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
        {
            // التحقق من بيانات الدخول عبر الـ Repository
            var userFromRepo = await _repo.Login(loginRequest.Username.ToLower(), loginRequest.Password);

            if (userFromRepo == null)
                return Unauthorized(new { message = "خطأ في اسم المستخدم أو كلمة المرور" });

            // توليد التوكن (JWT)
            var token = _repo.CreateToken(userFromRepo);

            // إرسال البيانات اللازمة للـ Flutter
            return Ok(new
            {
                token = token,
                username = userFromRepo.Username,
                fullName = userFromRepo.FullName,
                userId = userFromRepo.UserId,
                lastLogin = userFromRepo.LastLogin
            });
        }
    }
}