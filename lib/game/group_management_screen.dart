import 'package:flutter/material.dart';
import 'ui/app_theme.dart';
import 'player_model.dart';

class GroupManagementScreen extends StatefulWidget {
  final PlayerModel player;

  const GroupManagementScreen({Key? key, required this.player})
    : super(key: key);

  @override
  _GroupManagementScreenState createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _memberNameController = TextEditingController();
  String _selectedGenre = 'Pop';
  List<String> _memberNames = [];

  // Define theme colors as constants for easy replacement
  static const Color primaryColor = AppTheme.primaryPurple;
  static const Color accentColor = AppTheme.accentGold;
  static const Color cardColor = AppTheme.cardBackground;

  final List<String> _genres = [
    'Pop',
    'Rock',
    'Hip-Hop',
    'R&B',
    'Electronic',
    'Country',
    'Jazz',
    'Blues',
    'Reggae',
    'Classical',
    'Folk',
    'Punk',
    'Metal',
    'Alternative',
    'Indie',
    'Rage',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _groupNameController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Management'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'My Groups'),
            Tab(text: 'Create Group'),
            Tab(text: 'Join Group'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildMyGroupsTab(widget.player),
            _buildCreateGroupTab(widget.player),
            _buildJoinGroupTab(widget.player),
          ],
        ),
      ),
    );
  }

  Widget _buildMyGroupsTab(PlayerModel player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (player.currentGroup != null) ...[
            _buildCurrentGroupCard(player, player.currentGroup!),
            const SizedBox(height: 20),
          ],
          const Text(
            'All My Groups',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (player.groups.isEmpty)
            _buildEmptyState('You haven\'t joined any groups yet!')
          else
            ...player.groups.map((group) => _buildGroupCard(player, group)),
        ],
      ),
    );
  }

  Widget _buildCurrentGroupCard(PlayerModel player, Group group) {
    return Card(
      color: cardColor.withOpacity(0.9),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'CURRENT GROUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                if (group.leader == player.artistName)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'LEADER',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Genre: ${group.genre}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Members: ${group.members.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip('Fame', group.fame.toString(), Colors.purple),
                const SizedBox(width: 8),
                _buildStatChip('Fans', group.fanBase.toString(), Colors.blue),
                const SizedBox(width: 8),
                _buildStatChip(
                  'Songs',
                  group.groupSongs.length.toString(),
                  Colors.green,
                ),
              ],
            ),
            if (group.leader == player.artistName) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateGroupSongDialog(player, group),
                icon: const Icon(Icons.music_note),
                label: const Text('Create Group Song'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(PlayerModel player, Group group) {
    bool isCurrentGroup = player.currentGroup?.name == group.name;
    return Card(
      color: cardColor.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isCurrentGroup)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Genre: ${group.genre} • Members: ${group.members.length}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!isCurrentGroup)
                  ElevatedButton(
                    onPressed: () => _setActiveGroup(player, group),
                    child: const Text('Set Active'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => _leaveGroup(player, group),
                  child: const Text('Leave Group'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateGroupTab(PlayerModel player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Group',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: cardColor.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _groupNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    dropdownColor: cardColor,
                    items: _genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(
                          genre,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Members',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _memberNameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Member name',
                            hintStyle: const TextStyle(color: Colors.white30),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white30,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white30,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addMember,
                        child: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (_memberNames.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _memberNames.map((name) {
                        return Chip(
                          label: Text(name),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeMember(name),
                          backgroundColor: accentColor.withOpacity(0.7),
                          labelStyle: const TextStyle(color: Colors.white),
                          deleteIconColor: Colors.white,
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canCreateGroup(player)
                          ? () => _createGroup(player)
                          : null,
                      child: const Text('Create Group'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (!_canCreateGroup(player))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Need: Group name, at least 1 member, and 20 energy',
                        style: TextStyle(color: Colors.red[300], fontSize: 12),
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

  Widget _buildJoinGroupTab(PlayerModel player) {
    List<Group> availableGroups = player.availableGroupsToJoin;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Groups',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (availableGroups.isEmpty)
            _buildEmptyState('No groups are looking for new members right now.')
          else
            ...availableGroups.map(
              (group) => _buildAvailableGroupCard(player, group),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailableGroupCard(PlayerModel player, Group group) {
    return Card(
      color: cardColor.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Genre: ${group.genre}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Members: ${group.members.length} • Leader: ${group.leader}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip('Fame', group.fame.toString(), Colors.purple),
                const SizedBox(width: 8),
                _buildStatChip('Fans', group.fanBase.toString(), Colors.blue),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _joinGroup(player, group),
                  child: const Text('Join Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.white30),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  void _addMember() {
    String memberName = _memberNameController.text.trim();
    if (memberName.isNotEmpty && !_memberNames.contains(memberName)) {
      setState(() {
        _memberNames.add(memberName);
        _memberNameController.clear();
      });
    }
  }

  void _removeMember(String name) {
    setState(() {
      _memberNames.remove(name);
    });
  }

  bool _canCreateGroup(PlayerModel player) {
    return _groupNameController.text.trim().isNotEmpty &&
        _memberNames.isNotEmpty &&
        player.energy >= 20;
  }

  void _createGroup(PlayerModel player) {
    if (_canCreateGroup(player)) {
      player.createGroup(
        _groupNameController.text.trim(),
        _selectedGenre,
        _memberNames,
      );
      setState(() {
        _groupNameController.clear();
        _memberNames.clear();
        _selectedGenre = 'Pop';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Group "${_groupNameController.text.trim()}" created successfully!',
          ),
          backgroundColor: accentColor,
        ),
      );
      _tabController.animateTo(0); // Switch to My Groups tab
    }
  }

  void _joinGroup(PlayerModel player, Group group) {
    player.joinGroup(group);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined group "${group.name}"!'),
        backgroundColor: accentColor,
      ),
    );
    _tabController.animateTo(0); // Switch to My Groups tab
  }

  void _leaveGroup(PlayerModel player, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text('Leave Group', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to leave "${group.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              player.leaveGroup(group);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Left group "${group.name}"'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _setActiveGroup(PlayerModel player, Group group) {
    setState(() {
      player.currentGroup = group;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Set "${group.name}" as active group'),
        backgroundColor: accentColor,
      ),
    );
  }

  void _showCreateGroupSongDialog(PlayerModel player, Group group) {
    final songTitleController = TextEditingController();
    String selectedGenre = group.genre;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text(
          'Create Group Song',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: songTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Song Title',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGenre,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Genre',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
              dropdownColor: cardColor,
              items: _genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(
                    genre,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                selectedGenre = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (songTitleController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                player.createGroupSong(
                  songTitleController.text.trim(),
                  selectedGenre,
                  group,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Created group song "${songTitleController.text.trim()}"!',
                    ),
                    backgroundColor: accentColor,
                  ),
                );
              }
            },
            child: const Text('Create', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
