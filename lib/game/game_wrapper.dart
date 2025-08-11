import 'package:flutter/material.dart';
import 'ui/main_menu.dart';
import 'player_model.dart';
import 'game_screen.dart';
import 'music_career_screen.dart';
import 'song_list_screen.dart';
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
  late PlayerModel _player;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _player = PlayerModel();
  }

  void _startGame() {
    setState(() {
      _inGame = true;
    });
  }

  List<Widget> get _screens => [
    MusicCareerScreen(player: _player),
    GameScreen(player: _player),
    SongListScreen(player: _player),
    FinancialsScreen(player: _player),
    LifestyleScreen(player: _player),
    SettingsScreen(player: _player),
  ];

  @override
  Widget build(BuildContext context) {
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
                  _buildNavIcon(Icons.music_note, 2),
                  _buildNavIcon(Icons.access_time, 3),
                  _buildNavIcon(Icons.home, 4),
                  _buildNavIcon(Icons.settings, 5),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(body: MainMenu(onStart: _startGame));
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
