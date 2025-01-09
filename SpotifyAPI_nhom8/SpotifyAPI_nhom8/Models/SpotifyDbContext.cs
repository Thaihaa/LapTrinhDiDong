using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Data
{
    public class SpotifyDbContext : IdentityDbContext<User>
    {
        public SpotifyDbContext(DbContextOptions<SpotifyDbContext> options) : base(options) { }

        public DbSet<Song> Songs { get; set; }
        public DbSet<Singer> Singers { get; set; }
        public DbSet<Album> Albums { get; set; }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.Entity<User>().Property(u => u.Initials).HasMaxLength(5);
            builder.HasDefaultSchema("identity");
        }
    }
}
