import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';
import 'ui/image_manager.dart';

class VinylManagementScreen extends StatelessWidget {
  final PlayerModel player;
  const VinylManagementScreen({required this.player, super.key});

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
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.album,
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
                              'Vinyl Collection',
                              style: AppTheme.titleLarge,
                            ),
                            Text(
                              'Create and manage vinyl releases',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
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
                        // Available Albums Section
                        _buildAvailableAlbumsSection(context),
                        const SizedBox(height: 20),
                        // Existing Vinyls Section
                        _buildExistingVinylsSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableAlbumsSection(BuildContext context) {
    final eligibleAlbums = player.albums
        .where((album) => player.canCreateVinyl(album))
        .toList();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.add_circle,
                color: AppTheme.accentGold,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Create New Vinyl',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (eligibleAlbums.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningOrange.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.warningOrange,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Albums Eligible for Vinyl',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.warningOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Albums need 10,000+ plays, \$5,000+ revenue, or 500+ fame to be eligible for vinyl release.',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            ...eligibleAlbums.map(
              (album) => _buildAlbumVinylCard(context, album),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlbumVinylCard(BuildContext context, Album album) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withOpacity(0.1),
            AppTheme.accentGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Album cover
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: album.coverImagePath != null
                  ? ImageManager.getImageWidget(
                      album.coverImagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.album,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Album info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.title,
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${album.songs.length} songs • ${album.genre}',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatNumber(album.totalPlays)} plays • \$${album.totalRevenue.toStringAsFixed(0)} revenue',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Create vinyl button
          Flexible(
            child: ElevatedButton(
              onPressed: () => _showVinylCreationDialog(context, album),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create Vinyl'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingVinylsSection(BuildContext context) {
    if (player.vinyls.isEmpty) {
      return Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.album, color: AppTheme.textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              'No Vinyl Releases Yet',
              style: AppTheme.titleMedium.copyWith(color: AppTheme.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first vinyl to start collecting physical sales revenue!',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.album, color: AppTheme.primaryPurple, size: 24),
              const SizedBox(width: 12),
              Text(
                'My Vinyl Collection',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...player.vinyls.map((vinyl) => _buildVinylCard(vinyl)),
        ],
      ),
    );
  }

  Widget _buildVinylCard(Vinyl vinyl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.album, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vinyl.albumTitle,
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (vinyl.specialEdition != null)
                  Text(
                    '${vinyl.specialEdition} Edition',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.accentGold,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  '${vinyl.unitsSold} units sold • \$${vinyl.pricePerUnit}/unit',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${vinyl.totalRevenue.toStringAsFixed(0)}',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Total Revenue',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVinylCreationDialog(BuildContext context, Album album) {
    showDialog(
      context: context,
      builder: (context) => VinylCreationDialog(player: player, album: album),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toString();
    }
  }
}

class VinylCreationDialog extends StatefulWidget {
  final PlayerModel player;
  final Album album;

  const VinylCreationDialog({
    required this.player,
    required this.album,
    super.key,
  });

  @override
  State<VinylCreationDialog> createState() => _VinylCreationDialogState();
}

class _VinylCreationDialogState extends State<VinylCreationDialog> {
  String? selectedEdition;
  final editions = [
    'Standard',
    'Limited',
    'Colored',
    'Picture Disc',
    'Splatter',
  ];
  final editionPrices = {
    'Standard': 25.0,
    'Limited': 35.0,
    'Colored': 30.0,
    'Picture Disc': 40.0,
    'Splatter': 45.0,
  };

  @override
  Widget build(BuildContext context) {
    final basePrice = editionPrices[selectedEdition] ?? 25.0;
    final canAfford = widget.player.money >= 2000 && widget.player.energy >= 25;

    return AlertDialog(
      backgroundColor: AppTheme.cardBackground,
      title: Text(
        'Create Vinyl for "${widget.album.title}"',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose the vinyl edition type:',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedEdition,
                hint: const Text(
                  'Select Edition',
                  style: TextStyle(color: Colors.white70),
                ),
                isExpanded: true,
                dropdownColor: AppTheme.cardBackground,
                style: AppTheme.bodyLarge,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.accentGold,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                items: editions
                    .map(
                      (edition) => DropdownMenuItem(
                        value: edition,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(edition),
                            Text(
                              '\$${editionPrices[edition]!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEdition = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryPurple.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Production Cost:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Text(
                      '\$2,000',
                      style: TextStyle(color: AppTheme.energyRed),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Energy Cost:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Text(
                      '25 Energy',
                      style: TextStyle(color: AppTheme.energyRed),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price per Unit:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '\$${basePrice.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppTheme.successGreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!canAfford) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.energyRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.energyRed.withOpacity(0.3)),
              ),
              child: const Text(
                'Insufficient funds or energy!',
                style: TextStyle(color: AppTheme.energyRed),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: canAfford && selectedEdition != null
              ? () {
                  bool success = widget.player.createVinyl(
                    widget.album,
                    specialEdition: selectedEdition == 'Standard'
                        ? null
                        : selectedEdition,
                  );
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Vinyl created for "${widget.album.title}"!',
                        ),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGold,
            foregroundColor: Colors.black,
          ),
          child: const Text('Create Vinyl'),
        ),
      ],
    );
  }
}
