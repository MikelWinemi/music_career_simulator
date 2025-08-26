import 'package:flutter/material.dart';
import 'ui/main_menu.dart';
import 'ui/character_creation_screen.dart';
import 'player_model.dart';
import 'game_screen.dart';
import 'music_career_screen.dart';
import 'financials_screen.dart';
import 'lifestyle_screen.dart';
import 'settings_screen.dart';

class GameWrapper extends StatefulWidget {
  const GameWrapper({super.key});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  bool _inGame = false;
  bool _inCharacterCreation = false;
  late PlayerModel _player;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _player = PlayerModel();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    await _player.loadData();
    setState(() {
      _isLoading = false;
      // If character was already created, go straight to game
      if (_player.characterCreated) {
        _inGame = true;
        _inCharacterCreation = false;
      } else {
        _inGame = false;
        _inCharacterCreation = true; // Start with character creation
      }
    });
  }

  void _startCharacterCreation() {
    setState(() {
      _inCharacterCreation = true;
    });
  }

  void _completeCharacterCreation() {
    _player.characterCreated = true;
    _player.saveData(); // Save character creation completion
    setState(() {
      _inCharacterCreation = false;
      _inGame = true;
    });
  }

  List<Widget> get _screens => [
    MusicCareerScreen(player: _player),
    GameScreen(player: _player),
    FinancialsScreen(player: _player),
    LifestyleScreen(player: _player),
    SettingsScreen(player: _player),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_inGame) {
      return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          color: const Color(0xFF1A1A1A),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(Icons.album, 0),
                  _buildNavIcon(Icons.trending_up, 1),
                  _buildNavIcon(Icons.attach_money, 2),
                  _buildNavIcon(Icons.home, 3),
                  _buildNavIcon(Icons.settings, 4),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (_inCharacterCreation) {
      return CharacterCreationScreen(
        player: _player,
        onComplete: _completeCharacterCreation,
      );
    } else {
      return MainMenu(onStart: _startCharacterCreation);
    }
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}
