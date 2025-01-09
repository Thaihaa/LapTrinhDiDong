using Microsoft.AspNetCore.Identity;
using SpotifyAPI_nhom8.Models;
using SpotifyAPI_nhom8.Services;

public class AuthService : IAuthService
{
    private readonly UserManager<User> _userManager;

    public AuthService(UserManager<User> userManager)
    {
        _userManager = userManager;
    }

    public async Task SendPasswordResetEmailAsync(string email, string resetLink)
    {
        // Giả lập gửi email (hoặc thay thế bằng dịch vụ thực tế như SendGrid)
        Console.WriteLine($"Send reset link to {email}: {resetLink}");
    }

    public async Task<string> GeneratePasswordResetTokenAsync(User user)
    {
        return await _userManager.GeneratePasswordResetTokenAsync(user);
    }

    public async Task<bool> ResetPasswordAsync(User user, string token, string newPassword)
    {
        var result = await _userManager.ResetPasswordAsync(user, token, newPassword);
        return result.Succeeded;
    }
}
