import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class PerformanceAnalyticsScreen extends StatefulWidget {
  final PlayerModel player;

  const PerformanceAnalyticsScreen({required this.player, super.key});

  @override
  State<PerformanceAnalyticsScreen> createState() =>
      _PerformanceAnalyticsScreenState();
}

class _PerformanceAnalyticsScreenState extends State<PerformanceAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'streams'; // 'streams', 'quality', 'recent'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.player,
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
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Performance Analytics', style: AppTheme.titleLarge),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Week ${widget.player.week}, ${widget.player.year}',
                          style: AppTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),

                // Statistics Overview
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentGold.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Career Overview',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.accentGold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Songs',
                              widget.player.songs.length.toString(),
                              Icons.music_note,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Albums',
                              widget.player.albums.length.toString(),
                              Icons.album,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Streams',
                              _formatNumber(_getTotalStreams()),
                              Icons.play_arrow,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Revenue',
                              '\$${_formatNumber(_getTotalRevenue())}',
                              Icons.attach_money,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.accentGold,
                    unselectedLabelColor: AppTheme.textSecondary,
                    indicatorColor: AppTheme.accentGold,
                    tabs: const [
                      Tab(text: 'Songs'),
                      Tab(text: 'Albums'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Sort Controls
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Sort by:', style: AppTheme.bodyMedium),
                      const SizedBox(width: 12),
                      _buildSortButton('Streams', 'streams'),
                      const SizedBox(width: 8),
                      _buildSortButton('Quality', 'quality'),
                      const SizedBox(width: 8),
                      _buildSortButton('Recent', 'recent'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildSongsTab(), _buildAlbumsTab()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(value, style: AppTheme.bodyLarge.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, String value) {
    bool isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentGold : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentGold
                : AppTheme.textSecondary.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: isSelected ? Colors.black : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSongsTab() {
    List<Song> sortedSongs = List.from(widget.player.songs);

    switch (_sortBy) {
      case 'streams':
        sortedSongs.sort(
          (a, b) => b.popularity.streams.compareTo(a.popularity.streams),
        );
        break;
      case 'quality':
        sortedSongs.sort((a, b) => b.quality.compareTo(a.quality));
        break;
      case 'recent':
        sortedSongs.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
    }

    if (sortedSongs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No songs yet',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Create your first song to see analytics',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: sortedSongs.length,
      itemBuilder: (context, index) {
        return _buildSongCard(sortedSongs[index], index + 1);
      },
    );
  }

  Widget _buildAlbumsTab() {
    List<Album> sortedAlbums = List.from(widget.player.albums);

    switch (_sortBy) {
      case 'streams':
        sortedAlbums.sort((a, b) => b.totalStreams.compareTo(a.totalStreams));
        break;
      case 'quality':
        sortedAlbums.sort(
          (a, b) => b.averageQuality.compareTo(a.averageQuality),
        );
        break;
      case 'recent':
        sortedAlbums.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
    }

    if (sortedAlbums.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.album,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No albums yet',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Create your first album to see analytics',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: sortedAlbums.length,
      itemBuilder: (context, index) {
        return _buildAlbumCard(sortedAlbums[index], index + 1);
      },
    );
  }

  Widget _buildSongCard(Song song, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: AppTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${song.genre} • ${_formatReleaseDate(song.releaseDate)}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _getPerformanceIcon(song),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricColumn(
                  'Streams',
                  _formatNumber(song.popularity.streams),
                  Icons.play_arrow,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Quality',
                  '${song.quality}%',
                  Icons.star,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Revenue',
                  '\$${_formatNumber(song.revenue.round())}',
                  Icons.attach_money,
                  Colors.blue,
                ),
              ),
              if (song.isCharting)
                Expanded(
                  child: _buildMetricColumn(
                    'Chart Pos.',
                    '#${song.popularity.peakPosition}',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
            ],
          ),
          if (song.albumTitle != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Album: ${song.albumTitle}',
                style: AppTheme.bodySmall.copyWith(color: AppTheme.accentGold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlbumCard(Album album, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.title,
                      style: AppTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${album.genre} • ${album.songs.length} tracks • ${_formatReleaseDate(album.releaseDate)}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _getAlbumPerformanceIcon(album),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricColumn(
                  'Total Streams',
                  _formatNumber(album.totalStreams),
                  Icons.play_arrow,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Avg Quality',
                  '${album.averageQuality.round()}%',
                  Icons.star,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Total Revenue',
                  '\$${_formatNumber(album.totalRevenue.round())}',
                  Icons.attach_money,
                  Colors.blue,
                ),
              ),
            ],
          ),
          if (album.collaborators.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Collab: ${album.collaborators.join(", ")}',
                style: AppTheme.bodySmall.copyWith(color: Colors.purple),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Flexible(
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _getPerformanceIcon(Song song) {
    if (song.isViral) {
      return const Icon(Icons.whatshot, color: Colors.red, size: 24);
    } else if (song.isHit) {
      return const Icon(Icons.trending_up, color: Colors.orange, size: 24);
    } else if (song.popularity.isPopular) {
      return const Icon(Icons.thumb_up, color: Colors.green, size: 24);
    } else {
      return const Icon(Icons.music_note, color: Colors.grey, size: 24);
    }
  }

  Widget _getAlbumPerformanceIcon(Album album) {
    if (album.totalStreams > 1000000) {
      return const Icon(Icons.whatshot, color: Colors.red, size: 24);
    } else if (album.totalStreams > 500000) {
      return const Icon(Icons.trending_up, color: Colors.orange, size: 24);
    } else if (album.totalStreams > 100000) {
      return const Icon(Icons.thumb_up, color: Colors.green, size: 24);
    } else {
      return const Icon(Icons.album, color: Colors.grey, size: 24);
    }
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber; // Gold
    if (rank == 2) return Colors.grey; // Silver
    if (rank == 3) return Colors.brown; // Bronze
    return Colors.blueGrey;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  String _formatReleaseDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  int _getTotalStreams() {
    return widget.player.songs.fold(
      0,
      (sum, song) => sum + song.popularity.streams,
    );
  }

  int _getTotalRevenue() {
    return widget.player.songs.fold(
      0,
      (sum, song) => sum + song.revenue.round(),
    );
  }
}
