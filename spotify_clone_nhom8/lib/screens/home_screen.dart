import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone_nhom8/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone_nhom8/core/configs/assets/app_images.dart';
import 'package:spotify_clone_nhom8/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone_nhom8/screens/lyrics_screen.dart';
import 'package:spotify_clone_nhom8/screens/profile_screen.dart';
import 'package:spotify_clone_nhom8/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<dynamic> _songs = [];
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchSongs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<String?> _getJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchSongs() async {
    setState(() {
      _isLoading = true;
    });

    final String? token = await _getJwtToken();
    if (token == null) {
      print('No JWT token found');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final apiService = ApiService();
      final songs = await apiService.fetchSongs(token);

      if (mounted) {
        setState(() {
          _songs = songs;
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching songs: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void playAudio(String audioUrl, String songName, String singerName,
      String albumArtUrl, String lyrics) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          audioUrl: audioUrl,
          songName: songName,
          singerName: singerName,
          albumArtUrl: albumArtUrl,
          lyrics: lyrics,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const ProfileScreen(),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Căn lề trái cho chữ "Danh Sách Nhạc"
        children: [
          _homeTopCard(),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0), // Thụt vào và thêm khoảng cách
            child: Divider(
              color: Colors.grey, // Màu đường gạch
              thickness: 1, // Độ dày của đường gạch
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0), // Thụt vào chữ "Danh Sách Nhạc"
            child: Text(
              'Danh Sách Nhạc', // Nội dung
              style: TextStyle(
                fontSize: 30, // Kích thước chữ
                fontWeight: FontWeight.bold, // In đậm
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _songs.isEmpty
                    ? const Center(child: Text('No songs available'))
                    : ListView.builder(
                        itemCount: _songs.length,
                        itemBuilder: (context, index) {
                          final song = _songs[index];
                          return Card(
                            child: ListTile(
                              leading: song.albumArtUrl != null
                                  ? Image.network(
                                      song.albumArtUrl!,
                                      width: 50,
                                      height: 50,
                                    )
                                  : const Icon(Icons.music_note),
                              title: Text(song.name ?? 'Unknown'),
                              subtitle: Text('${song.singer} - ${song.album}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  playAudio(
                                    song.audioUrl ?? '',
                                    song.name ?? 'Unknown',
                                    song.singer ?? 'Unknown',
                                    song.albumArtUrl ?? '',
                                    'Không có lời bài hát',
                                  );
                                },
                              ),
                            ),
                          );
                        }),
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NowPlayingScreen extends StatefulWidget {
  final String audioUrl;
  final String songName;
  final String singerName;
  final String albumArtUrl;
  final String lyrics;

  const NowPlayingScreen({
    Key? key,
    required this.audioUrl,
    required this.songName,
    required this.singerName,
    required this.albumArtUrl,
    required this.lyrics,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _audioPlayer.play(UrlSource(widget.audioUrl));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now playing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Thêm chức năng khác nếu cần
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hình ảnh album
          widget.albumArtUrl.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.albumArtUrl,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const Icon(Icons.music_note, size: 100),

          // Tên bài hát và nghệ sĩ
          Column(
            children: [
              Text(
                widget.songName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.singerName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          // Thanh trượt và thời gian
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Colors.black,
                  trackHeight: 2.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 12.0),
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0.0,
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)),
                    Text(_formatDuration(_duration)),
                  ],
                ),
              ),
            ],
          ),

          // Nút điều khiển
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 40),
                onPressed: () {
                  // Thêm chức năng Skip Previous
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.pause_circle_filled,
                  size: 64,
                  color: Colors.green,
                ),
                onPressed: () async {
                  await _audioPlayer.pause();
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 40),
                onPressed: () {
                  // Thêm chức năng Skip Next
                },
              ),
            ],
          ),

          // Phần Lyrics
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LyricsScreen(
                    songName: widget.songName,
                    singerName: widget.singerName,
                    lyrics: widget.lyrics,
                  ),
                ),
              );
            },
            child: Column(
              children: const [
                Icon(
                  Icons.keyboard_arrow_up,
                  size: 30,
                  color: Colors.grey,
                ),
                Text(
                  'Lyrics',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
