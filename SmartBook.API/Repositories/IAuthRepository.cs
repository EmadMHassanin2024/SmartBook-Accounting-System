using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{
    public interface IAuthRepository
    {
        // تأكد أن النوع هنا Users وليس User
        Task<User> Login(string username, string password);
        string CreateToken(User user);

 
        Task<User> Register(User user, string password); // دالة التسجيل
        Task<bool> UserExists(string username);         // دالة التحقق
 
    }
}