import 'package:flutter/material.dart';
import 'player_model.dart';

class TraitCard extends StatelessWidget {
  final Trait trait;
  final PlayerModel player;

  const TraitCard({required this.trait, required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    final bool canUpgrade = player.canUpgradeTrait(trait);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: trait.color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Level
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${trait.level}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Trait name and progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trait.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: trait.progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Energy cost
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.red, size: 16),
              Text(
                '${trait.energyCost}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Upgrade button
          GestureDetector(
            onTap: canUpgrade
                ? () => player.upgradeTrait(trait)
                : () => player.trainTrait(trait),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: canUpgrade ? Colors.green : Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                canUpgrade ? Icons.arrow_upward : Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
