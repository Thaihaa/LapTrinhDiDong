using Microsoft.EntityFrameworkCore;
using SpotifyAPI_nhom8.Data;
using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Repositories
{
    public class SingerRepository : ISingerRepository
    {
        private readonly SpotifyDbContext _context;

        public SingerRepository(SpotifyDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Singer>> GetAllAsync()
        {
            return await _context.Singers.ToListAsync();
        }

        public async Task<Singer> GetByIdAsync(int id)
        {
            return await _context.Singers.FindAsync(id);
        }

        public async Task AddAsync(Singer singer)
        {
            _context.Singers.Add(singer);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Singer singer)
        {
            _context.Singers.Update(singer);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Singer singer)
        {
            _context.Singers.Remove(singer);
            await _context.SaveChangesAsync();
        }
    }
}
