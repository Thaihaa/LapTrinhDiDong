using Microsoft.AspNetCore.Authorization; 
using Microsoft.AspNetCore.Mvc;
using SpotifyAPI_nhom8.Models;
using SpotifyAPI_nhom8.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SpotifyAPI_nhom8.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class AlbumsController : ControllerBase
    {
        private readonly IAlbumRepository _albumRepository;

        public AlbumsController(IAlbumRepository albumRepository)
        {
            _albumRepository = albumRepository;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,User")]
        public async Task<IActionResult> GetAllAlbums()
        {
            var albums = await _albumRepository.GetAllAsync();
            return Ok(albums);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,User")]
        public async Task<IActionResult> GetAlbumById(int id)
        {
            var album = await _albumRepository.GetByIdAsync(id);
            if (album == null)
                return NotFound();

            return Ok(album);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateAlbum([FromBody] Album album)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _albumRepository.AddAsync(album);
            return CreatedAtAction(nameof(GetAlbumById), new { id = album.Id }, album);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> UpdateAlbum(int id, [FromBody] Album album)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existingAlbum = await _albumRepository.GetByIdAsync(id);
            if (existingAlbum == null)
                return NotFound();

            existingAlbum.Name = album.Name;
            existingAlbum.ArtUrl = album.ArtUrl;

            await _albumRepository.UpdateAsync(existingAlbum);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteAlbum(int id)
        {
            var album = await _albumRepository.GetByIdAsync(id);
            if (album == null)
                return NotFound();

            await _albumRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}
