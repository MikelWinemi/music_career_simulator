import 'package:flutter/material.dart';
import '../player_model.dart';
import 'app_theme.dart';

class CharacterCreationScreen extends StatefulWidget {
  final PlayerModel player;
  final VoidCallback onComplete;

  const CharacterCreationScreen({
    required this.player,
    required this.onComplete,
    super.key,
  });

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Music styles for avatar generation
  final List<Map<String, dynamic>> _musicStyles = [
    {
      'name': 'Rapper',
      'style': 'rapper',
      'icon': Icons.mic,
      'description': 'Hip-hop and rap music',
      'colors': [Colors.purple, Colors.orange],
    },
    {
      'name': 'Pop Star',
      'style': 'pop',
      'icon': Icons.star,
      'description': 'Mainstream pop music',
      'colors': [Colors.pink, Colors.blue],
    },
    {
      'name': 'Rock Star',
      'style': 'rock',
      'icon': Icons.music_note,
      'description': 'Rock and metal music',
      'colors': [Colors.red, Colors.black],
    },
    {
      'name': 'R&B Artist',
      'style': 'rnb',
      'icon': Icons.favorite,
      'description': 'Rhythm and blues',
      'colors': [Colors.red, Colors.pink],
    },
    {
      'name': 'Electronic DJ',
      'style': 'electronic',
      'icon': Icons.headphones,
      'description': 'Electronic and EDM',
      'colors': [Colors.blue, Colors.cyan],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        title: Text(
          'Create Your Character',
          style: AppTheme.titleMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildNameStep(),
          _buildGenderStep(),
          _buildCareerStep(),
          _buildMusicStyleStep(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: AppTheme.primaryPurple,
        child: SafeArea(
          child: Row(
            children: [
              // Progress indicator
              Text(
                'Step ${_currentStep + 1} of 4',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              // Next button
              ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: AppTheme.goldButtonStyle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentStep == 3 ? 'Start Game' : 'Next',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.accentGold.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '🎤 Choose Your Name',
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'What should the world know you as?',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    style: AppTheme.bodyLarge.copyWith(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Your Artist Name',
                      labelStyle: TextStyle(
                        color: AppTheme.accentGold.withOpacity(0.8),
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.accentGold,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This will be your stage name throughout the game',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStep() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.accentGold.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '👤 Choose Your Identity',
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'How do you identify yourself?',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionCard(
                          'Male',
                          'He/Him',
                          Icons.male,
                          widget.player.gender == 'male',
                          () => setState(() => widget.player.gender = 'male'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOptionCard(
                          'Female',
                          'She/Her',
                          Icons.female,
                          widget.player.gender == 'female',
                          () => setState(() => widget.player.gender = 'female'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerStep() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.accentGold.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '🎯 Choose Your Path',
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'What type of musician are you?',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionCard(
                          'Artist',
                          'Perform and create music',
                          Icons.mic,
                          widget.player.careerType == 'artist',
                          () => setState(
                            () => widget.player.careerType = 'artist',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOptionCard(
                          'Producer',
                          'Create beats and produce',
                          Icons.music_note,
                          widget.player.careerType == 'producer',
                          () => setState(
                            () => widget.player.careerType = 'producer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicStyleStep() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.accentGold.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '🎵 Choose Your Style',
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'What genre defines your music?',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: _musicStyles.map((style) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: _buildMusicStyleCard(
                      style,
                      widget.player.avatarStyle == style['style'],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicStyleCard(Map<String, dynamic> style, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.player.avatarStyle = style['style'];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.accentGold,
                    AppTheme.accentGold.withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentGold
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black.withOpacity(0.2)
                    : AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                style['icon'],
                size: 24,
                color: isSelected ? Colors.black : AppTheme.accentGold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.black.withOpacity(0.7)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String description,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentGold
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentGold
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.black : AppTheme.accentGold,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Colors.black.withOpacity(0.7)
                    : AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return widget.player.gender.isNotEmpty;
      case 2:
        return widget.player.careerType.isNotEmpty;
      case 3:
        return widget.player.avatarStyle.isNotEmpty;
      default:
        return false;
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete character creation - set default avatar when skipping
      widget.player.playerName = _nameController.text.trim();
      widget.player.artistName = _nameController.text.trim();
      widget.player.characterCreated = true;

      // Set default avatar values
      widget.player.avatarSkin = '1';
      widget.player.avatarHair = '1';
      widget.player.avatarHairColor = '1';
      widget.player.avatarTop = '1';
      widget.player.avatarBackground = '1';

      widget.onComplete();
    }
  }
}
