import 'package:flutter/material.dart';
import 'player_model.dart';
import 'ui/app_theme.dart';

class RelationshipManagementScreen extends StatefulWidget {
  final PlayerModel player;

  const RelationshipManagementScreen({required this.player, super.key});

  @override
  State<RelationshipManagementScreen> createState() =>
      _RelationshipManagementScreenState();
}

class _RelationshipManagementScreenState
    extends State<RelationshipManagementScreen> {
  String _selectedFilter = 'all';
  Contact? _selectedContact;

  final List<Map<String, dynamic>> _quickActions = [
    {
      'id': 'compliment',
      'name': 'Compliment',
      'icon': Icons.thumb_up,
      'color': Color(0xFF10B981),
      'description': 'Give them a genuine compliment',
      'energyCost': 5,
      'moneyCost': 0,
    },
    {
      'id': 'collaborate',
      'name': 'Collaborate',
      'icon': Icons.handshake,
      'color': Color(0xFF3B82F6),
      'description': 'Propose a collaboration',
      'energyCost': 5,
      'moneyCost': 0,
    },
    {
      'id': 'gift',
      'name': 'Send Gift',
      'icon': Icons.card_giftcard,
      'color': Color(0xFF8B5CF6),
      'description': 'Send an expensive gift',
      'energyCost': 5,
      'moneyCost': 1000,
    },
    {
      'id': 'diss_track',
      'name': 'Diss Track',
      'icon': Icons.music_note,
      'color': Color(0xFFEF4444),
      'description': 'Release a diss track about them',
      'energyCost': 5,
      'moneyCost': 0,
    },
    {
      'id': 'subtweet',
      'name': 'Subtweet',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFFF59E0B),
      'description': 'Throw shade on social media',
      'energyCost': 5,
      'moneyCost': 0,
    },
    {
      'id': 'apologize',
      'name': 'Apologize',
      'icon': Icons.favorite_border,
      'color': Color(0xFF06B6D4),
      'description': 'Make amends for past conflicts',
      'energyCost': 5,
      'moneyCost': 0,
    },
  ];

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
                              'Industry Contacts',
                              style: AppTheme.titleLarge,
                            ),
                            Text(
                              'Manage your relationships',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      // Energy indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.energyRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.energyRed),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: AppTheme.energyRed,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.player.energy}',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.energyRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterTab('all', 'All'),
                      _buildFilterTab('musician', 'Musicians'),
                      _buildFilterTab('producer', 'Producers'),
                      _buildFilterTab('influencer', 'Influencers'),
                      _buildFilterTab('critic', 'Critics'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Contact list
                Expanded(
                  child: _selectedContact == null
                      ? _buildContactsList()
                      : _buildContactDetails(),
                ),

                // End Week button
                Container(
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.player.endWeek();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fast_forward, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'END WEEK',
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.black,
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
        ),
      ),
    );
  }

  Widget _buildFilterTab(String filter, String label) {
    final isSelected = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedFilter = filter;
          _selectedContact = null;
        }),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryPurple.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryPurple
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall.copyWith(
              color: isSelected
                  ? AppTheme.primaryPurple
                  : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    final filteredContacts = widget.player.contacts.where((contact) {
      if (_selectedFilter == 'all') return true;
      return contact.type == _selectedFilter;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = filteredContacts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: AppTheme.cardDecoration,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: contact.relationshipColor.withOpacity(0.2),
              child: Icon(
                _getContactTypeIcon(contact.type),
                color: contact.relationshipColor,
              ),
            ),
            title: Text(
              contact.name,
              style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_capitalizeFirst(contact.type)} • ${contact.genre}',
                  style: AppTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      contact.relationshipIcon,
                      size: 16,
                      color: contact.relationshipColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      contact.relationshipDescription,
                      style: AppTheme.bodySmall.copyWith(
                        color: contact.relationshipColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        contact.influence,
                        (i) => Icon(
                          Icons.star,
                          size: 12,
                          color: AppTheme.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textMuted,
              size: 16,
            ),
            onTap: () => setState(() => _selectedContact = contact),
          ),
        );
      },
    );
  }

  Widget _buildContactDetails() {
    final contact = _selectedContact!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Contact header
          Container(
            decoration: AppTheme.cardDecoration,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _selectedContact = null),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: contact.relationshipColor.withOpacity(
                        0.2,
                      ),
                      child: Icon(
                        _getContactTypeIcon(contact.type),
                        color: contact.relationshipColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contact.name, style: AppTheme.titleMedium),
                          Text(
                            '${_capitalizeFirst(contact.type)} • ${contact.genre}',
                            style: AppTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                contact.relationshipIcon,
                                size: 18,
                                color: contact.relationshipColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                contact.relationshipDescription,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: contact.relationshipColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Relationship meter
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Relationship Level',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.accentGold,
                            ),
                          ),
                          Text(
                            '${contact.relationshipLevel}/100',
                            style: AppTheme.bodyMedium.copyWith(
                              color: contact.relationshipColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (contact.relationshipLevel + 100) / 200,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          contact.relationshipColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bio
                Text(
                  contact.bio,
                  style: AppTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Influence stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Influence: ', style: AppTheme.bodyMedium),
                    ...List.generate(
                      contact.influence,
                      (i) => Icon(
                        Icons.star,
                        size: 16,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recent interactions
          if (contact.recentInteractions.isNotEmpty) ...[
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Interactions',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...contact.recentInteractions.map(
                    (interaction) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              interaction,
                              style: AppTheme.bodyMedium,
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
          ],

          // Quick actions
          Container(
            decoration: AppTheme.cardDecoration,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.accentGold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _quickActions.length,
                  itemBuilder: (context, index) {
                    final action = _quickActions[index];
                    return _buildActionButton(action, contact);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> action, Contact contact) {
    final canAfford =
        widget.player.energy >= action['energyCost'] &&
        widget.player.money >= action['moneyCost'];

    return GestureDetector(
      onTap: canAfford ? () => _performAction(action['id'], contact) : null,
      child: Container(
        decoration: BoxDecoration(
          color: canAfford
              ? action['color'].withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: canAfford ? action['color'] : Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action['icon'],
              color: canAfford ? action['color'] : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              action['name'],
              style: AppTheme.bodyMedium.copyWith(
                color: canAfford ? action['color'] : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (action['moneyCost'] > 0)
              Text(
                '\$${action['moneyCost']}',
                style: AppTheme.bodySmall.copyWith(
                  color: canAfford ? AppTheme.textMuted : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _performAction(String actionId, Contact contact) {
    final result = widget.player.interactWithContact(contact, actionId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Row(
          children: [
            Icon(_getActionIcon(actionId), color: _getActionColor(actionId)),
            const SizedBox(width: 8),
            Text('Action Result', style: AppTheme.titleMedium),
          ],
        ),
        content: Text(result, style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentGold),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getContactTypeIcon(String type) {
    switch (type) {
      case 'musician':
        return Icons.music_note;
      case 'producer':
        return Icons.settings_input_component;
      case 'influencer':
        return Icons.trending_up;
      case 'critic':
        return Icons.rate_review;
      default:
        return Icons.person;
    }
  }

  IconData _getActionIcon(String actionId) {
    final action = _quickActions.firstWhere((a) => a['id'] == actionId);
    return action['icon'];
  }

  Color _getActionColor(String actionId) {
    final action = _quickActions.firstWhere((a) => a['id'] == actionId);
    return action['color'];
  }

  String _capitalizeFirst(String str) {
    return str.isEmpty ? str : str[0].toUpperCase() + str.substring(1);
  }
}
