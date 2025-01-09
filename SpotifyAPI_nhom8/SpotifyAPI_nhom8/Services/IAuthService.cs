using SpotifyAPI_nhom8.Models;

namespace SpotifyAPI_nhom8.Services
{
    public interface IAuthService
    {
        Task SendPasswordResetEmailAsync(string email, string resetLink);
        Task<string> GeneratePasswordResetTokenAsync(User user);
        Task<bool> ResetPasswordAsync(User user, string token, string newPassword);
    }

}
