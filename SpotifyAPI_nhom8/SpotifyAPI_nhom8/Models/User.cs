using Microsoft.AspNetCore.Identity;

namespace SpotifyAPI_nhom8.Models
{
    public class User : IdentityUser
    {
        public string? Initials { get; set; }
        //User = IdentityUser + string Inititals 
    }
}
