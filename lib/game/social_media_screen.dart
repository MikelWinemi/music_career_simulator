import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class SocialMediaScreen extends StatefulWidget {
  final PlayerModel player;

  const SocialMediaScreen({required this.player, super.key});

  @override
  State<SocialMediaScreen> createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  final TextEditingController _postController = TextEditingController();
  String _selectedPlatform = 'Twitter';
  bool _isPosting = false;
  String? _lastPostResult;

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'Twitter',
      'icon': Icons.chat,
      'color': Color(0xFF1DA1F2),
      'maxChars': 280,
      'engagement': 'high',
      'description': 'Quick thoughts and updates',
    },
    {
      'name': 'Instagram',
      'icon': Icons.camera_alt,
      'color': Color(0xFFE4405F),
      'maxChars': 2200,
      'engagement': 'medium',
      'description': 'Visual content and stories',
    },
    {
      'name': 'TikTok',
      'icon': Icons.music_video,
      'color': Color(0xFF000000),
      'maxChars': 150,
      'engagement': 'viral',
      'description': 'Short videos and trends',
    },
  ];

  final List<String> _postSuggestions = [
    "Just finished writing a new song! 🎵",
    "Studio vibes today ✨",
    "Thank you to all my amazing fans! ❤️",
    "Working on something special... 🎤",
    "Music is life 🎶",
    "Can't wait to share this new track!",
    "Behind the scenes of my musical journey",
    "Feeling grateful for this opportunity",
    "New music coming soon! Stay tuned 📻",
    "Practice makes perfect 🎹",
    "Collaborating with amazing artists",
    "Every song tells a story 📖",
    "Living my dream one note at a time",
    "Your support means everything to me",
    "Creating magic in the studio today ✨",
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlatformData = _platforms.firstWhere(
      (platform) => platform['name'] == _selectedPlatform,
    );

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
                        Icons.share,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Social Media', style: AppTheme.titleLarge),
                          Text(
                            'Connect with your fans',
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
                            '5 Energy',
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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Platform selection
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Platform',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(_platforms.map(
                              (platform) => _buildPlatformOption(platform),
                            )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Post composition
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  selectedPlatformData['icon'],
                                  color: selectedPlatformData['color'],
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Create ${_selectedPlatform} Post',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: selectedPlatformData['color'],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedPlatformData['description'],
                              style: AppTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),

                            // Post input
                            TextField(
                              controller: _postController,
                              maxLength: selectedPlatformData['maxChars'],
                              maxLines: 4,
                              style: AppTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText:
                                    'What\'s on your mind? Share with your fans...',
                                hintStyle: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: selectedPlatformData['color']
                                        .withOpacity(0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: selectedPlatformData['color']
                                        .withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: selectedPlatformData['color'],
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Quick suggestions
                            Text(
                              'Quick Suggestions:',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _postSuggestions
                                  .take(6)
                                  .map(
                                    (suggestion) => GestureDetector(
                                      onTap: () =>
                                          _postController.text = suggestion,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryPurple
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.primaryPurple
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        child: Text(
                                          suggestion,
                                          style: AppTheme.bodySmall.copyWith(
                                            color: AppTheme.primaryPurple,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Post button
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _canPost() ? _createPost : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPlatformData['color'],
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.withOpacity(
                              0.3,
                            ),
                            disabledForegroundColor: Colors.grey,
                            elevation: 8,
                            shadowColor: selectedPlatformData['color']
                                .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isPosting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      selectedPlatformData['icon'],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Post on $_selectedPlatform',
                                      style: AppTheme.titleMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Last post result
                      if (_lastPostResult != null)
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.successGreen.withOpacity(0.3),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.successGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _lastPostResult!,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // End Week button
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildPlatformOption(Map<String, dynamic> platform) {
    final isSelected = _selectedPlatform == platform['name'];

    return GestureDetector(
      onTap: () => setState(() {
        _selectedPlatform = platform['name'];
        _postController.clear();
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? platform['color'].withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? platform['color']
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: platform['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(platform['icon'], color: platform['color'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform['name'],
                    style: AppTheme.bodyLarge.copyWith(
                      color: isSelected
                          ? platform['color']
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(platform['description'], style: AppTheme.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.text_fields,
                        size: 12,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${platform['maxChars']} chars',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: _getEngagementColor(platform['engagement']),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${platform['engagement']} reach',
                        style: AppTheme.bodySmall.copyWith(
                          color: _getEngagementColor(platform['engagement']),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.successGreen),
          ],
        ),
      ),
    );
  }

  Color _getEngagementColor(String engagement) {
    switch (engagement) {
      case 'high':
        return AppTheme.successGreen;
      case 'viral':
        return AppTheme.energyRed;
      case 'medium':
        return AppTheme.warningOrange;
      default:
        return AppTheme.textMuted;
    }
  }

  bool _canPost() {
    return widget.player.energy >= 5 &&
        _postController.text.trim().isNotEmpty &&
        !_isPosting;
  }

  Future<void> _createPost() async {
    if (!_canPost()) return;

    setState(() {
      _isPosting = true;
    });

    // Simulate posting delay
    await Future.delayed(const Duration(seconds: 2));

    final postContent = _postController.text.trim();
    final result = widget.player.createSocialMediaPost(
      platform: _selectedPlatform,
      content: postContent,
    );

    setState(() {
      _isPosting = false;
      _lastPostResult = result;
      _postController.clear();
    });

    // Show result dialog
    _showPostResultDialog(result);
  }

  void _showPostResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Row(
          children: [
            Icon(
              Icons.share,
              color: _platforms.firstWhere(
                (p) => p['name'] == _selectedPlatform,
              )['color'],
            ),
            const SizedBox(width: 8),
            Text('Post Published!', style: AppTheme.titleMedium),
          ],
        ),
        content: Text(result, style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentGold),
            ),
          ),
        ],
      ),
    );
  }
}
