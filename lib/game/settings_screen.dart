import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'game_wrapper.dart';

class SettingsScreen extends StatefulWidget {
  final PlayerModel player;
  const SettingsScreen({required this.player, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                            Icons.settings,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Settings', style: AppTheme.titleLarge),
                              Text(
                                'Manage your game preferences',
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
                            'Week ${widget.player.week}',
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
                                  '${widget.player.money}',
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
                                  '${widget.player.energy} / ${widget.player.maxEnergy}',
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
                            onPressed: widget.player.endWeek,
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
                      // Restart Game Section
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.restart_alt,
                                  color: AppTheme.energyRed,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Game Management',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start fresh with a new character and reset all progress',
                              style: AppTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _showRestartDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.energyRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.restart_alt, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'RESTART GAME',
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
                      ),

                      const SizedBox(height: 16),

                      // Energy Store
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.flash_on,
                                  color: AppTheme.energyRed,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Energy Store',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Need more energy to continue your music career?',
                              style: AppTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),

                            // Energy packages
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEnergyCard(
                                    '+500',
                                    'ENERGY',
                                    '\$1.99',
                                    AppTheme.energyRed,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEnergyCard(
                                    '+1500',
                                    'ENERGY',
                                    '\$4.99',
                                    AppTheme.energyRed,
                                    bonus: '50% BONUS',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEnergyCard(
                                    '+5000',
                                    'ENERGY',
                                    '\$9.99',
                                    AppTheme.energyRed,
                                    bonus: '100% BONUS',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Max Energy Upgrades
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
                                  'Permanent Upgrades',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Increase your maximum energy permanently',
                              style: AppTheme.bodySmall,
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildMaxEnergyCard(
                                    '+75',
                                    'MAX ENERGY',
                                    '\$3.99',
                                    'PERMANENT',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMaxEnergyCard(
                                    '+200',
                                    'MAX ENERGY',
                                    '\$7.99',
                                    'PERMANENT',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cash Store
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: AppTheme.accentGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cash Packages',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Boost your finances to afford better equipment and opportunities',
                              style: AppTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildCashCard(
                                    '25K',
                                    'CASH',
                                    '\$2.99',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCashCard(
                                    '100K',
                                    'CASH',
                                    '\$7.99',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCashCard(
                                    '500K',
                                    'CASH',
                                    '\$19.99',
                                  ),
                                ),
                              ],
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

  Widget _buildEnergyCard(
    String amount,
    String type,
    String price,
    Color color, {
    String? bonus,
  }) {
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
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(type, style: AppTheme.bodySmall),
          const SizedBox(height: 12),
          Icon(Icons.flash_on, color: color, size: 32),
          if (bonus != null) ...[
            const SizedBox(height: 8),
            Text(
              bonus,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              price,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxEnergyCard(
    String amount,
    String type,
    String price,
    String permanent,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successGreen.withOpacity(0.2),
            AppTheme.successGreen.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(type, style: AppTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            permanent,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Icon(Icons.upgrade, color: AppTheme.successGreen, size: 24),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              price,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashCard(String amount, String type, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentGold.withOpacity(0.2),
            AppTheme.accentGold.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.accentGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(type, style: AppTheme.bodySmall),
          const SizedBox(height: 12),
          Icon(Icons.attach_money, color: AppTheme.accentGold, size: 32),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentGold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              price,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: Row(
            children: [
              const Icon(Icons.warning, color: AppTheme.energyRed, size: 24),
              const SizedBox(width: 8),
              Text(
                'Restart Game',
                style: AppTheme.titleMedium.copyWith(color: AppTheme.energyRed),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to restart the game?',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'This will:',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('• Delete all progress', style: AppTheme.bodySmall),
              Text('• Reset your character', style: AppTheme.bodySmall),
              Text('• Clear all achievements', style: AppTheme.bodySmall),
              Text('• Remove saved jobs', style: AppTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone!',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.energyRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await widget.player.resetGame();
                // Navigate back to main menu
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const GameWrapper(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.energyRed,
              ),
              child: Text(
                'Restart',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
