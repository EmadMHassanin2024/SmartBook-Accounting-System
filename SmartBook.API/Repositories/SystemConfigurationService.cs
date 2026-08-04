using Microsoft.EntityFrameworkCore;
using SmartBook.API.Data;
using SmartBook.API.DTOs;
using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public class SystemConfigurationService : ISystemConfigurationService
    {
        private readonly SmartBookDbContext _context;

        public SystemConfigurationService(SmartBookDbContext context) => _context = context;

        public async Task<SystemSettingsDto> GetConfigurationAsync()
        {
            var config = await _context.SystemConfigurations.FirstOrDefaultAsync(c => c.Id == 1);
            if (config == null) return new SystemSettingsDto();

            return new SystemSettingsDto
            {
                CompanyName = config.CompanyName,
                EnabledCoreModules = config.EnabledCoreModules.Split(',').ToList(),
                EnabledBusinessModules = config.EnabledBusinessModules.Split(',').ToList(),
                EnabledFeatures = config.EnabledFeatures.Split(',').ToList()
            };
        }

        public async Task<bool> SaveConfigurationAsync(SystemSettingsDto dto)
        {
            var config = await _context.SystemConfigurations.FirstOrDefaultAsync(c => c.Id == 1)
                         ?? new SystemConfiguration { Id = 1 };

            config.CompanyName = dto.CompanyName;
            config.EnabledCoreModules = string.Join(",", dto.EnabledCoreModules);
            config.EnabledBusinessModules = string.Join(",", dto.EnabledBusinessModules);
            config.EnabledFeatures = string.Join(",", dto.EnabledFeatures);

            if (config.Id == 0) _context.SystemConfigurations.Add(config);
            else _context.SystemConfigurations.Update(config);

            return await _context.SaveChangesAsync() > 0;
        }
    }
}
