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
            decoration: BoxDecoration(
              color: trait.isMaxLevel
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.white24,
              shape: BoxShape.circle,
              border: trait.isMaxLevel
                  ? Border.all(color: Colors.amber, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                '${trait.level}',
                style: TextStyle(
                  color: trait.isMaxLevel ? Colors.amber : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Trait name and progress bar
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        trait.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${trait.level}/${trait.maxLevel}',
                      style: TextStyle(
                        color: trait.isMaxLevel ? Colors.amber : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                    widthFactor: trait.isMaxLevel ? 1.0 : trait.progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: trait.isMaxLevel ? Colors.amber : Colors.white,
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
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
          ),

          const SizedBox(width: 16),

          // Upgrade button
          GestureDetector(
            onTap: trait.isMaxLevel
                ? null
                : (canUpgrade
                      ? () => player.upgradeTrait(trait)
                      : () => player.trainTrait(trait)),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: trait.isMaxLevel
                    ? Colors.amber.withOpacity(0.3)
                    : (canUpgrade ? Colors.green : Colors.white24),
                shape: BoxShape.circle,
                border: trait.isMaxLevel
                    ? Border.all(color: Colors.amber, width: 2)
                    : null,
              ),
              child: Icon(
                trait.isMaxLevel
                    ? Icons.star
                    : (canUpgrade ? Icons.arrow_upward : Icons.add),
                color: trait.isMaxLevel ? Colors.amber : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
