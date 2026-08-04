namespace SmartBook.API.DTOs
{
    public class SystemSettingsDto
    {

        public string CompanyName { get; set; }
        public List<string> EnabledCoreModules { get; set; } // أو List<int> حسب الـ Enum
        public List<string> EnabledBusinessModules { get; set; }
        public List<string> EnabledFeatures { get; set; }
    }
}
