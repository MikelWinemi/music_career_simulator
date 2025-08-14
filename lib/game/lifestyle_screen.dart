import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class LifestyleScreen extends StatelessWidget {
  final PlayerModel player;
  const LifestyleScreen({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
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
                            Icons.home,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lifestyle', style: AppTheme.titleLarge),
                              Text(
                                'Manage your living expenses',
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
                            'Week ${player.week}',
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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

                        // End Week button
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withOpacity(0.3),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.skip_next, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'END WEEK',
                                  style: AppTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Weekly Expenses Overview
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Living Expenses',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your current lifestyle costs you weekly. Upgrade to improve your mood and status.',
                              style: AppTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),

                            _buildExpenseItem(
                              'Housing',
                              (200 + player.fame ~/ 100).toInt(),
                              Icons.home,
                              AppTheme.primaryPurple,
                            ),
                            const SizedBox(height: 12),
                            _buildExpenseItem(
                              'Food & Dining',
                              ((200 + player.fame ~/ 100) * 0.3).toInt(),
                              Icons.restaurant,
                              AppTheme.warningOrange,
                            ),
                            const SizedBox(height: 12),
                            _buildExpenseItem(
                              'Transportation',
                              ((200 + player.fame ~/ 100) * 0.2).toInt(),
                              Icons.directions_car,
                              AppTheme.accentGold,
                            ),
                            const SizedBox(height: 12),
                            _buildExpenseItem(
                              'Utilities & Phone',
                              ((200 + player.fame ~/ 100) * 0.15).toInt(),
                              Icons.phone,
                              AppTheme.successGreen,
                            ),

                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.energyRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.energyRed.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    color: AppTheme.energyRed,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Weekly Cost',
                                          style: AppTheme.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '\$${(200 + player.fame ~/ 100).toInt()}',
                                          style: AppTheme.titleMedium.copyWith(
                                            color: AppTheme.energyRed,
                                          ),
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

                      const SizedBox(height: 16),

                      // Lifestyle Upgrades
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.upgrade,
                                  color: AppTheme.successGreen,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Lifestyle Upgrades',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Invest in a better lifestyle to boost your mood and public image.',
                              style: AppTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),

                            _buildLifestyleUpgrade(
                              'Basic Apartment',
                              'Small studio apartment',
                              200,
                              '+5 mood weekly',
                              player.fame <= 250,
                            ),
                            const SizedBox(height: 12),
                            _buildLifestyleUpgrade(
                              'Nice Apartment',
                              'One bedroom with amenities',
                              500,
                              '+10 mood weekly',
                              player.fame <= 600 && player.fame > 250,
                            ),
                            const SizedBox(height: 12),
                            _buildLifestyleUpgrade(
                              'Luxury Condo',
                              'High-end living space',
                              1200,
                              '+20 mood weekly',
                              player.fame <= 1500 && player.fame > 600,
                            ),
                            const SizedBox(height: 12),
                            _buildLifestyleUpgrade(
                              'Celebrity Mansion',
                              'Lavish celebrity home',
                              5000,
                              '+50 mood, +fame',
                              player.fame > 1500,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseItem(String title, int cost, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: AppTheme.bodyMedium)),
        Text(
          '\$$cost',
          style: AppTheme.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLifestyleUpgrade(
    String title,
    String description,
    int weeklyCost,
    String benefit,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [
                  AppTheme.successGreen.withOpacity(0.2),
                  AppTheme.successGreen.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppTheme.successGreen
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyLarge.copyWith(
                        color: isActive
                            ? AppTheme.successGreen
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(description, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              if (isActive)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$$weeklyCost/week',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                benefit,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
