using SmartBook.API.DTOs;
using SmartBook.API.Models;

namespace SmartBook.API.Repositories
{

    public interface IProductRepository
    {
        Task<IEnumerable<Product>> GetAllAsync();
        Task<Product> AddAsync(Product product);
        Task<string> UpdateStockAndLogAdjustment(InventoryAdjustmentDto model);
        Task<bool> ReverseAdjustment(int logId);


    }
}
 
