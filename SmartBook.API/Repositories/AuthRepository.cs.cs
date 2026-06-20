using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SmartBook.API.Data;
using SmartBook.API.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace SmartBook.API.Repositories
{
    public class AuthRepository : IAuthRepository
    {
        private readonly SmartBookDbContext _context;
        private readonly IConfiguration _config;

        public AuthRepository(SmartBookDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        public async Task<User> Login(string username, string password)
        {

            var user = await _context.Users
            .FirstOrDefaultAsync(x => x.Username == username && x.PasswordHash == password);

            if (user != null)
            {
                user.LastLogin = DateTime.Now; // تحديث وقت الدخول
                await _context.SaveChangesAsync();
            }

            return user;

        }

        public string CreateToken(User user)
        {
            var claims = new List<Claim> {
                // لاحظ استخدام UserId (حرف i صغير) كما يظهر غالباً في توليد الـ EF
                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                new Claim(ClaimTypes.Name, user.Username)
            };

            // حل مشكلة CS1503: استخراج النص أولاً ثم تحويله لـ Bytes
            var jwtKey = _config.GetSection("Jwt:Key").Value;
            if (string.IsNullOrEmpty(jwtKey)) throw new Exception("JWT Key is missing from appsettings.json");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(1),
                SigningCredentials = creds,
                Issuer = _config["Jwt:Issuer"],
                Audience = _config["Jwt:Audience"]
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        public async Task<User> Register(User user, string password)
        {
            // 1. وضع كلمة المرور في حقل PasswordHash (كما هو مسمى في الكلاس عندك)
            user.PasswordHash = password;

            // 2. إعطاء قيم افتراضية للحقول الجديدة
            user.CreatedAt = DateTime.Now;
            user.IsActive = true;

            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<bool> UserExists(string username)
        {
            return await _context.Users.AnyAsync(x => x.Username == username.ToLower());
        }

    }
}