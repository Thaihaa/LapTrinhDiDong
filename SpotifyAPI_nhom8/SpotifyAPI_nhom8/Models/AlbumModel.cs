using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace SpotifyAPI_nhom8.Models
{
    public class Album
    {
        [Key]
        public int Id { get; set; } // ID của album
        [Required]
        public string Name { get; set; } // Tên album
        public string ArtUrl { get; set; } // URL hình ảnh của album
        public ICollection<Song> Songs { get; set; } // Danh sách bài hát trong album
    }
}
