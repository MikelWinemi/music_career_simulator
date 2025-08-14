import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'social_media_screen.dart';
import 'relationship_management_screen.dart';
import 'song_creation_screen.dart';

class MusicCareerScreen extends StatelessWidget {
  final PlayerModel player;
  const MusicCareerScreen({required this.player, super.key});

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
                // Top status bar with unique gradient
                Container(
                  decoration: AppTheme.cardDecoration,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Money and stats
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.flash_on,
                                    color: AppTheme.energyRed,
                                    size: 16,
                                  ),
                                  Text(
                                    '${player.energy} / ${player.maxEnergy}',
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: AppTheme.energyRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Artist info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                player.playerName.isNotEmpty
                                    ? player.playerName
                                    : player.artistName,
                                style: AppTheme.titleMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryPurple.withOpacity(
                                    0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                                child: Text(
                                  player.careerType.isNotEmpty
                                      ? player.careerType
                                      : player.fameLevel,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // End Week button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryPurple.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: player.endWeek,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'END WEEK',
                                    style: AppTheme.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Week ${player.week}, ${player.year}',
                                style: AppTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Career stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Fans',
                            player.fans.toString(),
                            Icons.people,
                          ),
                          _buildStatCard(
                            'Fame',
                            player.fame.toString(),
                            Icons.star,
                          ),
                          _buildStatCard(
                            'Songs',
                            player.songs.length.toString(),
                            Icons.music_note,
                          ),
                          _buildStatCard(
                            'Shows',
                            player.concertsPerformed.toString(),
                            Icons.mic,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Happiness and Stress indicators
                      Row(
                        children: [
                          Expanded(
                            child: _buildMoodBar(
                              'Happiness',
                              player.happiness,
                              player.happinessColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMoodBar(
                              'Stress',
                              player.stress,
                              player.stressColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '🎵 CAREER ACTIONS 🎵',
                            style: AppTheme.titleMedium.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Music actions
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                'Write Song',
                                Icons.edit,
                                AppTheme.primaryPurple,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongCreationScreen(
                                      player: player,
                                      onSongCreated: () =>
                                          Navigator.pop(context),
                                    ),
                                  ),
                                ),
                                energyCost: 10,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                'Concert',
                                Icons.theater_comedy,
                                AppTheme.warningOrange,
                                () => player.performConcert(),
                                energyCost: 15,
                                requirement: 'Fans: 50+',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                'Social Media',
                                Icons.share,
                                const Color(0xFF3B82F6),
                                () => _navigateToSocialMedia(context),
                                energyCost: 5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _buildActionButton(
                          'Relationships',
                          Icons.favorite,
                          const Color(0xFFEC4899),
                          () => _navigateToRelationships(context),
                          energyCost: 0,
                        ),
                        const SizedBox(
                          height: 80,
                        ), // Extra space for comfortable scrolling
                      ],
                    ),
                  ),
                ),

                // Event message
                if (player.eventMessage != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentGold),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.stars,
                            color: AppTheme.accentGold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            player.eventMessage!,
                            style: AppTheme.bodyLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: player.clearEvent,
                          icon: const Icon(
                            Icons.close,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryCard.withOpacity(0.6),
            AppTheme.primaryPurple.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.accentGold, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.accentGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.bodyMedium),
            Text(
              '$value%',
              style: AppTheme.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: AppTheme.progressBarBackground,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(decoration: AppTheme.progressBarForeground(color)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    int energyCost = 0,
    int moneyCost = 0,
    String? requirement,
  }) {
    final bool canAfford =
        player.energy >= energyCost && player.money >= moneyCost;

    return GestureDetector(
      onTap: canAfford ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: canAfford
              ? LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.1),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: canAfford ? color : Colors.grey, width: 2),
          boxShadow: canAfford
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: canAfford
                    ? color.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: canAfford ? color : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: canAfford ? AppTheme.textPrimary : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (energyCost > 0 || moneyCost > 0) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (energyCost > 0) ...[
                    const Icon(
                      Icons.flash_on,
                      color: AppTheme.energyRed,
                      size: 12,
                    ),
                    Text(
                      '$energyCost',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.energyRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (moneyCost > 0) ...[
                    if (energyCost > 0) const SizedBox(width: 8),
                    const Icon(
                      Icons.attach_money,
                      color: AppTheme.accentGold,
                      size: 12,
                    ),
                    Text(
                      '$moneyCost',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            if (requirement != null) ...[
              const SizedBox(height: 4),
              Text(
                requirement,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToSocialMedia(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocialMediaScreen(player: player),
      ),
    );
  }

  void _navigateToRelationships(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelationshipManagementScreen(player: player),
      ),
    );
  }
}
