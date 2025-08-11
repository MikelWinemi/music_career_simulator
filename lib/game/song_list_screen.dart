import 'package:flutter/material.dart';
import 'player_model.dart';

class SongListScreen extends StatelessWidget {
  final PlayerModel player;
  const SongListScreen({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: player,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16213E),
          title: const Text(
            'My Songs',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${player.songs.length} Songs',
                  style: const TextStyle(
                    color: Color(0xFF53A0E8),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: player.songs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: 64, color: Colors.white30),
                    SizedBox(height: 16),
                    Text(
                      'No songs yet!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start writing songs to build your career',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: player.songs.length,
                itemBuilder: (context, index) {
                  final song = player.songs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF16213E).withOpacity(0.8),
                          const Color(0xFF0F3460).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: song.isRecorded
                            ? const Color(0xFF53A0E8)
                            : Colors.white10,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: song.isRecorded
                              ? const Color(0xFF53A0E8)
                              : const Color(0xFF9C27B0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          song.isRecorded ? Icons.album : Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Genre: ${song.genre}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: _getQualityColor(song.quality),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Quality: ${song.quality}%',
                                style: TextStyle(
                                  color: _getQualityColor(song.quality),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (song.isRecorded) ...[
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF53A0E8),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Recorded',
                                  style: TextStyle(
                                    color: Color(0xFF53A0E8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.edit,
                                  color: Color(0xFF9C27B0),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Draft',
                                  style: TextStyle(
                                    color: Color(0xFF9C27B0),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      trailing: song.isRecorded
                          ? null
                          : IconButton(
                              onPressed: () => _showRecordDialog(context, song),
                              icon: const Icon(
                                Icons.mic,
                                color: Color(0xFFE94560),
                              ),
                            ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showWriteSongDialog(context),
          backgroundColor: const Color(0xFF9C27B0),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Color _getQualityColor(int quality) {
    if (quality >= 80) return const Color(0xFF4CAF50); // Green
    if (quality >= 60) return const Color(0xFFFF9800); // Orange
    if (quality >= 40) return const Color(0xFFFFC107); // Yellow
    return const Color(0xFFE94560); // Red
  }

  void _showWriteSongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Write New Song',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a new song for your career!',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFFE94560), size: 16),
                const SizedBox(width: 4),
                Text(
                  'Energy Cost: 10',
                  style: TextStyle(
                    color: player.energy >= 10 ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: player.energy >= 10
                ? () {
                    player.writeSong();
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            child: const Text(
              'Write Song',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecordDialog(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          'Record "${song.title}"',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Record this song in the studio to make it available for streaming and performances.',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFFE94560), size: 16),
                const SizedBox(width: 4),
                Text(
                  'Energy: 20',
                  style: TextStyle(
                    color: player.energy >= 20 ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Cost: \$500',
                  style: TextStyle(
                    color: player.money >= 500 ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: (player.energy >= 20 && player.money >= 500)
                ? () {
                    player.recordSong(song);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94560),
            ),
            child: const Text('Record', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
