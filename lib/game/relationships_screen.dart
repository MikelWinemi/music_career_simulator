import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class RelationshipsScreen extends StatelessWidget {
  final PlayerModel player;
  const RelationshipsScreen({required this.player, super.key});

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
                // Header
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
                              Icons.people,
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
                                  'Relationships',
                                  style: AppTheme.titleLarge,
                                ),
                                Text(
                                  'Manage your personal connections',
                                  style: AppTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Social Media',
                              '${player.socialMediaFollowers}K',
                              Icons.share,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Engagement',
                              '${player.socialMediaEngagement}%',
                              Icons.favorite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Relationships list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildRelationshipCard(
                        'Family',
                        player.familyRelationship,
                        Icons.home,
                        'Your family supports your music career',
                        AppTheme.successGreen,
                      ),
                      const SizedBox(height: 12),
                      _buildRelationshipCard(
                        'Friends',
                        player.friendsRelationship,
                        Icons.group,
                        'Close friends who understand your journey',
                        AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      _buildRelationshipCard(
                        'Partner',
                        player.partnerRelationship,
                        Icons.favorite,
                        player.partnerRelationship > 0
                            ? 'Your romantic partner supports you'
                            : 'Single - focus on your career',
                        const Color(0xFFF06292),
                      ),
                      const SizedBox(height: 24),

                      // Relationship actions
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Relationship Actions',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    'Spend Time\nwith Family',
                                    Icons.home,
                                    AppTheme.successGreen,
                                    () => _improveRelationship('family'),
                                    8,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    'Hang Out\nwith Friends',
                                    Icons.group,
                                    AppTheme.textSecondary,
                                    () => _improveRelationship('friends'),
                                    8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    'Social Media\nPost',
                                    Icons.share,
                                    AppTheme.primaryPurple,
                                    () => _socialMediaPost(),
                                    5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    player.partnerRelationship > 0
                                        ? 'Date Night'
                                        : 'Find Partner',
                                    Icons.favorite,
                                    const Color(0xFFF06292),
                                    () => _improveRelationship('partner'),
                                    10,
                                  ),
                                ),
                              ],
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accentGold, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.titleMedium.copyWith(color: AppTheme.accentGold),
          ),
          Text(label, style: AppTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard(
    String title,
    int level,
    IconData icon,
    String description,
    Color color,
  ) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.titleMedium),
                    Text(description, style: AppTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                ),
                child: Text(
                  'Lv. $level',
                  style: AppTheme.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Relationship Level', style: AppTheme.bodySmall),
                  Text(
                    '$level/100',
                    style: AppTheme.bodySmall.copyWith(
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
                  widthFactor: level / 100,
                  child: Container(
                    decoration: AppTheme.progressBarForeground(color),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    int energyCost,
  ) {
    final bool canAfford = player.energy >= energyCost;

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
        ),
        child: Column(
          children: [
            Icon(icon, color: canAfford ? color : Colors.grey, size: 28),
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
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flash_on, color: AppTheme.energyRed, size: 12),
                Text(
                  '$energyCost',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.energyRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _improveRelationship(String type) {
    player.improveRelationships();
  }

  void _socialMediaPost() {
    if (player.energy >= 5) {
      player.socialMediaPost();
    }
  }
}
