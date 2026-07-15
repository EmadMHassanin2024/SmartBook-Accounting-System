namespace SmartBook.API.DTOs
{
    public class ContactUpdateDto
    {

        // 1. البيانات القابلة للتعديل دائماً (بيانات الاتصال)
        public string Phone { get; set; }

        public string TaxNumber { get; set; }

        // أضفت حقل العنوان لأنه عادة ما يكون ضمن البيانات القابلة للتعديل
        public string Address { get; set; }

        // 2. الاسم: اختياري (يتم تحديثه فقط إذا لم يكن للعميل حركات مالية)
        public string Name { get; set; }
    }
}
