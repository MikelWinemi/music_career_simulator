import 'package:flutter/material.dart';
import 'player_model.dart';
import 'trait_card.dart';

class GameScreen extends StatelessWidget {
  final PlayerModel player;
  const GameScreen({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: player,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFF2A2A2A),
        body: SafeArea(
          child: Column(
            children: [
              // Top status bar
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Money and Energy
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${player.money}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: Colors.red,
                              size: 16,
                            ),
                            Text(
                              '${player.energy} | ${player.maxEnergy}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'END WEEK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Week ${player.week}, ${player.year}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Help button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skill level indicator
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    '${_getTotalSkillLevel()} SKILL LEVEL',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'ARTIST TRAITS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 16),

              // Artist traits
              Expanded(
                child: ListView(
                  children: [
                    ...player.artistTraits.map(
                      (trait) => TraitCard(trait: trait, player: player),
                    ),

                    const SizedBox(height: 32),

                    // Business traits header
                    const Center(
                      child: Text(
                        'BUSINESS TRAITS',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...player.businessTraits.map(
                      (trait) => TraitCard(trait: trait, player: player),
                    ),

                    const SizedBox(height: 100), // Bottom padding for nav bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getTotalSkillLevel() {
    int total = 0;
    for (var trait in player.artistTraits) {
      total += trait.level;
    }
    for (var trait in player.businessTraits) {
      total += trait.level;
    }
    return total;
  }
}
