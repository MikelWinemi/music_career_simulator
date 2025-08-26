import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'ui/image_manager.dart';

class SongListScreen extends StatelessWidget {
  final PlayerModel player;
  const SongListScreen({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: player,
      builder: (context, _) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  decoration: AppTheme.cardDecoration,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.library_music,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('My Songs', style: AppTheme.titleLarge),
                            Text(
                              '${player.songs.length} songs in your catalog',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: player.songs.isEmpty
                      ? _buildEmptyState()
                      : _buildSongsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Songs Yet!',
              style: AppTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Start writing songs to build your music catalog and advance your career.',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: player.songs.length,
      itemBuilder: (context, index) {
        final song = player.songs[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.cardBackground,
                        AppTheme.cardBackground.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: song.isRecorded
                          ? AppTheme.accentGold.withOpacity(0.3)
                          : AppTheme.primaryPurple.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (song.isRecorded
                                    ? AppTheme.accentGold
                                    : AppTheme.primaryPurple)
                                .withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showSongDetails(context, song),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: Hero(
                          tag: 'song_${song.title}_$index',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: song.coverImagePath != null
                                  ? ImageManager.getImageWidget(
                                      song.coverImagePath,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: song.isRecorded
                                            ? AppTheme.goldGradient
                                            : LinearGradient(
                                                colors: [
                                                  AppTheme.primaryPurple,
                                                  AppTheme.primaryPurple
                                                      .withOpacity(0.7),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (song.isRecorded
                                                        ? AppTheme.accentGold
                                                        : AppTheme
                                                              .primaryPurple)
                                                    .withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        song.isRecorded
                                            ? Icons.album
                                            : Icons.edit,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: AppTheme.titleMedium.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              song.genre,
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (song.albumTitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Album: ${song.albumTitle}',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: song.isRecorded
                                        ? AppTheme.successGreen.withOpacity(0.2)
                                        : AppTheme.warningOrange.withOpacity(
                                            0.2,
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: song.isRecorded
                                          ? AppTheme.successGreen
                                          : AppTheme.warningOrange,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    song.isRecorded ? 'RECORDED' : 'DEMO',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: song.isRecorded
                                          ? AppTheme.successGreen
                                          : AppTheme.warningOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (song.isRecorded) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.goldGradient,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentGold
                                              .withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${song.quality}%',
                                          style: AppTheme.bodySmall.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                if (song.isRecorded) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: song.isPublished
                                          ? AppTheme.primaryPurple.withOpacity(
                                              0.2,
                                            )
                                          : AppTheme.textMuted.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: song.isPublished
                                            ? AppTheme.primaryPurple
                                            : AppTheme.textMuted,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      song.isPublished ? 'PUBLISHED' : 'READY',
                                      style: AppTheme.bodySmall.copyWith(
                                        color: song.isPublished
                                            ? AppTheme.primaryPurple
                                            : AppTheme.textMuted,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: song.isRecorded
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (song.isPublished) ...[
                                    Text(
                                      'Streams',
                                      style: AppTheme.bodySmall.copyWith(
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    Text(
                                      '${_formatNumber(song.popularity.streams)}',
                                      style: AppTheme.bodyLarge.copyWith(
                                        color: AppTheme.primaryPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (song.isViral)
                                          const Icon(
                                            Icons.local_fire_department,
                                            color: Colors.red,
                                            size: 16,
                                          )
                                        else if (song.isHit)
                                          const Icon(
                                            Icons.trending_up,
                                            color: Colors.orange,
                                            size: 16,
                                          )
                                        else if (song.popularity.isPopular)
                                          const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        if (song.isCharting)
                                          Text(
                                            '#${song.chartPosition}',
                                            style: AppTheme.bodySmall.copyWith(
                                              color: AppTheme.accentGold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ] else ...[
                                    ElevatedButton(
                                      onPressed: () =>
                                          _publishSong(context, song),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryPurple,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                      ),
                                      child: const Text(
                                        'Publish',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ready to release',
                                      style: AppTheme.bodySmall.copyWith(
                                        color: AppTheme.textMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryPurple.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.primaryPurple,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSongDetails(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: song.coverImagePath != null
                        ? ImageManager.getImageWidget(
                            song.coverImagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: song.isRecorded
                                  ? AppTheme.goldGradient
                                  : AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (song.isRecorded
                                              ? AppTheme.accentGold
                                              : AppTheme.primaryPurple)
                                          .withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              song.isRecorded ? Icons.album : Icons.edit,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: AppTheme.titleLarge.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        song.genre,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (song.albumTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Album: ${song.albumTitle}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (song.isRecorded) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withOpacity(0.1),
                      AppTheme.accentGold.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.accentGold.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSongStat('Quality', '${song.quality}%', Icons.star),
                    _buildSongStat(
                      'Streams',
                      song.isPublished
                          ? _formatNumber(song.popularity.streams)
                          : 'Not Published',
                      Icons.play_arrow,
                    ),
                    _buildSongStat(
                      'Revenue',
                      '\$${song.revenue.toStringAsFixed(0)}',
                      Icons.attach_money,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.warningOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.warningOrange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.warningOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This song is still a demo. Record it in the studio to start earning money and gaining fans!',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.warningOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Cover Image Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cover Image',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _changeCoverImage(context, song),
                  icon: Icon(
                    song.coverImagePath != null
                        ? Icons.edit
                        : Icons.add_photo_alternate,
                    size: 16,
                  ),
                  label: Text(
                    song.coverImagePath != null ? 'Change' : 'Add Cover',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSongStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textMuted),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toString();
    }
  }

  void _publishSong(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Publish Song',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ready to publish "${song.title}"?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.accentGold,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Publishing Details:',
                        style: TextStyle(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Initial streams based on your fame (${player.fame}) and song quality (${song.quality}%)\n'
                    '• Song will grow in popularity over time\n'
                    '• Higher quality and fame = better initial performance\n'
                    '• Track performance in the song list',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              player.publishSong(song);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Published "${song.title}"! Check back regularly to see how it\'s performing.',
                  ),
                  backgroundColor: AppTheme.primaryPurple,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _changeCoverImage(BuildContext context, Song song) async {
    final imagePath = await ImageManager.showImagePickerDialog(
      context,
      type: 'song',
      name: song.title,
    );

    if (imagePath != null) {
      // Delete old image if it exists
      if (song.coverImagePath != null) {
        await ImageManager.deleteImage(song.coverImagePath);
      }

      // Update song with new image path
      song.coverImagePath = imagePath;
      player.saveData();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cover image updated for "${song.title}"!'),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
