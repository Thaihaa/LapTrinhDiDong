namespace SpotifyAPI_nhom8.Models
{
    public class Song
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Singer { get; set; }
        public string Album { get; set; }
        public int Duration { get; set; }
        public string AudioUrl { get; set; } 
        public string AlbumArtUrl { get; set; }
    }
}
