 using SmartBook.API.DTOs;
using SmartBook.API.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SmartBook.API.Repositories
{
    public interface IVoucherRepository
    {
        // إضافة سند جديد وتحديث الأرصدة
   
        Task<bool> CreateVoucherAsync(VoucherRequest request, int userId);

        // جلب قائمة بجميع السندات (استخدمنا Voucher بالمفرد كما في الموديل الخاص بك)
        Task<IEnumerable<Voucher>> GetAllVouchersAsync();

        // جلب تفاصيل سند معين
        Task<Voucher> GetVoucherByIdAsync(int id);
    }
}