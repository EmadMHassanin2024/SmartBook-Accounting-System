namespace SmartBook.API.Models
{
    public class SystemConfiguration
    {

        public int Id { get; set; }
        public string UserId { get; set; }

        public string CompanyName { get; set; }
        // يمكن تخزين القوائم كـ Strings مفصولة بفواصل أو كـ JSON
        public string EnabledCoreModules { get; set; }
        public string EnabledBusinessModules { get; set; }
        public string EnabledFeatures { get; set; }
        //آخر وقت تم فيه تعديل السجل.
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
