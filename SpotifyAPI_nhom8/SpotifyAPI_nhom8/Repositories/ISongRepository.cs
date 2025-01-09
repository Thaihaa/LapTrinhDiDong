using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Repositories
{
    public interface ISongRepository
    {
        Task<IEnumerable<Song>> GetAllAsync();
        Task<Song> GetByIdAsync(int id);
        Task AddAsync(Song song);
        Task UpdateAsync(Song song);
        Task DeleteAsync(Song song);
    }
}
