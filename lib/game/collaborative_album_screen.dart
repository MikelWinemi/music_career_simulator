import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class CollaborativeAlbumScreen extends StatefulWidget {
  final PlayerModel player;
  final VoidCallback onAlbumCreated;

  const CollaborativeAlbumScreen({
    required this.player,
    required this.onAlbumCreated,
    super.key,
  });

  @override
  State<CollaborativeAlbumScreen> createState() =>
      _CollaborativeAlbumScreenState();
}

class _CollaborativeAlbumScreenState extends State<CollaborativeAlbumScreen> {
  final TextEditingController _albumTitleController = TextEditingController();
  final TextEditingController _collaboratorNameController =
      TextEditingController();

  String _selectedGenre = 'Pop';
  String _collaboratorType = 'artist'; // 'artist' or 'producer'

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
    _albumTitleController.dispose();
    _collaboratorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Collaborative Album',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people,
                          color: AppTheme.primaryPurple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collaborative Album',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            Text(
                              'Create an album with another artist or producer',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cost: \$1,000 • Energy: 30',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Album Title
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Album Title',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _albumTitleController,
                    style: AppTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Enter collaborative album title...',
                      hintStyle: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textMuted,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
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
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Collaborator Info
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collaborator',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
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
                  Text(
                    'Collaborator Type',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryPurple.withOpacity(0.3),
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
                        color: AppTheme.primaryPurple.withOpacity(0.3),
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
                          color: AppTheme.primaryPurple,
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
                          setState(() {
                            _selectedGenre = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Create button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canCreateAlbum() ? _createAlbum : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  disabledBackgroundColor: AppTheme.textMuted.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Create Collaborative Album',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info card
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.accentGold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Collaboration Benefits',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Increased fame and fan growth\n'
                    '• Enhanced skill development\n'
                    '• Better award eligibility\n'
                    '• Cross-promotion benefits\n'
                    '• Unique collaborative tracks',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canCreateAlbum() {
    if (widget.player.energy < 30) return false;
    if (widget.player.money < 1000) return false;
    if (_albumTitleController.text.trim().isEmpty) return false;
    if (_collaboratorNameController.text.trim().isEmpty) return false;
    return true;
  }

  void _createAlbum() {
    if (!_canCreateAlbum()) return;

    final albumTitle = _albumTitleController.text.trim();
    final collaboratorName = _collaboratorNameController.text.trim();

    // Create collaborative album
    bool success = widget.player.createCollaborativeAlbum(
      albumTitle: albumTitle,
      collaboratorName: collaboratorName,
      collaboratorType: _collaboratorType,
      genre: _selectedGenre,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough energy or money for collaborative album!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call the callback and navigate back
    widget.onAlbumCreated();
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully created collaborative album "$albumTitle" with $collaboratorName!',
          style: AppTheme.bodyLarge,
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
