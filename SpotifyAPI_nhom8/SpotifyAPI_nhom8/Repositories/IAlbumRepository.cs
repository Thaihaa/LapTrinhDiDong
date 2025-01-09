using System.Collections.Generic;
using System.Threading.Tasks;
using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Repositories
{
    public interface IAlbumRepository
    {
        Task<IEnumerable<Album>> GetAllAsync();
        Task<Album> GetByIdAsync(int id);
        Task AddAsync(Album album);
        Task UpdateAsync(Album album);
        Task DeleteAsync(int id);
    }
}
