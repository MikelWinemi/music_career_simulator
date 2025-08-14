import 'package:flutter/material.dart';
import 'player_model.dart';
import 'trait_card.dart';
import 'ui/app_theme.dart';

class GameScreen extends StatelessWidget {
  final PlayerModel player;
  const GameScreen({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: player,
      builder: (context, _) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top status bar with AppTheme styling
                Container(
                  decoration: AppTheme.cardDecoration,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Money and Energy
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppTheme.accentGold,
                                    size: 20,
                                  ),
                                  Text(
                                    '${player.money}',
                                    style: AppTheme.titleLarge.copyWith(
                                      color: AppTheme.accentGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.flash_on,
                                    color: AppTheme.energyRed,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${player.energy}/${player.maxEnergy}',
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: AppTheme.energyRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // End Week button and date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: player.endWeek,
                                style: AppTheme.primaryButtonStyle,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.skip_next, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'END WEEK',
                                      style: AppTheme.bodyMedium.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Week ${player.week}, ${player.year}',
                                style: AppTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Skill level indicator with themed styling
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: _getTotalSkillLevel() >= 100
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    AppTheme.accentGold.withOpacity(0.3),
                                    AppTheme.accentGold.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getTotalSkillLevel() >= 100
                                ? const Color(0xFFFFD700)
                                : AppTheme.accentGold,
                            width: 2,
                          ),
                          boxShadow: _getTotalSkillLevel() >= 100
                              ? [
                                  const BoxShadow(
                                    color: Color(0xFFFFD700),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getTotalSkillLevel() >= 100
                                      ? Icons.emoji_events
                                      : Icons.star,
                                  color: _getTotalSkillLevel() >= 100
                                      ? const Color(0xFFFFD700)
                                      : AppTheme.accentGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getTotalSkillLevel() >= 100
                                      ? 'MASTER ARTIST!'
                                      : 'TOTAL SKILL LEVEL',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: _getTotalSkillLevel() >= 100
                                        ? const Color(0xFFFFD700)
                                        : AppTheme.accentGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_getTotalSkillLevel()}',
                                  style: AppTheme.titleLarge.copyWith(
                                    color: _getTotalSkillLevel() >= 100
                                        ? const Color(0xFFFFD700)
                                        : AppTheme.accentGold,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' / 100',
                                  style: AppTheme.titleMedium.copyWith(
                                    color:
                                        (_getTotalSkillLevel() >= 100
                                                ? const Color(0xFFFFD700)
                                                : AppTheme.accentGold)
                                            .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (_getTotalSkillLevel() / 100.0).clamp(
                                0.0,
                                1.0,
                              ),
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getTotalSkillLevel() >= 100
                                    ? const Color(0xFFFFD700)
                                    : AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Expandable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Artist traits section
                        Container(
                          decoration: AppTheme.cardDecoration,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'ARTIST TRAITS',
                                    style: AppTheme.titleMedium.copyWith(
                                      color: AppTheme.accentGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...player.artistTraits.map(
                                (trait) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TraitCard(
                                    trait: trait,
                                    player: player,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Business traits section
                        Container(
                          decoration: AppTheme.cardDecoration,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successGreen.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.successGreen,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.business,
                                      color: AppTheme.successGreen,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'BUSINESS TRAITS',
                                    style: AppTheme.titleMedium.copyWith(
                                      color: AppTheme.accentGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...player.businessTraits.map(
                                (trait) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TraitCard(
                                    trait: trait,
                                    player: player,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 80,
                        ), // Bottom padding for nav bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getTotalSkillLevel() {
    int total = 0;
    // Only count artist traits for the 100 skill level goal
    for (var trait in player.artistTraits) {
      total += trait.level.round();
    }
    return total;
  }
}
