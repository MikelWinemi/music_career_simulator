import 'package:flutter/material.dart';
import 'dart:math';
import 'player_model.dart';
import 'ui/app_theme.dart';

class ChartsScreen extends StatefulWidget {
  final PlayerModel player;

  const ChartsScreen({required this.player, super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _timeFilter = 'month'; // 'week', 'month', 'all'

  // Track artist names for competitor songs and albums
  final Map<String, String> _songArtists = {};
  final Map<String, String> _albumArtists = {};

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
                      Text('Top Charts', style: AppTheme.titleLarge),
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

                // Time Filter
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Period:', style: AppTheme.bodyMedium),
                      const SizedBox(width: 12),
                      _buildTimeFilterButton('This Week', 'week'),
                      const SizedBox(width: 8),
                      _buildTimeFilterButton('This Month', 'month'),
                      const SizedBox(width: 8),
                      _buildTimeFilterButton('All Time', 'all'),
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
                      Tab(text: 'Top Songs'),
                      Tab(text: 'Top Albums'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildTopSongsTab(), _buildTopAlbumsTab()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterButton(String label, String value) {
    bool isSelected = _timeFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _timeFilter = value;
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

  Widget _buildTopSongsTab() {
    List<Song> topSongs = _getTopSongs();

    if (topSongs.isEmpty) {
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
              'No songs in charts yet',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Create songs to see top charts',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Chart Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentGold.withOpacity(0.2),
                AppTheme.primaryPurple.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.trending_up, color: AppTheme.accentGold, size: 24),
              const SizedBox(width: 8),
              Text(
                'Top 10 Songs',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.accentGold,
                ),
              ),
              const Spacer(),
              Text(
                _getTimeFilterDescription(),
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Songs List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: topSongs.length,
            itemBuilder: (context, index) {
              return _buildChartSongCard(topSongs[index], index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopAlbumsTab() {
    List<Album> topAlbums = _getTopAlbums();

    if (topAlbums.isEmpty) {
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
              'No albums in charts yet',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Create albums to see top charts',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Chart Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple.withOpacity(0.2),
                AppTheme.accentGold.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.album, color: AppTheme.primaryPurple, size: 24),
              const SizedBox(width: 8),
              Text(
                'Top 10 Albums',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryPurple,
                ),
              ),
              const Spacer(),
              Text(
                _getTimeFilterDescription(),
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Albums List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: topAlbums.length,
            itemBuilder: (context, index) {
              return _buildChartAlbumCard(topAlbums[index], index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartSongCard(Song song, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getRankBorderColor(rank)),
        boxShadow: rank <= 3
            ? [
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: rank <= 3
                  ? _getRankIcon(rank)
                  : Text(
                      '#$rank',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: rank <= 3
                        ? _getRankColor(rank)
                        : AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'by ${_getArtistName(song)}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${song.genre} • Quality: ${song.quality}%',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(song.popularity.streams),
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.attach_money, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '\$${_formatNumber(song.revenue.round())}',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Performance Icon
          _getPerformanceIcon(song),
        ],
      ),
    );
  }

  Widget _buildChartAlbumCard(Album album, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getRankBorderColor(rank)),
        boxShadow: rank <= 3
            ? [
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: rank <= 3
                  ? _getRankIcon(rank)
                  : Text(
                      '#$rank',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Album Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: rank <= 3
                        ? _getRankColor(rank)
                        : AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'by ${_getAlbumArtistName(album)}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${album.genre} • ${album.songs.length} tracks • Avg Quality: ${album.averageQuality.round()}%',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(album.totalStreams),
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.attach_money, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '\$${_formatNumber(album.totalRevenue.round())}',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (album.collaborators.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Collab: ${album.collaborators.join(", ")}',
                      style: AppTheme.bodySmall.copyWith(color: Colors.purple),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Performance Icon
          _getAlbumPerformanceIcon(album),
        ],
      ),
    );
  }

  // Data filtering methods
  List<Song> _getTopSongs() {
    List<Song> filteredSongs = _getFilteredSongs();

    // Add competitive songs from AI artists and imported contacts
    filteredSongs.addAll(_getCompetitorSongs());

    // Apply minimum stream threshold for chart eligibility
    int minStreamsForCharts = _getMinimumStreamThreshold();
    filteredSongs = filteredSongs
        .where((song) => song.popularity.streams >= minStreamsForCharts)
        .toList();

    // Sort by streams (primary) and quality (secondary)
    filteredSongs.sort((a, b) {
      int streamComparison = b.popularity.streams.compareTo(
        a.popularity.streams,
      );
      if (streamComparison != 0) return streamComparison;
      return b.quality.compareTo(a.quality);
    });

    // Get top 10
    List<Song> topSongs = filteredSongs.take(10).toList();

    // Check for imported artists in charts and notify
    _checkImportedArtistsInCharts(topSongs, []);

    return topSongs;
  }

  List<Album> _getTopAlbums() {
    List<Album> filteredAlbums = _getFilteredAlbums();

    // Add competitive albums from AI artists and imported contacts
    filteredAlbums.addAll(_getCompetitorAlbums());

    // Apply minimum stream threshold for chart eligibility
    int minStreamsForCharts =
        _getMinimumStreamThreshold() * 3; // Albums need 3x more
    filteredAlbums = filteredAlbums
        .where((album) => album.totalStreams >= minStreamsForCharts)
        .toList();

    // Sort by total streams (primary) and average quality (secondary)
    filteredAlbums.sort((a, b) {
      int streamComparison = b.totalStreams.compareTo(a.totalStreams);
      if (streamComparison != 0) return streamComparison;
      return b.averageQuality.compareTo(a.averageQuality);
    });

    // Get top 10
    List<Album> topAlbums = filteredAlbums.take(10).toList();

    // Check for imported artists in charts and notify
    _checkImportedArtistsInCharts([], topAlbums);

    return topAlbums;
  }

  List<Song> _getFilteredSongs() {
    DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_timeFilter) {
      case 'week':
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        filterDate = now.subtract(const Duration(days: 30));
        break;
      case 'all':
      default:
        return widget.player.songs;
    }

    return widget.player.songs
        .where((song) => song.releaseDate.isAfter(filterDate))
        .toList();
  }

  List<Album> _getFilteredAlbums() {
    DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_timeFilter) {
      case 'week':
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        filterDate = now.subtract(const Duration(days: 30));
        break;
      case 'all':
      default:
        return widget.player.albums;
    }

    return widget.player.albums
        .where((album) => album.releaseDate.isAfter(filterDate))
        .toList();
  }

  // Helper methods
  String _getTimeFilterDescription() {
    switch (_timeFilter) {
      case 'week':
        return 'Last 7 days';
      case 'month':
        return 'Last 30 days';
      case 'all':
        return 'All time';
      default:
        return '';
    }
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return Colors.blueGrey;
  }

  Color _getRankBorderColor(int rank) {
    if (rank <= 3) return _getRankColor(rank);
    return AppTheme.textSecondary.withOpacity(0.3);
  }

  Widget _getRankIcon(int rank) {
    IconData icon;
    switch (rank) {
      case 1:
        icon = Icons.emoji_events; // Trophy
        break;
      case 2:
        icon = Icons.military_tech; // Medal
        break;
      case 3:
        icon = Icons.workspace_premium; // Award
        break;
      default:
        icon = Icons.star;
    }

    return Icon(icon, color: Colors.white, size: 20);
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  // Minimum stream threshold for chart eligibility - scales with player progress
  int _getMinimumStreamThreshold() {
    switch (_timeFilter) {
      case 'week':
        return 50000; // 50K streams minimum for weekly charts
      case 'month':
        return 200000; // 200K streams minimum for monthly charts
      case 'all':
        return 500000; // 500K streams minimum for all-time charts
      default:
        return 200000;
    }
  }

  // Generate competitor songs from imported contacts and AI artists
  List<Song> _getCompetitorSongs() {
    List<Song> competitorSongs = [];
    Random random = Random();

    // Create songs for imported musicians with high influence
    for (Contact contact in widget.player.contacts) {
      if (contact.type == 'musician' && contact.influence >= 7) {
        // High-influence musicians have multiple chart-worthy songs
        int songCount = contact.influence >= 9
            ? 3
            : (contact.influence >= 8 ? 2 : 1);

        for (int i = 0; i < songCount; i++) {
          competitorSongs.add(_generateCompetitorSong(contact, random));
        }
      }
    }

    // Generate additional AI competitors to fill charts
    List<String> aiArtists = [
      'Phoenix Rising',
      'Nova Sound',
      'Echo Wave',
      'Midnight Pulse',
      'Silver Storm',
      'Neon Dreams',
      'Crystal Beat',
      'Stellar Vibe',
      'Urban Flow',
      'Digital Heart',
      'Thunder Bass',
      'Cosmic Rhythm',
    ];

    for (String artistName in aiArtists) {
      competitorSongs.add(_generateAICompetitorSong(artistName, random));
    }

    return competitorSongs;
  }

  // Generate competitor albums from imported contacts and AI artists
  List<Album> _getCompetitorAlbums() {
    List<Album> competitorAlbums = [];
    Random random = Random();

    // Create albums for imported musicians with very high influence
    for (Contact contact in widget.player.contacts) {
      if (contact.type == 'musician' && contact.influence >= 8) {
        competitorAlbums.add(_generateCompetitorAlbum(contact, random));
      }
    }

    // Generate AI competitor albums
    List<String> aiArtists = [
      'Phoenix Rising',
      'Nova Sound',
      'Echo Wave',
      'Midnight Pulse',
      'Silver Storm',
      'Neon Dreams',
    ];

    for (String artistName in aiArtists) {
      competitorAlbums.add(_generateAICompetitorAlbum(artistName, random));
    }

    return competitorAlbums;
  }

  Song _generateCompetitorSong(Contact contact, Random random) {
    // Generate streams based on influence and time period
    int baseStreams = contact.influence * 100000; // 700K-1M+ for high influence
    int randomVariation = random.nextInt(baseStreams ~/ 2);
    int totalStreams = baseStreams + randomVariation;

    // Apply time filter scaling
    if (_timeFilter == 'week') {
      totalStreams = (totalStreams * 0.1).round(); // Weekly portion
    } else if (_timeFilter == 'month') {
      totalStreams = (totalStreams * 0.3).round(); // Monthly portion
    }

    Song song = Song(
      title: _generateSongTitle(contact.genre, random),
      genre: contact.genre,
      quality: 70 + random.nextInt(30), // 70-99% quality
      releaseDate: DateTime.now().subtract(Duration(days: random.nextInt(365))),
      isPublished: true,
      plays: totalStreams,
      popularity: SongPopularity(
        streams: totalStreams,
        views: (totalStreams * 0.8).round(),
        isCharting: totalStreams > 100000,
      ),
    );

    // Track the artist for this song
    String songKey = '${song.title}_${song.genre}_${song.quality}';
    _songArtists[songKey] = contact.name;

    return song;
  }

  Song _generateAICompetitorSong(String artistName, Random random) {
    List<String> genres = [
      'Pop',
      'Hip-Hop',
      'Rock',
      'Electronic',
      'R&B',
      'Alternative',
    ];
    String genre = genres[random.nextInt(genres.length)];

    // AI competitors have competitive but varied stream counts
    int baseStreams = 300000 + random.nextInt(1200000); // 300K-1.5M streams

    // Apply time filter scaling
    if (_timeFilter == 'week') {
      baseStreams = (baseStreams * 0.15).round();
    } else if (_timeFilter == 'month') {
      baseStreams = (baseStreams * 0.4).round();
    }

    Song song = Song(
      title: _generateSongTitle(genre, random),
      genre: genre,
      quality: 60 + random.nextInt(35), // 60-94% quality
      releaseDate: DateTime.now().subtract(Duration(days: random.nextInt(200))),
      isPublished: true,
      plays: baseStreams,
      popularity: SongPopularity(
        streams: baseStreams,
        views: (baseStreams * 0.75).round(),
        isCharting: baseStreams > 100000,
      ),
    );

    // Track the artist for this song
    String songKey = '${song.title}_${song.genre}_${song.quality}';
    _songArtists[songKey] = artistName;

    return song;
  }

  Album _generateCompetitorAlbum(Contact contact, Random random) {
    List<Song> albumSongs = [];
    int songCount = 8 + random.nextInt(5); // 8-12 songs

    for (int i = 0; i < songCount; i++) {
      albumSongs.add(_generateCompetitorSong(contact, random));
    }

    Album album = Album(
      title: _generateAlbumTitle(contact.genre, random),
      genre: contact.genre,
      releaseDate: DateTime.now().subtract(Duration(days: random.nextInt(365))),
      songs: albumSongs,
      isReleased: true,
    );

    // Track the artist for this album
    String albumKey = '${album.title}_${album.genre}';
    _albumArtists[albumKey] = contact.name;

    return album;
  }

  Album _generateAICompetitorAlbum(String artistName, Random random) {
    List<String> genres = [
      'Pop',
      'Hip-Hop',
      'Rock',
      'Electronic',
      'R&B',
      'Alternative',
    ];
    String genre = genres[random.nextInt(genres.length)];

    List<Song> albumSongs = [];
    int songCount = 8 + random.nextInt(5); // 8-12 songs

    for (int i = 0; i < songCount; i++) {
      albumSongs.add(_generateAICompetitorSong(artistName, random));
    }

    Album album = Album(
      title: _generateAlbumTitle(genre, random),
      genre: genre,
      releaseDate: DateTime.now().subtract(Duration(days: random.nextInt(200))),
      songs: albumSongs,
      isReleased: true,
    );

    // Track the artist for this album
    String albumKey = '${album.title}_${album.genre}';
    _albumArtists[albumKey] = artistName;

    return album;
  }

  String _generateSongTitle(String genre, Random random) {
    Map<String, List<String>> genreTitles = {
      'Pop': [
        'Midnight Dreams',
        'Electric Love',
        'Neon Nights',
        'Dancing Stars',
        'Golden Hour',
      ],
      'Hip-Hop': [
        'City Lights',
        'Rise Up',
        'Money Moves',
        'Street Dreams',
        'Crown King',
      ],
      'Rock': [
        'Thunder Road',
        'Wild Fire',
        'Breaking Chains',
        'Storm Rising',
        'Iron Heart',
      ],
      'Electronic': [
        'Digital Dreams',
        'Cyber Space',
        'Pulse Wave',
        'Neon Circuit',
        'Binary Love',
      ],
      'R&B': [
        'Smooth Operator',
        'Soul Connection',
        'Midnight Groove',
        'Sweet Harmony',
        'Love Letters',
      ],
      'Alternative': [
        'Broken Glass',
        'Fade Away',
        'Lost in Translation',
        'Grey Skies',
        'Reflection',
      ],
    };

    List<String> titles =
        genreTitles[genre] ?? ['Untitled Track', 'New Song', 'Latest Hit'];
    return titles[random.nextInt(titles.length)];
  }

  String _generateAlbumTitle(String genre, Random random) {
    Map<String, List<String>> genreAlbums = {
      'Pop': [
        'Starlight',
        'Dreams & Reality',
        'Endless Summer',
        'Midnight Collection',
        'Golden Era',
      ],
      'Hip-Hop': [
        'Streets & Stories',
        'Rise & Grind',
        'The Journey',
        'Crown Chronicles',
        'Urban Legend',
      ],
      'Rock': [
        'Thunder & Lightning',
        'Road Warriors',
        'Breaking Point',
        'Storm Front',
        'Iron Age',
      ],
      'Electronic': [
        'Digital Frontier',
        'Cyber Dreams',
        'Pulse Code',
        'Neon Nights',
        'Binary World',
      ],
      'R&B': [
        'Soul Sessions',
        'Smooth Grooves',
        'Midnight Moods',
        'Love & Life',
        'Harmony',
      ],
      'Alternative': [
        'Fading Light',
        'Lost & Found',
        'Grey Matter',
        'Reflection Pool',
        'Distant Shores',
      ],
    };

    List<String> albums =
        genreAlbums[genre] ??
        ['New Album', 'Latest Collection', 'Greatest Hits'];
    return albums[random.nextInt(albums.length)];
  }

  // Get artist name for any song (player's or competitor's)
  String _getArtistName(Song song) {
    // Check if it's a player song first
    if (widget.player.songs.contains(song)) {
      return widget.player.artistName;
    }

    // Check if it's tracked as a competitor song
    String songKey = '${song.title}_${song.genre}_${song.quality}';
    return _songArtists[songKey] ?? 'Unknown Artist';
  }

  // Get artist name for any album (player's or competitor's)
  String _getAlbumArtistName(Album album) {
    // Check if it's a player album first
    if (widget.player.albums.contains(album)) {
      return widget.player.artistName;
    }

    // Check if it's tracked as a competitor album
    String albumKey = '${album.title}_${album.genre}';
    return _albumArtists[albumKey] ?? 'Unknown Artist';
  }

  // Check for imported artists in current charts and notify player
  void _checkImportedArtistsInCharts(
    List<Song> topSongs,
    List<Album> topAlbums,
  ) {
    Set<String> chartingArtists = {};

    // Collect artists from top songs
    for (Song song in topSongs) {
      String artistName = _getArtistName(song);
      if (artistName != widget.player.artistName &&
          artistName != 'Unknown Artist') {
        chartingArtists.add(artistName);
      }
    }

    // Collect artists from top albums
    for (Album album in topAlbums) {
      String artistName = _getAlbumArtistName(album);
      if (artistName != widget.player.artistName &&
          artistName != 'Unknown Artist') {
        chartingArtists.add(artistName);
      }
    }

    // Notify about imported artists in charts
    widget.player.checkImportedArtistsInCharts(chartingArtists.toList());
  }
}
