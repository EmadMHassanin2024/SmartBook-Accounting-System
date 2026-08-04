using SmartBook.API.DTOs;

namespace SmartBook.API.Repositories
{
    public interface ISystemConfigurationService
    {
        Task<SystemSettingsDto> GetConfigurationAsync();
        Task<bool> SaveConfigurationAsync(SystemSettingsDto dto);
    }
}
