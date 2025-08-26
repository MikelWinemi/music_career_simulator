import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class TouringScreen extends StatefulWidget {
  final PlayerModel player;
  const TouringScreen({required this.player, super.key});

  @override
  State<TouringScreen> createState() => _TouringScreenState();
}

class _TouringScreenState extends State<TouringScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.player,
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
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.mic_external_on,
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
                              'Touring & Concerts',
                              style: AppTheme.titleLarge,
                            ),
                            Text(
                              'Manage your live performances',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textMuted,
                    tabs: const [
                      Tab(text: 'Invitations'),
                      Tab(text: 'Concerts'),
                      Tab(text: 'Tours'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildInvitationsTab(),
                      _buildConcertsTab(),
                      _buildToursTab(),
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

  Widget _buildInvitationsTab() {
    if (widget.player.concertInvitations.isEmpty) {
      return _buildEmptyState(
        'No Concert Invitations',
        'Build your fanbase and fame to receive concert invitations!',
        Icons.mail_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.player.concertInvitations.length,
      itemBuilder: (context, index) {
        final invitation = widget.player.concertInvitations[index];
        return _buildInvitationCard(invitation);
      },
    );
  }

  Widget _buildConcertsTab() {
    if (widget.player.concerts.isEmpty) {
      return _buildEmptyState(
        'No Scheduled Concerts',
        'Accept concert invitations to start performing live!',
        Icons.event,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.player.concerts.length,
      itemBuilder: (context, index) {
        final concert = widget.player.concerts[index];
        return _buildConcertCard(concert);
      },
    );
  }

  Widget _buildToursTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tour Creation Card
          if (widget.player.canGoOnTour && !widget.player.hasActiveTour)
            _buildTourCreationCard(),
          const SizedBox(height: 16),
          // Active Tour
          if (widget.player.activeTour != null) _buildActiveTourCard(),
          const SizedBox(height: 16),
          // Past Tours
          if (widget.player.tours.isNotEmpty) _buildPastToursSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.titleMedium.copyWith(color: AppTheme.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationCard(Concert invitation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showInvitationDetails(invitation),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getConcertTypeIcon(invitation.type),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.name,
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '${invitation.venue} • ${invitation.city}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                invitation.type,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.accentGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${invitation.capacity} capacity',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                        '\$${invitation.ticketPrice.toStringAsFixed(0)}',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'per ticket',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildConcertCard(Concert concert) {
    final isUpcoming = concert.date.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: concert.isCompleted || !isUpcoming
              ? null
              : () => _performConcert(concert),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: concert.isCompleted
                        ? AppTheme.goldGradient
                        : AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    concert.isCompleted ? Icons.check_circle : Icons.event,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concert.name,
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '${concert.venue} • ${concert.city}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      if (concert.isCompleted) ...[
                        Text(
                          '${concert.ticketsSold}/${concert.capacity} tickets sold',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Scheduled for ${_formatDate(concert.date)}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (concert.isCompleted) ...[
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${concert.revenue.toStringAsFixed(0)}',
                          style: AppTheme.titleMedium.copyWith(
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '+${concert.fansGained} fans',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryPurple,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ] else if (isUpcoming) ...[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => _performConcert(concert),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Perform'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTourCreationCard() {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_road, color: AppTheme.accentGold, size: 24),
              const SizedBox(width: 12),
              Text(
                'Create New Tour',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Plan a multi-city tour to reach more fans and maximize earnings!',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requirements:',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '• 200+ Fame\n• 1,000+ Fans\n• 50+ Energy\n• \$5,000 setup cost',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _createTour,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Create Tour'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTourCard() {
    final tour = widget.player.activeTour!;

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tour, color: AppTheme.primaryPurple, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Active Tour: ${tour.name}',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Text(
                    '${tour.completedConcerts}/${tour.totalConcerts} concerts',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Revenue',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Text(
                    '\$${tour.totalRevenue.toStringAsFixed(0)}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPastToursSection() {
    final pastTours = widget.player.tours.where((t) => t.isCompleted).toList();

    if (pastTours.isEmpty) {
      return Container();
    }

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Tours',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...pastTours.map(
            (tour) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tour.name,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '\$${tour.totalRevenue.toStringAsFixed(0)}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInvitationDetails(Concert invitation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          invitation.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Venue', invitation.venue),
            _buildDetailRow('City', invitation.city),
            _buildDetailRow('Date', _formatDate(invitation.date)),
            _buildDetailRow('Type', invitation.type),
            _buildDetailRow('Capacity', '${invitation.capacity} people'),
            _buildDetailRow(
              'Ticket Price',
              '\$${invitation.ticketPrice.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 12),
            Text(
              'Estimated Earnings: \$${(invitation.capacity * invitation.ticketPrice * 0.4).toStringAsFixed(0)} - \$${(invitation.capacity * invitation.ticketPrice * 0.8).toStringAsFixed(0)}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              bool success = widget.player.acceptConcertInvitation(invitation);
              Navigator.pop(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Accepted invitation for ${invitation.name}!',
                    ),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accept Invitation'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
          ),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  void _performConcert(Concert concert) {
    if (widget.player.energy < 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough energy to perform concert!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success = widget.player.performScheduledConcert(concert);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Concert performed! Check results in completed concerts.',
          ),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      setState(() {});
    }
  }

  void _createTour() {
    // Simple tour creation - could be expanded with a more detailed dialog
    final tourConcerts = widget.player.concerts
        .where((c) => !c.isCompleted && c.date.isAfter(DateTime.now()))
        .take(3)
        .toList();

    if (tourConcerts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Need at least 2 upcoming concerts to create a tour!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final tour = widget.player.createTour(
      tourName: '${widget.player.artistName} Tour ${DateTime.now().year}',
      tourConcerts: tourConcerts,
    );

    if (tour != null) {
      widget.player.startTour(tour);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tour "${tour.name}" created and started!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      setState(() {});
    }
  }

  IconData _getConcertTypeIcon(String type) {
    switch (type) {
      case 'Festival':
        return Icons.festival;
      case 'Opening Act':
        return Icons.support;
      case 'Solo':
        return Icons.person;
      default:
        return Icons.mic;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
