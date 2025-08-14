import 'package:flutter/material.dart';
import 'app_theme.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onStart;
  const MainMenu({required this.onStart, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Title section
              Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(32),
                decoration: AppTheme.cardDecoration,
                child: Column(
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
                      'Music Career',
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 32,
                        color: AppTheme.accentGold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Simulator',
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 32,
                        color: AppTheme.primaryPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Build your music empire from the ground up',
                      style: AppTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Start button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: AppTheme.goldButtonStyle.copyWith(
                      elevation: MaterialStateProperty.all(12),
                      shadowColor: MaterialStateProperty.all(
                        AppTheme.accentGold.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          size: 24,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Create Character',
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Features preview
              Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Game Features',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.accentGold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeatureIcon(Icons.mic, 'Perform'),
                        _buildFeatureIcon(Icons.people, 'Network'),
                        _buildFeatureIcon(Icons.trending_up, 'Grow Fame'),
                        _buildFeatureIcon(Icons.album, 'Create Music'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.5)),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTheme.bodySmall),
      ],
    );
  }
}
