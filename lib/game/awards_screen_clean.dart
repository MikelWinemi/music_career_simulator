import 'package:flutter/material.dart';
import 'player_model.dart';
import 'award_system.dart';
import 'ui/app_theme.dart';

class AwardsScreen extends StatelessWidget {
  final PlayerModel player;

  const AwardsScreen({Key? key, required this.player}) : super(key: key);

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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.emoji_events,
                      color: AppTheme.accentGold,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Awards & Achievements',
                      style: AppTheme.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: player.awards.isEmpty
                    ? _buildEmptyState()
                    : _buildAwardsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No Awards Yet',
            style: AppTheme.titleLarge.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Keep working on your music career! Awards are given at the end of each year (week 52) based on your achievements.',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _buildAwardInfo(),
        ],
      ),
    );
  }

  Widget _buildAwardInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppTheme.accentGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Award Shows',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAwardShowInfo(
            'Grammy Awards',
            'Music excellence across all genres',
          ),
          const SizedBox(height: 8),
          _buildAwardShowInfo(
            'American Music Awards',
            'Fan-voted music awards',
          ),
          const SizedBox(height: 12),
          Text(
            'Tip: Higher fame, album sales, and social media following improve your chances!',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardShowInfo(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: AppTheme.accentGold,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAwardsList() {
    // Group awards by year
    Map<int, List<Award>> awardsByYear = {};
    for (Award award in player.awards) {
      if (!awardsByYear.containsKey(award.year)) {
        awardsByYear[award.year] = [];
      }
      awardsByYear[award.year]!.add(award);
    }

    // Sort years in descending order
    List<int> sortedYears = awardsByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedYears.length,
      itemBuilder: (context, index) {
        int year = sortedYears[index];
        List<Award> yearAwards = awardsByYear[year]!;

        return _buildYearSection(year, yearAwards);
      },
    );
  }

  Widget _buildYearSection(int year, List<Award> awards) {
    // Group by award show
    Map<AwardShow, List<Award>> awardsByShow = {};
    for (Award award in awards) {
      if (!awardsByShow.containsKey(award.show)) {
        awardsByShow[award.show] = [];
      }
      awardsByShow[award.show]!.add(award);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGold.withOpacity(0.8),
                  AppTheme.accentGold.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$year Award Season',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${awards.length} Award${awards.length == 1 ? '' : 's'}',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Award shows for this year
          ...awardsByShow.entries
              .map((entry) => _buildAwardShow(entry.key, entry.value))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAwardShow(AwardShow show, List<Award> awards) {
    String showName = show == AwardShow.grammys
        ? "Grammy Awards"
        : "American Music Awards";
    Color showColor = show == AwardShow.grammys ? Colors.amber : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: showColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: showColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  show == AwardShow.grammys ? Icons.music_note : Icons.star,
                  color: showColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  showName,
                  style: AppTheme.bodyMedium.copyWith(
                    color: showColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: showColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${awards.length} Award${awards.length == 1 ? '' : 's'}',
                  style: AppTheme.bodySmall.copyWith(
                    color: showColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Individual awards
          ...awards.map((award) => _buildAwardItem(award)).toList(),
        ],
      ),
    );
  }

  Widget _buildAwardItem(Award award) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: AppTheme.accentGold, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AwardSystem.getCategoryDisplayName(award.category),
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  award.description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Week ${award.week}',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.accentGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
