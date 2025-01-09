using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Repositories
{
    public interface ISingerRepository
    {
        Task<IEnumerable<Singer>> GetAllAsync();
        Task<Singer> GetByIdAsync(int id);
        Task AddAsync(Singer singer);
        Task UpdateAsync(Singer singer);
        Task DeleteAsync(Singer singer);
    }
}
