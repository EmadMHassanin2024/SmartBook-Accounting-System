using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace SmartBook.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize] // يتطلب تسجيل الدخول للحصول على هوية المستخدم
    public class ConfigController : ControllerBase
    {
        private readonly SmartBookDbContext _context;

        public ConfigController(SmartBookDbContext context)
        {
            _context = context;
        }

        // مساعدة للحصول على الـ UserId للمستخدم الحالي من الـ Token
        private string GetCurrentUserId() => User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        // مساعدة للتحقق مما إذا كان المستخدم الحالي هو Admin
        private bool IsAdmin() => User.IsInRole("Admin")
        || User.FindFirstValue(ClaimTypes.Role) == "Admin";
        

        [HttpGet]
        public async Task<IActionResult> GetConfig()
        {
            var userId = GetCurrentUserId();
            var config = await _context.SystemConfigurations.FirstOrDefaultAsync(c => c.UserId == userId);

            if (config == null)
            {
                return NotFound(new { message = "لم يتم العثور على إعدادات محفوظة لهذا المستخدم." });
            }

            var responseDto = new
            {
                userId = config.UserId,
                companyName = config.CompanyName,
                enabledCoreModules = string.IsNullOrEmpty(config.EnabledCoreModules)
                    ? new string[0]
                    : config.EnabledCoreModules.Split(','),
                enabledBusinessModules = string.IsNullOrEmpty(config.EnabledBusinessModules)
                    ? new string[0]
                    : config.EnabledBusinessModules.Split(','),
                enabledFeatures = string.IsNullOrEmpty(config.EnabledFeatures)
                    ? new string[0]
                    : config.EnabledFeatures.Split(',')
            };

            return Ok(responseDto);
        }

        // 4. جلب إعدادات كل الشركات/المستخدمين (للـ Admin فقط) (GET /api/config/all)
        [HttpGet("all")]
        public async Task<IActionResult> GetAllConfigs()
        {
            /*
            if (!IsAdmin())
            {
                return Forbid();
            }
            */

            var allConfigs = await _context.SystemConfigurations.ToListAsync();

            var responseList = allConfigs.Select(config => new
            {
                userId = config.UserId,
                companyName = config.CompanyName,
                enabledCoreModules = string.IsNullOrEmpty(config.EnabledCoreModules) ? new string[0] : config.EnabledCoreModules.Split(','),
                enabledBusinessModules = string.IsNullOrEmpty(config.EnabledBusinessModules) ? new string[0] : config.EnabledBusinessModules.Split(','),
                enabledFeatures = string.IsNullOrEmpty(config.EnabledFeatures) ? new string[0] : config.EnabledFeatures.Split(',')
            }).ToList();

           return Ok(responseList);
        }
        // جلب إعدادات أي مستخدم (صلاحيات المدير للاطلاع على كل شيء)
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetConfigByUserId(string userId)
        {
            if (!IsAdmin())
            {
                return Forbid();
            }

            var config = await _context.SystemConfigurations.FirstOrDefaultAsync(c => c.UserId == userId);

            if (config == null)
            {
                return NotFound(new { message = "لم يتم العثور على إعدادات لهذا المستخدم." });
            }

            var responseDto = new
            {
                userId = config.UserId,
                companyName = config.CompanyName,
                enabledCoreModules = string.IsNullOrEmpty(config.EnabledCoreModules) ? new string[0] : config.EnabledCoreModules.Split(','),
                enabledBusinessModules = string.IsNullOrEmpty(config.EnabledBusinessModules) ? new string[0] : config.EnabledBusinessModules.Split(','),
                enabledFeatures = string.IsNullOrEmpty(config.EnabledFeatures) ? new string[0] : config.EnabledFeatures.Split(',')
            };

            return Ok(responseDto);
        }

        [HttpPost]
        public async Task<IActionResult> SaveConfig([FromBody] SystemSettingsDto model)
        {
            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId))
            {
                return Unauthorized(new { message = "المستخدم غير معروف." });
            }

            var existingConfig = await _context.SystemConfigurations.FirstOrDefaultAsync(c => c.UserId == userId);

            // تحويل الـ Arrays القادمة من البوستمان إلى نص مفصول بـ Comma لتخزينه في جدول SQL
            var coreModulesStr = model.EnabledCoreModules != null ? string.Join(",", model.EnabledCoreModules) : string.Empty;
            var businessModulesStr = model.EnabledBusinessModules != null ? string.Join(",", model.EnabledBusinessModules) : string.Empty;
            var featuresStr = model.EnabledFeatures != null ? string.Join(",", model.EnabledFeatures) : string.Empty;

            if (existingConfig == null)
            {
                var newConfig = new SystemConfiguration
                {
                    UserId = userId,
                    CompanyName = model.CompanyName,
                    EnabledCoreModules = coreModulesStr,
                    EnabledBusinessModules = businessModulesStr,
                    EnabledFeatures = featuresStr
                };
                _context.SystemConfigurations.Add(newConfig);
            }
            else
            {
                existingConfig.CompanyName = model.CompanyName;
                existingConfig.EnabledCoreModules = coreModulesStr;
                existingConfig.EnabledBusinessModules = businessModulesStr;
                existingConfig.EnabledFeatures = featuresStr;
            }

            await _context.SaveChangesAsync();
            return Ok(new { message = "تم حفظ إعدادات المستخدم بنجاح" });
        }
    }
}