import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'ui/image_manager.dart';

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
  final TextEditingController _collaboratorNameController =
      TextEditingController();

  String _selectedGenre = 'Pop';
  bool _isAlbum = false;
  bool _addToExistingAlbum = false;
  bool _isCollaborativeAlbum = false;
  String _collaboratorType = 'artist'; // 'artist' or 'producer'
  String? _selectedExistingAlbum;
  String? _selectedCoverImagePath;
  String? _selectedAlbumCoverImagePath;

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
    'Rage',
  ];

  @override
  void dispose() {
    _songTitleController.dispose();
    _albumTitleController.dispose();
    _collaboratorNameController.dispose();
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

                      // Cover Image Section
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cover Image',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Image preview
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.primaryPurple.withOpacity(
                                        0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: _selectedCoverImagePath != null
                                        ? ImageManager.getImageWidget(
                                            _selectedCoverImagePath,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppTheme.primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Image controls
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _selectCoverImage(),
                                        icon: Icon(
                                          _selectedCoverImagePath != null
                                              ? Icons.edit
                                              : Icons.add_photo_alternate,
                                          size: 18,
                                        ),
                                        label: Text(
                                          _selectedCoverImagePath != null
                                              ? 'Change Image'
                                              : 'Add Cover Image',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.accentGold,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_selectedCoverImagePath != null) ...[
                                        const SizedBox(height: 8),
                                        TextButton.icon(
                                          onPressed: () => setState(() {
                                            _selectedCoverImagePath = null;
                                          }),
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: AppTheme.energyRed,
                                          ),
                                          label: const Text(
                                            'Remove',
                                            style: TextStyle(
                                              color: AppTheme.energyRed,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Optional: Add a cover image to make your song stand out',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textMuted,
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
                                _isCollaborativeAlbum = false;
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
                                _isCollaborativeAlbum = false;
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

                              // Album cover image section
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Album Cover',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Album cover preview
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.accentGold
                                                .withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child:
                                              _selectedAlbumCoverImagePath !=
                                                  null
                                              ? ImageManager.getImageWidget(
                                                  _selectedAlbumCoverImagePath,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        AppTheme.goldGradient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.album,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Album cover controls
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _selectAlbumCoverImage(),
                                              icon: Icon(
                                                _selectedAlbumCoverImagePath !=
                                                        null
                                                    ? Icons.edit
                                                    : Icons.add_photo_alternate,
                                                size: 16,
                                              ),
                                              label: Text(
                                                _selectedAlbumCoverImagePath !=
                                                        null
                                                    ? 'Change'
                                                    : 'Add Cover',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.accentGold,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                              ),
                                            ),
                                            if (_selectedAlbumCoverImagePath !=
                                                null)
                                              TextButton.icon(
                                                onPressed: () => setState(() {
                                                  _selectedAlbumCoverImagePath =
                                                      null;
                                                }),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 14,
                                                  color: AppTheme.energyRed,
                                                ),
                                                label: const Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                    color: AppTheme.energyRed,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],

                            // Existing albums option (if player has albums)
                            if (widget.player.albums.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => setState(() {
                                  _addToExistingAlbum = true;
                                  _isAlbum = false;
                                  _isCollaborativeAlbum = false;
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

                              const SizedBox(height: 12),

                              // Collaborative album option
                              GestureDetector(
                                onTap: () => setState(() {
                                  _isAlbum = false;
                                  _addToExistingAlbum = false;
                                  _isCollaborativeAlbum = true;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _isCollaborativeAlbum
                                        ? AppTheme.primaryPurple.withOpacity(
                                            0.2,
                                          )
                                        : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _isCollaborativeAlbum
                                          ? AppTheme.primaryPurple
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: _isCollaborativeAlbum
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
                                              'Collaborative Album',
                                              style: AppTheme.bodyLarge
                                                  .copyWith(
                                                    color: _isCollaborativeAlbum
                                                        ? AppTheme.primaryPurple
                                                        : AppTheme.textPrimary,
                                                  ),
                                            ),
                                            Text(
                                              'Create an album with another artist or producer',
                                              style: AppTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Collaborative album inputs
                              if (_isCollaborativeAlbum) ...[
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _albumTitleController,
                                  style: AppTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter collaborative album title...',
                                    hintStyle: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textMuted,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppTheme.primaryPurple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),
                                TextField(
                                  controller: _collaboratorNameController,
                                  style: AppTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: 'Enter collaborator name...',
                                    hintStyle: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textMuted,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppTheme.primaryPurple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),
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
                                      value: _collaboratorType,
                                      isExpanded: true,
                                      dropdownColor: AppTheme.cardBackground,
                                      style: AppTheme.bodyLarge,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: AppTheme.primaryPurple,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'artist',
                                          child: Text('Artist Collaboration'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'producer',
                                          child: Text('Producer Collaboration'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _collaboratorType = value!;
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
    if (_isCollaborativeAlbum) {
      if (_albumTitleController.text.trim().isEmpty) return false;
      if (_collaboratorNameController.text.trim().isEmpty) return false;
      if (widget.player.energy < 30 || widget.player.money < 1000) return false;
    }
    return true;
  }

  void _createSong() {
    if (!_canCreateSong()) return;

    final songTitle = _songTitleController.text.trim();
    final albumTitle = _isAlbum ? _albumTitleController.text.trim() : null;

    // Handle collaborative album creation
    if (_isCollaborativeAlbum) {
      final collaborativeAlbumTitle = _albumTitleController.text.trim();
      final collaboratorName = _collaboratorNameController.text.trim();

      if (collaborativeAlbumTitle.isEmpty || collaboratorName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill in both album title and collaborator name',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create collaborative album
      bool success = widget.player.createCollaborativeAlbum(
        albumTitle: collaborativeAlbumTitle,
        collaboratorName: collaboratorName,
        collaboratorType: _collaboratorType,
        genre: _selectedGenre,
        coverImagePath: _selectedAlbumCoverImagePath,
      );

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Not enough energy or money for collaborative album!',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Now create the song and add it to the collaborative album
      widget.player.createCustomSong(
        title: songTitle,
        genre: _selectedGenre,
        albumTitle: null,
        existingAlbumTitle: collaborativeAlbumTitle,
        coverImagePath: _selectedCoverImagePath,
        albumCoverImagePath: _selectedAlbumCoverImagePath,
      );
    } else {
      // Create the song through player model (normal flow)
      widget.player.createCustomSong(
        title: songTitle,
        genre: _selectedGenre,
        albumTitle: albumTitle,
        existingAlbumTitle: _addToExistingAlbum ? _selectedExistingAlbum : null,
        coverImagePath: _selectedCoverImagePath,
        albumCoverImagePath: _selectedAlbumCoverImagePath,
      );
    }

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

  void _selectCoverImage() async {
    final imagePath = await ImageManager.showImagePickerDialog(
      context,
      type: 'song',
      name: _songTitleController.text.trim().isNotEmpty
          ? _songTitleController.text.trim()
          : 'New Song',
    );

    if (imagePath != null) {
      setState(() {
        _selectedCoverImagePath = imagePath;
      });
    }
  }

  void _selectAlbumCoverImage() async {
    final imagePath = await ImageManager.showImagePickerDialog(
      context,
      type: 'album',
      name: _albumTitleController.text.trim().isNotEmpty
          ? _albumTitleController.text.trim()
          : 'New Album',
    );

    if (imagePath != null) {
      setState(() {
        _selectedAlbumCoverImagePath = imagePath;
      });
    }
  }
}
