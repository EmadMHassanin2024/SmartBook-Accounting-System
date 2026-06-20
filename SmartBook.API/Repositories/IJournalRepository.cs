using SmartBook.API.DTOs;

namespace SmartBook.API.Repositories
{
    public interface IJournalRepository
    {
        // 1. إنشاء قيد
        Task<bool> CreateJournalEntryAsync(CreateJournalEntryDto dto);
        // 2. جلب جميع القيود
        Task<IEnumerable<JournalEntryResponseDto>> GetAllJournalEntriesAsync();

        // 3. حذف قيد (حسب ID)
        Task<bool> DeleteJournalEntryAsync(int entryId);

        // 4. تعديل قيد
        Task<bool> UpdateJournalEntryAsync(int entryId, CreateJournalEntryDto dto);

        // 5. جلب دفتر الأستاذ (الجديد)
 
        Task<LedgerResultDto> GetAccountLedgerAsync(int accountId, DateTime from, DateTime to);


    }
}
