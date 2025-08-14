import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

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
                      // Financial Overview
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  color: AppTheme.accentGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Financial Overview',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
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
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
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
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Income Sources
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income Sources',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildIncomeSource(
                              'Job Income',
                              player.currentJob != null
                                  ? '\$${player.weeklyJobIncome}'
                                  : '\$0',
                              Icons.work,
                              AppTheme.energyRed,
                            ),
                            const SizedBox(height: 12),
                            _buildIncomeSource(
                              'Song Royalties',
                              '\$${(player.songs.length * 50)}',
                              Icons.music_note,
                              AppTheme.primaryPurple,
                            ),
                            const SizedBox(height: 12),
                            _buildIncomeSource(
                              'Performances',
                              '\$${(player.fame ~/ 10) * 100}',
                              Icons.mic,
                              AppTheme.warningOrange,
                            ),
                            const SizedBox(height: 12),
                            _buildIncomeSource(
                              'Record Deal',
                              player.fame > 500 ? '\$5000' : '\$0',
                              Icons.business,
                              AppTheme.successGreen,
                            ),
                            const SizedBox(height: 12),
                            _buildIncomeSource(
                              'Social Media',
                              '\$${player.socialMediaFollowers ~/ 1000 * 10}',
                              Icons.share,
                              AppTheme.accentGold,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Job Market
                      Container(
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.work,
                                  color: AppTheme.accentGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Job Market',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (player.currentJob != null) ...[
                              // Current Job Status
                              Container(
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
                                  border: Border.all(
                                    color: AppTheme.successGreen.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.badge,
                                          color: AppTheme.successGreen,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Current Job',
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: AppTheme.successGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      player.currentJob!,
                                      style: AppTheme.titleMedium.copyWith(
                                        color: AppTheme.successGreen,
                                      ),
                                    ),
                                    Text(
                                      player.getJobDescription(
                                        player.currentJob!,
                                      ),
                                      style: AppTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Weekly Income: \$${player.weeklyJobIncome}',
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: AppTheme.successGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            player.quitJob();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.energyRed,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: Text(
                                            'Quit Job',
                                            style: AppTheme.bodySmall.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Available Jobs
                            Text(
                              'Available Jobs',
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...player.availableJobs.map(
                              (job) => _buildJobListing(job, player),
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

  Widget _buildFinancialCard(
    String title,
    String amount,
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
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: AppTheme.bodySmall, textAlign: TextAlign.center),
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
        Expanded(child: Text(source, style: AppTheme.bodyMedium)),
        Text(
          amount,
          style: AppTheme.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildJobListing(String jobTitle, PlayerModel player) {
    final jobSalaries = player.getJobSalaries();
    final salary = jobSalaries[jobTitle] ?? 200;
    final description = player.getJobDescription(jobTitle);
    final isCurrentJob = player.currentJob == jobTitle;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentJob
            ? AppTheme.successGreen.withOpacity(0.1)
            : AppTheme.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentJob
              ? AppTheme.successGreen.withOpacity(0.3)
              : AppTheme.primaryPurple.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrentJob
                            ? AppTheme.successGreen
                            : AppTheme.textPrimary,
                      ),
                    ),
                    Text(description, style: AppTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      'Weekly Pay: \$${salary}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCurrentJob)
                ElevatedButton(
                  onPressed: player.energy >= 10
                      ? () {
                          player.applyForJob(jobTitle);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: AppTheme.bodySmall.copyWith(color: Colors.white),
                  ),
                ),
              if (isCurrentJob)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Current',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
