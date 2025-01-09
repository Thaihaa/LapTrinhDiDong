using Microsoft.AspNetCore.Mvc;
using SpotifyAPI_nhom8.Models;
using SpotifyAPI_nhom8.Repositories;

namespace SpotifyAPI_nhom8.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SingersController : ControllerBase
    {
        private readonly ISingerRepository _singerRepository;

        public SingersController(ISingerRepository singerRepository)
        {
            _singerRepository = singerRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetSingers()
        {
            var singers = await _singerRepository.GetAllAsync();
            return Ok(singers);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetSinger(int id)
        {
            var singer = await _singerRepository.GetByIdAsync(id);
            if (singer == null) return NotFound();
            return Ok(singer);
        }

        [HttpPost]
        public async Task<IActionResult> CreateSinger(Singer singer)
        {
            await _singerRepository.AddAsync(singer);
            return CreatedAtAction(nameof(GetSinger), new { id = singer.Id }, singer);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateSinger(int id, Singer singer)
        {
            var existingSinger = await _singerRepository.GetByIdAsync(id);
            if (existingSinger == null) return NotFound();

            existingSinger.Name = singer.Name;
            existingSinger.Genre = singer.Genre;

            await _singerRepository.UpdateAsync(existingSinger);
            return Ok(existingSinger);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSinger(int id)
        {
            var singer = await _singerRepository.GetByIdAsync(id);
            if (singer == null) return NotFound();

            await _singerRepository.DeleteAsync(singer);
            return NoContent();
        }
    }
}
