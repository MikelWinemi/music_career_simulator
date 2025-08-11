import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class MusicStarDashboard extends StatelessWidget {
  final PlayerModel player;
  const MusicStarDashboard({required this.player, super.key});

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header with artist name and status
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentGold.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.artistName,
                                    style: AppTheme.titleLarge.copyWith(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    player.fameLevel,
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickStat(
                              'Fame',
                              player.fame.toString(),
                              Icons.star,
                            ),
                            _buildQuickStat(
                              'Fans',
                              '${(player.fans / 1000).toStringAsFixed(1)}K',
                              Icons.people,
                            ),
                            _buildQuickStat(
                              'Cash',
                              '\$${player.money}',
                              Icons.attach_money,
                            ),
                            _buildQuickStat(
                              'Energy',
                              '${player.energy}',
                              Icons.flash_on,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Music career highlights
                  Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.music_note,
                              color: AppTheme.accentGold,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Music Career Highlights',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildHighlightCard(
                                'Songs Written',
                                player.songs.length.toString(),
                                Icons.edit,
                                AppTheme.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildHighlightCard(
                                'Albums Sold',
                                player.albumsSold.toString(),
                                Icons.album,
                                AppTheme.energyRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildHighlightCard(
                                'Concerts',
                                player.concertsPerformed.toString(),
                                Icons.theater_comedy,
                                AppTheme.warningOrange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildHighlightCard(
                                'Social Media',
                                '${player.socialMediaFollowers}K',
                                Icons.share,
                                AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Life & relationships
                  Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFFF06292),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Life & Relationships',
                              style: AppTheme.titleMedium.copyWith(
                                color: const Color(0xFFF06292),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLifeIndicator(
                          'Happiness',
                          player.happiness,
                          AppTheme.successGreen,
                        ),
                        const SizedBox(height: 12),
                        _buildLifeIndicator(
                          'Stress Level',
                          player.stress,
                          AppTheme.energyRed,
                        ),
                        const SizedBox(height: 12),
                        _buildLifeIndicator(
                          'Family Bond',
                          player.familyRelationship,
                          AppTheme.successGreen,
                        ),
                        const SizedBox(height: 12),
                        _buildLifeIndicator(
                          'Friendships',
                          player.friendsRelationship,
                          AppTheme.textSecondary,
                        ),
                        if (player.partnerRelationship > 0) ...[
                          const SizedBox(height: 12),
                          _buildLifeIndicator(
                            'Romance',
                            player.partnerRelationship,
                            const Color(0xFFF06292),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Career status
                  Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.business,
                              color: AppTheme.accentGold,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Career Status',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatusItem(
                          'Manager',
                          player.hasManager
                              ? 'Professional Manager'
                              : 'No Manager',
                          player.hasManager
                              ? AppTheme.successGreen
                              : AppTheme.textMuted,
                          player.hasManager ? Icons.check_circle : Icons.cancel,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusItem(
                          'Record Deal',
                          player.currentDeal != null
                              ? 'Signed to ${player.currentDeal!.label}'
                              : 'Independent Artist',
                          player.currentDeal != null
                              ? AppTheme.successGreen
                              : AppTheme.textMuted,
                          player.currentDeal != null
                              ? Icons.check_circle
                              : Icons.cancel,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusItem(
                          'Agent',
                          player.hasAgent ? 'Professional Agent' : 'No Agent',
                          player.hasAgent
                              ? AppTheme.successGreen
                              : AppTheme.textMuted,
                          player.hasAgent ? Icons.check_circle : Icons.cancel,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusItem(
                          'Producer',
                          player.hasProducer
                              ? 'Professional Producer'
                              : 'No Producer',
                          player.hasProducer
                              ? AppTheme.successGreen
                              : AppTheme.textMuted,
                          player.hasProducer
                              ? Icons.check_circle
                              : Icons.cancel,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Current goals
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.accentGold.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              color: AppTheme.accentGold,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Current Goals',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildGoalItem(
                          'Write 10 songs',
                          player.songs.length,
                          10,
                        ),
                        _buildGoalItem('Gain 1000 fans', player.fans, 1000),
                        _buildGoalItem(
                          'Perform 5 concerts',
                          player.concertsPerformed,
                          5,
                        ),
                        _buildGoalItem(
                          'Reach 500 fame points',
                          player.fame,
                          500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentGold, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: AppTheme.bodySmall.copyWith(color: Colors.white70)),
      ],
    );
  }

  Widget _buildHighlightCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTheme.titleMedium.copyWith(color: color)),
          Text(title, style: AppTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLifeIndicator(String title, int value, Color color) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(title, style: AppTheme.bodyMedium)),
        Expanded(
          flex: 3,
          child: Container(
            height: 8,
            decoration: AppTheme.progressBarBackground,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value / 100,
              child: Container(
                decoration: AppTheme.progressBarForeground(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: AppTheme.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    String title,
    String status,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title: $status',
            style: AppTheme.bodyMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(String goal, int current, int target) {
    bool completed = current >= target;
    double progress = (current / target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? AppTheme.successGreen : AppTheme.textMuted,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal,
                  style: AppTheme.bodyMedium.copyWith(
                    color: completed
                        ? AppTheme.successGreen
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
              Text(
                '$current/$target',
                style: AppTheme.bodySmall.copyWith(
                  color: completed
                      ? AppTheme.successGreen
                      : AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            decoration: AppTheme.progressBarBackground,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: AppTheme.progressBarForeground(
                  completed ? AppTheme.successGreen : AppTheme.accentGold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
