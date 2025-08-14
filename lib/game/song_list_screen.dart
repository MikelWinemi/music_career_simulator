import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

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
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: AppTheme.cardDecoration,
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: song.isRecorded
                    ? AppTheme.primaryGradient
                    : LinearGradient(
                        colors: [
                          AppTheme.warningOrange.withOpacity(0.8),
                          AppTheme.warningOrange.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        (song.isRecorded
                                ? AppTheme.primaryPurple
                                : AppTheme.warningOrange)
                            .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                song.isRecorded ? Icons.album : Icons.edit,
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Text(
              song.title,
              style: AppTheme.titleMedium.copyWith(color: AppTheme.textPrimary),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  song.genre,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentGold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: song.isRecorded
                            ? AppTheme.successGreen.withOpacity(0.2)
                            : AppTheme.warningOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: song.isRecorded
                              ? AppTheme.successGreen
                              : AppTheme.warningOrange,
                        ),
                      ),
                      child: Text(
                        song.isRecorded ? 'RECORDED' : 'DEMO',
                        style: AppTheme.bodySmall.copyWith(
                          color: song.isRecorded
                              ? AppTheme.successGreen
                              : AppTheme.warningOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (song.isRecorded) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentGold),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.accentGold,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${song.quality}%',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                      Text('Streams', style: AppTheme.bodySmall),
                      Text(
                        '${song.quality * 10}', // Use quality as a basis for display
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ),
        );
      },
    );
  }
}
