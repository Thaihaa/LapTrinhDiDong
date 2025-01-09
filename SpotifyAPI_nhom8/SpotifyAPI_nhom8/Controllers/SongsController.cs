using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpotifyAPI_nhom8.Models;
using SpotifyAPI_nhom8.Repositories;

namespace SpotifyAPI_nhom8.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SongsController : ControllerBase
    {
        private readonly ISongRepository _songRepository;

        public SongsController(ISongRepository songRepository)
        {
            _songRepository = songRepository;
        }
        [Authorize(Roles = "Admin,User")]
        [HttpGet]
        public async Task<IActionResult> GetSongs()
        {
            var songs = await _songRepository.GetAllAsync();
            return Ok(songs);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> GetSong(int id)
        {
            var song = await _songRepository.GetByIdAsync(id);
            if (song == null) return NotFound();
            return Ok(song);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateSong(Song song)
        {
            await _songRepository.AddAsync(song);
            return CreatedAtAction(nameof(GetSong), new { id = song.Id }, song);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> UpdateSong(int id, Song song)
        {
            var existingSong = await _songRepository.GetByIdAsync(id);
            if (existingSong == null) return NotFound();

            existingSong.Name = song.Name;
            existingSong.Singer = song.Singer;
            existingSong.Album = song.Album;
            existingSong.Duration = song.Duration;
            existingSong.AudioUrl = song.AudioUrl; // Cập nhật AudioUrl

            await _songRepository.UpdateAsync(existingSong);
            return Ok(existingSong);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSong(int id)
        {
            var song = await _songRepository.GetByIdAsync(id);
            if (song == null) return NotFound();

            await _songRepository.DeleteAsync(song);
            return NoContent();
        }
    }
}
