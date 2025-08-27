import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'awards_screen.dart';

class FinancialsScreen extends StatelessWidget {
  final PlayerModel player;
  const FinancialsScreen({required this.player, super.key});

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
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Financials', style: AppTheme.titleLarge),
                              Text(
                                'Track your earnings and job opportunities',
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
                            onPressed: () => _handleEndWeek(context),
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
                      // Financial Overview with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Container(
                          decoration: AppTheme.cardDecoration.copyWith(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentGold.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.accentGold.withOpacity(0.3),
                                          AppTheme.accentGold.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      color: AppTheme.accentGold,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Financial Overview',
                                    style: AppTheme.titleLarge.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Animated financial cards
                              ..._buildAnimatedFinancialCards(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Income Sources with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Container(
                          decoration: AppTheme.cardDecoration.copyWith(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryPurple.withOpacity(
                                            0.3,
                                          ),
                                          AppTheme.primaryPurple.withOpacity(
                                            0.1,
                                          ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.attach_money,
                                      color: AppTheme.primaryPurple,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Income Sources',
                                    style: AppTheme.titleLarge.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Animated income sources
                              ..._buildAnimatedIncomeSources(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Job Market with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 40 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Container(
                          decoration: AppTheme.cardDecoration.copyWith(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.successGreen.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.successGreen.withOpacity(
                                            0.3,
                                          ),
                                          AppTheme.successGreen.withOpacity(
                                            0.1,
                                          ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.work,
                                      color: AppTheme.successGreen,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Job Market',
                                    style: AppTheme.titleLarge.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              if (player.currentJob != null) ...[
                                // Current Job Status
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.successGreen.withOpacity(0.2),
                                        AppTheme.successGreen.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppTheme.successGreen.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.work,
                                            color: AppTheme.successGreen,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Current Job: ${player.currentJob}',
                                            style: AppTheme.titleMedium
                                                .copyWith(
                                                  color: AppTheme.successGreen,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Weekly Income: \$${player.weeklyJobIncome}',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.accentGold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Available Jobs
                              Text(
                                'Available Jobs',
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Animated job listings
                              ...List.generate(player.availableJobs.length, (
                                index,
                              ) {
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                    milliseconds: 1200 + (index * 100),
                                  ),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(30 * (1 - value), 0),
                                      child: Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildJobListing(
                                      player.availableJobs[index],
                                      player,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
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

  List<Widget> _buildAnimatedFinancialCards() {
    return List.generate(2, (rowIndex) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800 + (rowIndex * 200)),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              if (rowIndex == 0) ...[
                Expanded(
                  child: _buildFinancialCard(
                    'Current Balance',
                    '\$${player.money}',
                    Icons.account_balance_wallet,
                    AppTheme.accentGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Total Earned',
                    '\$${player.money + 5000}', // Approximated total earnings
                    Icons.monetization_on,
                    AppTheme.successGreen,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: _buildFinancialCard(
                    'Weekly Expenses',
                    '\$${200 + (player.fame ~/ 100)}', // Basic expenses + lifestyle
                    Icons.money_off,
                    AppTheme.energyRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Net Worth',
                    '\$${player.money}', // Simplified net worth
                    Icons.account_balance,
                    AppTheme.primaryPurple,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildAnimatedIncomeSources() {
    final sources = [
      (
        'Job Income',
        player.currentJob != null ? '\$${player.weeklyJobIncome}' : '\$0',
        Icons.work,
        AppTheme.energyRed,
      ),
      (
        'Song Royalties',
        '\$${(player.songs.length * 50)}',
        Icons.music_note,
        AppTheme.primaryPurple,
      ),
      (
        'Performances',
        '\$${(player.fame ~/ 10) * 100}',
        Icons.mic,
        AppTheme.warningOrange,
      ),
      (
        'Record Deal',
        player.fame > 500 ? '\$5000' : '\$0',
        Icons.business,
        AppTheme.successGreen,
      ),
      (
        'Social Media',
        '\$${player.socialMediaFollowers ~/ 1000 * 10}',
        Icons.share,
        AppTheme.accentGold,
      ),
    ];

    return List.generate(sources.length, (index) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 1000 + (index * 100)),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(40 * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildIncomeSource(
            sources[index].$1,
            sources[index].$2,
            sources[index].$3,
            sources[index].$4,
          ),
        ),
      );
    });
  }

  Widget _buildFinancialCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeSource(
    String source,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              source,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              amount,
              style: AppTheme.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobListing(String jobTitle, PlayerModel player) {
    final jobSalaries = player.getJobSalaries();
    final salary = jobSalaries[jobTitle] ?? 200;
    final description = player.getJobDescription(jobTitle);
    final isCurrentJob = player.currentJob == jobTitle;

    return GestureDetector(
      onTap: !isCurrentJob && player.energy >= 10
          ? () {
              player.applyForJob(jobTitle);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isCurrentJob
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
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentJob
                ? AppTheme.successGreen
                : Colors.white.withOpacity(0.2),
            width: isCurrentJob ? 2 : 1,
          ),
          boxShadow: isCurrentJob
              ? [
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
                      Row(
                        children: [
                          Text(
                            jobTitle,
                            style: AppTheme.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCurrentJob
                                  ? AppTheme.successGreen
                                  : Colors.white,
                            ),
                          ),
                          if (isCurrentJob) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'CURRENT',
                                style: AppTheme.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentJob
                        ? AppTheme.successGreen.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCurrentJob ? Icons.check_circle : Icons.arrow_forward,
                    color: isCurrentJob
                        ? AppTheme.successGreen
                        : Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: AppTheme.accentGold,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Weekly Pay: \$$salary',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEndWeek(BuildContext context) {
    player.endWeek();

    // Check if awards were just received and show awards screen
    if (player.hasNewAwards) {
      player.clearNewAwardsFlag();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AwardsScreen(player: player)),
      );
    }
  }
}
