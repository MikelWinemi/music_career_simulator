import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class SongCreationScreen extends StatefulWidget {
  final PlayerModel player;
  final VoidCallback onSongCreated;

  const SongCreationScreen({
    required this.player,
    required this.onSongCreated,
    super.key,
  });

  @override
  State<SongCreationScreen> createState() => _SongCreationScreenState();
}

class _SongCreationScreenState extends State<SongCreationScreen> {
  final TextEditingController _songTitleController = TextEditingController();
  final TextEditingController _albumTitleController = TextEditingController();

  String _selectedGenre = 'Pop';
  bool _isAlbum = false;
  bool _addToExistingAlbum = false;
  String? _selectedExistingAlbum;

  final List<String> _genres = [
    'Pop',
    'Rock',
    'Hip-Hop',
    'R&B',
    'Electronic',
    'Country',
    'Jazz',
    'Classical',
    'Reggae',
    'Alternative',
    'Indie',
    'Funk',
    'Soul',
    'Blues',
    'Folk',
  ];

  @override
  void dispose() {
    _songTitleController.dispose();
    _albumTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
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
                        Icons.music_note,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create New Song', style: AppTheme.titleLarge),
                          Text(
                            'Express your creativity',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Energy cost indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.energyRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.energyRed),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.flash_on,
                            color: AppTheme.energyRed,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '10 Energy',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.energyRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Creation form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Song title input
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Song Title',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _songTitleController,
                              style: AppTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText: 'Enter your song title...',
                                hintStyle: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryPurple.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryPurple.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppTheme.accentGold,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Genre selection
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Genre',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryPurple.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGenre,
                                  isExpanded: true,
                                  dropdownColor: AppTheme.cardBackground,
                                  style: AppTheme.bodyLarge,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppTheme.accentGold,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  items: _genres
                                      .map(
                                        (genre) => DropdownMenuItem(
                                          value: genre,
                                          child: Text(genre),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedGenre = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Album options
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Release Options',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Single release option
                            GestureDetector(
                              onTap: () => setState(() {
                                _isAlbum = false;
                                _addToExistingAlbum = false;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: (!_isAlbum && !_addToExistingAlbum)
                                      ? AppTheme.primaryPurple.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: (!_isAlbum && !_addToExistingAlbum)
                                        ? AppTheme.primaryPurple
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      color: (!_isAlbum && !_addToExistingAlbum)
                                          ? AppTheme.primaryPurple
                                          : AppTheme.textMuted,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Release as Single',
                                            style: AppTheme.bodyLarge.copyWith(
                                              color:
                                                  (!_isAlbum &&
                                                      !_addToExistingAlbum)
                                                  ? AppTheme.primaryPurple
                                                  : AppTheme.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Standalone song release',
                                            style: AppTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // New album option
                            GestureDetector(
                              onTap: () => setState(() {
                                _isAlbum = true;
                                _addToExistingAlbum = false;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _isAlbum
                                      ? AppTheme.accentGold.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isAlbum
                                        ? AppTheme.accentGold
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.album,
                                      color: _isAlbum
                                          ? AppTheme.accentGold
                                          : AppTheme.textMuted,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Create New Album',
                                            style: AppTheme.bodyLarge.copyWith(
                                              color: _isAlbum
                                                  ? AppTheme.accentGold
                                                  : AppTheme.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Start a new album with this song',
                                            style: AppTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Album title input (if creating new album)
                            if (_isAlbum) ...[
                              const SizedBox(height: 16),
                              TextField(
                                controller: _albumTitleController,
                                style: AppTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: 'Enter album title...',
                                  hintStyle: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textMuted,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppTheme.accentGold.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppTheme.accentGold.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppTheme.accentGold,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Existing albums option (if player has albums)
                            if (widget.player.albums.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => setState(() {
                                  _addToExistingAlbum = true;
                                  _isAlbum = false;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _addToExistingAlbum
                                        ? AppTheme.successGreen.withOpacity(0.2)
                                        : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _addToExistingAlbum
                                          ? AppTheme.successGreen
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.library_music,
                                        color: _addToExistingAlbum
                                            ? AppTheme.successGreen
                                            : AppTheme.textMuted,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Add to Existing Album',
                                              style: AppTheme.bodyLarge
                                                  .copyWith(
                                                    color: _addToExistingAlbum
                                                        ? AppTheme.successGreen
                                                        : AppTheme.textPrimary,
                                                  ),
                                            ),
                                            Text(
                                              'Add to one of your albums',
                                              style: AppTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Album selection dropdown
                              if (_addToExistingAlbum) ...[
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.successGreen.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedExistingAlbum,
                                      isExpanded: true,
                                      dropdownColor: AppTheme.cardBackground,
                                      style: AppTheme.bodyLarge,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: AppTheme.successGreen,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hint: Text(
                                        'Select an album...',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                      items: widget.player.albums
                                          .map(
                                            (album) => DropdownMenuItem(
                                              value: album.title,
                                              child: Text(album.title),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedExistingAlbum = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Create button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _canCreateSong() ? _createSong : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.grey.withOpacity(
                              0.3,
                            ),
                            disabledForegroundColor: Colors.grey,
                            elevation: 8,
                            shadowColor: AppTheme.accentGold.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.create, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'Create Song',
                                style: AppTheme.titleMedium.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // End Week button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.player.endWeek();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.fast_forward, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'END WEEK',
                                style: AppTheme.titleMedium.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 80,
                      ), // Bottom padding for safe navigation
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canCreateSong() {
    if (widget.player.energy < 10) return false;
    if (_songTitleController.text.trim().isEmpty) return false;
    if (_isAlbum && _albumTitleController.text.trim().isEmpty) return false;
    if (_addToExistingAlbum && _selectedExistingAlbum == null) return false;
    return true;
  }

  void _createSong() {
    if (!_canCreateSong()) return;

    final songTitle = _songTitleController.text.trim();
    final albumTitle = _isAlbum ? _albumTitleController.text.trim() : null;

    // Create the song through player model
    widget.player.createCustomSong(
      title: songTitle,
      genre: _selectedGenre,
      albumTitle: albumTitle,
      existingAlbumTitle: _addToExistingAlbum ? _selectedExistingAlbum : null,
    );

    // Call the callback and navigate back
    widget.onSongCreated();
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully created "$songTitle"!',
          style: AppTheme.bodyLarge,
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
