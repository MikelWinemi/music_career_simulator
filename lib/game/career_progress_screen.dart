import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class CareerProgressScreen extends StatelessWidget {
  final PlayerModel player;
  const CareerProgressScreen({required this.player, super.key});

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
                // Header with career stats
                Container(
                  decoration: AppTheme.cardDecoration,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Career Progress',
                                  style: AppTheme.titleLarge,
                                ),
                                Text(
                                  'Track your journey to stardom',
                                  style: AppTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
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
                              player.fameLevel,
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildProgressCard(
                              'Fame Points',
                              player.fame,
                              1000,
                              AppTheme.accentGold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildProgressCard(
                              'Fan Base',
                              player.fans,
                              10000,
                              AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Career milestones and achievements
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Current record deal status
                      if (player.currentDeal != null) _buildRecordDealCard(),

                      const SizedBox(height: 16),

                      // Career achievements
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: AppTheme.accentGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Career Achievements',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildAchievementItem(
                              'Songs Written',
                              player.songs.length,
                              50,
                            ),
                            const SizedBox(height: 8),
                            _buildAchievementItem(
                              'Albums Sold',
                              player.albumsSold,
                              1000,
                            ),
                            const SizedBox(height: 8),
                            _buildAchievementItem(
                              'Concerts Performed',
                              player.concertsPerformed,
                              100,
                            ),
                            const SizedBox(height: 8),
                            _buildAchievementItem(
                              'Social Media Activity',
                              player.socialMediaFollowers,
                              500,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Manager status
                      _buildManagerCard(),

                      const SizedBox(height: 16),

                      // Life balance indicators
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Life Balance',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildBalanceBar(
                              'Health',
                              player.happiness,
                              AppTheme.successGreen,
                            ),
                            const SizedBox(height: 12),
                            _buildBalanceBar(
                              'Stress Level',
                              player.stress,
                              AppTheme.energyRed,
                            ),
                            const SizedBox(height: 12),
                            _buildBalanceBar(
                              'Work-Life Balance',
                              (player.familyRelationship +
                                      player.friendsRelationship) ~/
                                  2,
                              AppTheme.textSecondary,
                            ),
                          ],
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

  Widget _buildProgressCard(
    String title,
    int current,
    int target,
    Color color,
  ) {
    double progress = (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: AppTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('$current', style: AppTheme.titleMedium.copyWith(color: color)),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: AppTheme.progressBarBackground,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: AppTheme.progressBarForeground(color),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text('Target: $target', style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildRecordDealCard() {
    final deal = player.currentDeal!;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text('Record Deal: ${deal.label}', style: AppTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Royalty Rate', style: AppTheme.bodySmall),
                  Text(
                    '${(deal.royaltyRate * 100).toStringAsFixed(1)}%',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Advance Paid', style: AppTheme.bodySmall),
                  Text(
                    '\$${deal.advance}',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weeks Left', style: AppTheme.bodySmall),
                  Text(
                    '${deal.duration - deal.weeksSigned}',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagerCard() {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                player.hasManager ? Icons.person : Icons.person_outline,
                color: player.hasManager
                    ? AppTheme.successGreen
                    : AppTheme.textMuted,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                player.hasManager ? 'Manager: Music Pro' : 'No Manager',
                style: AppTheme.titleMedium.copyWith(
                  color: player.hasManager
                      ? AppTheme.successGreen
                      : AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (player.hasManager) ...[
            Text(
              'Your manager helps boost your career progression and negotiates better deals.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: AppTheme.successGreen,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '+25% Fame from concerts',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Consider hiring a manager to accelerate your career growth.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: player.money >= 5000
                  ? () => player.hireManager()
                  : null,
              style: AppTheme.primaryButtonStyle,
              child: Text('Hire Manager (\$5,000)'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, int current, int target) {
    bool achieved = current >= target;

    return Row(
      children: [
        Icon(
          achieved ? Icons.check_circle : Icons.radio_button_unchecked,
          color: achieved ? AppTheme.successGreen : AppTheme.textMuted,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: achieved ? AppTheme.successGreen : AppTheme.textMuted,
            ),
          ),
        ),
        Text(
          '$current / $target',
          style: AppTheme.bodySmall.copyWith(
            color: achieved ? AppTheme.successGreen : AppTheme.textMuted,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceBar(String title, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.bodyMedium),
            Text(
              '$value%',
              style: AppTheme.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
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
}
