using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SpotifyAPI_nhom8.Data;
using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Repositories
{
    public class AlbumRepository : IAlbumRepository
    {
        private readonly SpotifyDbContext _context;

        public AlbumRepository(SpotifyDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Album>> GetAllAsync()
        {
            return await _context.Albums.Include(a => a.Songs).ToListAsync();
        }

        public async Task<Album> GetByIdAsync(int id)
        {
            return await _context.Albums.Include(a => a.Songs).FirstOrDefaultAsync(a => a.Id == id);
        }

        public async Task AddAsync(Album album)
        {
            _context.Albums.Add(album);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Album album)
        {
            _context.Albums.Update(album);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var album = await GetByIdAsync(id);
            if (album != null)
            {
                _context.Albums.Remove(album);
                await _context.SaveChangesAsync();
            }
        }
    }
}
