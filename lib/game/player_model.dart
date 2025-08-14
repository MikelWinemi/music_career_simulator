import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Trait {
  final String name;
  final Color color;
  int level;
  double progress;
  int baseEnergyCost;
  int maxLevel;

  Trait({
    required this.name,
    required this.color,
    this.level = 1,
    this.progress = 0.0,
    this.baseEnergyCost = 8,
    this.maxLevel = 20,
  });

  // Dynamic energy cost that increases as you get closer to max level
  int get energyCost {
    double progressToMax = (level - 10) / (maxLevel - 10);
    progressToMax = progressToMax.clamp(0.0, 1.0);

    // Exponential increase: starts at base cost, goes up to base * 5 at max level
    // Uses quadratic scaling for more dramatic increase at higher levels
    double multiplier = 1.0 + (4.0 * progressToMax * progressToMax);
    int dynamicCost = (baseEnergyCost * multiplier).round();
    return dynamicCost;
  }

  bool canUpgrade(int currentEnergy) {
    return currentEnergy >= energyCost && progress >= 1.0 && level < maxLevel;
  }

  void upgrade() {
    if (progress >= 1.0 && level < maxLevel) {
      level++;
      progress = 0.0;
    }
  }

  bool get isMaxLevel => level >= maxLevel;

  void addProgress(double amount) {
    progress = (progress + amount).clamp(0.0, 1.0);
  }
}

class Song {
  final String title;
  final String genre;
  final int quality;
  bool isRecorded;
  int plays;
  int likes;
  double revenue;
  DateTime releaseDate;
  String? albumTitle; // Which album this song belongs to, if any

  Song({
    required this.title,
    required this.genre,
    required this.quality,
    this.isRecorded = false,
    this.plays = 0,
    this.likes = 0,
    this.revenue = 0.0,
    required this.releaseDate,
    this.albumTitle,
  });
}

class Album {
  final String title;
  final String genre;
  final DateTime releaseDate;
  List<Song> songs;
  bool isReleased;
  int totalPlays;
  double totalRevenue;

  Album({
    required this.title,
    required this.genre,
    required this.releaseDate,
    List<Song>? songs,
    this.isReleased = false,
    this.totalPlays = 0,
    this.totalRevenue = 0.0,
  }) : songs = songs ?? [];

  void addSong(Song song) {
    songs.add(song);
  }

  int get songCount => songs.length;

  void updateStats() {
    totalPlays = songs.fold(0, (sum, song) => sum + song.plays);
    totalRevenue = songs.fold(0.0, (sum, song) => sum + song.revenue);
  }
}

class Contact {
  final String name;
  final String type; // 'musician', 'producer', 'influencer', 'critic'
  final String genre;
  int
  relationshipLevel; // -100 to 100 (-100 = major beef, 0 = neutral, 100 = best friends)
  String status; // 'neutral', 'friend', 'rival', 'enemy', 'collaborator'
  final int influence; // How much they can impact your career (1-10)
  final String bio;
  bool hasCollabed;
  bool isInBeef;
  List<String> recentInteractions;

  Contact({
    required this.name,
    required this.type,
    required this.genre,
    this.relationshipLevel = 0,
    this.status = 'neutral',
    required this.influence,
    required this.bio,
    this.hasCollabed = false,
    this.isInBeef = false,
    List<String>? recentInteractions,
  }) : recentInteractions = recentInteractions ?? [];

  String get relationshipDescription {
    if (relationshipLevel >= 80) return 'Best Friends';
    if (relationshipLevel >= 60) return 'Close Friends';
    if (relationshipLevel >= 40) return 'Friends';
    if (relationshipLevel >= 20) return 'Acquaintances';
    if (relationshipLevel >= -20) return 'Neutral';
    if (relationshipLevel >= -40) return 'Dislike';
    if (relationshipLevel >= -60) return 'Rivals';
    if (relationshipLevel >= -80) return 'Enemies';
    return 'Major Beef';
  }

  Color get relationshipColor {
    if (relationshipLevel >= 60) return const Color(0xFF10B981); // Green
    if (relationshipLevel >= 20) return const Color(0xFF3B82F6); // Blue
    if (relationshipLevel >= -20) return const Color(0xFF6B7280); // Gray
    if (relationshipLevel >= -60) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFFEF4444); // Red
  }

  IconData get relationshipIcon {
    if (relationshipLevel >= 60) return Icons.favorite;
    if (relationshipLevel >= 20) return Icons.thumb_up;
    if (relationshipLevel >= -20) return Icons.remove_circle_outline;
    if (relationshipLevel >= -60) return Icons.thumb_down;
    return Icons.block;
  }
}

class RecordDeal {
  final String label;
  final int duration; // in weeks
  final double royaltyRate;
  final int advance;
  final int weeksSigned;

  RecordDeal({
    required this.label,
    required this.duration,
    required this.royaltyRate,
    required this.advance,
    this.weeksSigned = 0,
  });
}

class PlayerModel extends ChangeNotifier {
  // Basic stats
  int money = 500;
  int energy = 100;
  int maxEnergy = 100;
  int week = 1;
  int year = 2023;
  String? eventMessage;

  // Music career stats
  int fans = 0;
  int fame = 0;
  int happiness = 50;
  int stress = 0;
  String artistName = "Unknown Artist";

  // Character creation data
  String playerName = "";
  String careerType = "artist"; // "artist" or "producer"
  String gender = "male"; // "male" or "female"

  // Avatar Plus configuration
  String avatarStyle =
      "rapper"; // "rapper", "pop", "rock", "country", "electronic"
  String avatarSkin = "1"; // Skin tone ID
  String avatarHair = "1"; // Hair style ID
  String avatarHairColor = "1"; // Hair color ID
  String avatarTop = "1"; // Top clothing ID
  String avatarAccessories = ""; // Accessories configuration
  String avatarBackground = "1"; // Background style

  bool characterCreated = false;

  // Social media
  int socialMediaFollowers = 0;
  int socialMediaEngagement = 0;

  // Songs and deals
  List<Song> songs = [];
  List<Album> albums = [];
  RecordDeal? currentDeal;

  // Job Market
  String? currentJob;
  int weeklyJobIncome = 0;
  List<String> availableJobs = [
    'Fast Food Worker',
    'Retail Associate',
    'Barista',
    'Delivery Driver',
    'Tutor',
    'Freelancer',
    'Office Assistant',
    'Music Teacher',
    'Social Media Manager',
    'Event Staff',
  ];

  // Career milestones
  bool hasManager = false;
  bool hasAgent = false;
  bool hasProducer = false;
  int albumsSold = 0;
  int concertsPerformed = 0;

  // Relationships
  int familyRelationship = 50;
  int friendsRelationship = 50;
  bool hasPartner = false;
  int partnerRelationship = 0;
  List<Contact> contacts = [];

  // Artist Traits
  late Trait vocals;
  late Trait songWriting;
  late Trait rhythm;
  late Trait charisma;
  late Trait virality;
  late Trait videoDirecting;

  // Business Traits
  late Trait leadership;
  late Trait marketing;

  PlayerModel() {
    _initializeTraits();
    _initializeContacts();
  }

  void _initializeTraits() {
    vocals = Trait(
      name: 'VOCALS',
      color: const Color(0xFF9C27B0),
      level: 10,
      maxLevel: 18,
      baseEnergyCost: 8,
    );
    songWriting = Trait(
      name: 'SONGWRITING',
      color: const Color(0xFF673AB7),
      level: 10,
      maxLevel: 18,
      baseEnergyCost: 8,
    );
    rhythm = Trait(
      name: 'RHYTHM',
      color: const Color(0xFF2196F3),
      level: 10,
      maxLevel: 17,
      baseEnergyCost: 8,
    );
    charisma = Trait(
      name: 'CHARISMA',
      color: const Color(0xFFFF9800),
      level: 10,
      maxLevel: 17,
      baseEnergyCost: 8,
    );
    virality = Trait(
      name: 'VIRALITY',
      color: const Color(0xFFFFC107),
      level: 10,
      maxLevel: 15,
      baseEnergyCost: 8,
    );
    videoDirecting = Trait(
      name: 'DIRECTING',
      color: const Color(0xFF9C27B0),
      level: 10,
      maxLevel: 15,
      baseEnergyCost: 8,
    );

    leadership = Trait(
      name: 'LEADERSHIP',
      color: const Color(0xFFFFB74D),
      level: 2,
      baseEnergyCost: 8,
    );
    marketing = Trait(
      name: 'MARKETING',
      color: const Color(0xFFFF7043),
      level: 2,
      baseEnergyCost: 8,
    );
  }

  void _initializeContacts() {
    contacts = [
      // Musicians
      Contact(
        name: 'Alex Rivera',
        type: 'musician',
        genre: 'Pop',
        influence: 7,
        bio:
            'Rising pop star with millions of TikTok followers. Known for catchy hooks.',
      ),
      Contact(
        name: 'Jordan Black',
        type: 'musician',
        genre: 'Hip-Hop',
        influence: 8,
        bio:
            'Established rapper with multiple platinum albums. Street credibility.',
      ),
      Contact(
        name: 'Maya Chen',
        type: 'musician',
        genre: 'R&B',
        influence: 6,
        bio:
            'Soulful R&B artist with incredible vocal range. Grammy nominated.',
      ),
      Contact(
        name: 'Riley Smith',
        type: 'musician',
        genre: 'Rock',
        influence: 5,
        bio:
            'Indie rock musician with a cult following. Known for authentic sound.',
      ),

      // Producers
      Contact(
        name: 'Marcus "Beats" Johnson',
        type: 'producer',
        genre: 'Hip-Hop',
        influence: 9,
        bio:
            'Legendary producer behind countless hits. Can make or break careers.',
      ),
      Contact(
        name: 'Sophia Williams',
        type: 'producer',
        genre: 'Pop',
        influence: 8,
        bio:
            'Top-tier pop producer. Works with A-list celebrities exclusively.',
      ),
      Contact(
        name: 'David Park',
        type: 'producer',
        genre: 'Electronic',
        influence: 6,
        bio:
            'Electronic music innovator. Master of creating viral dance tracks.',
      ),

      // Influencers & Critics
      Contact(
        name: 'Casey Martinez',
        type: 'influencer',
        genre: 'All',
        influence: 7,
        bio: 'Music blogger with massive following. Reviews can go viral.',
      ),
      Contact(
        name: 'Dr. Patricia Stone',
        type: 'critic',
        genre: 'All',
        influence: 8,
        bio:
            'Respected music critic. Her reviews carry serious weight in the industry.',
      ),
      Contact(
        name: 'Tommy "Viral" Lee',
        type: 'influencer',
        genre: 'All',
        influence: 6,
        bio: 'Social media personality who can make songs trend overnight.',
      ),
    ];
  }

  List<Trait> get artistTraits => [
    vocals,
    songWriting,
    rhythm,
    charisma,
    virality,
    videoDirecting,
  ];
  List<Trait> get businessTraits => [leadership, marketing];

  bool canUpgradeTrait(Trait trait) {
    return energy >= trait.energyCost && trait.progress >= 1.0;
  }

  void upgradeTrait(Trait trait) {
    if (canUpgradeTrait(trait)) {
      energy -= trait.energyCost;
      trait.upgrade();
      notifyListeners();
    }
  }

  void trainTrait(Trait trait) {
    if (energy >= trait.energyCost) {
      energy -= trait.energyCost;
      trait.addProgress(0.2 + Random().nextDouble() * 0.3);
      _addStress(1);
      notifyListeners();
    }
  }

  // Music career actions
  void writeSong() {
    if (energy >= 10) {
      energy -= 10;
      final genres = ['Pop', 'Rock', 'Hip-Hop', 'R&B', 'Electronic', 'Country'];
      final songTitles = [
        'Midnight Dreams',
        'City Lights',
        'Lost in Time',
        'Rising Star',
        'Neon Nights',
      ];

      // Song quality based on songwriting skill and some randomness
      int songQuality = (songWriting.level * 10 + Random().nextInt(40)).clamp(
        10,
        100,
      );

      final song = Song(
        title: songTitles[Random().nextInt(songTitles.length)],
        genre: genres[Random().nextInt(genres.length)],
        quality: songQuality,
        releaseDate: DateTime.now(),
      );

      songs.add(song);
      songWriting.addProgress(0.3);
      eventMessage =
          'You wrote a new song: "${song.title}" (Quality: $songQuality%)!';
      _addStress(2);
      notifyListeners();
    }
  }

  void createCustomSong({
    required String title,
    required String genre,
    String? albumTitle,
    String? existingAlbumTitle,
  }) {
    if (energy >= 10) {
      energy -= 10;

      // Song quality based on songwriting skill and some randomness
      int songQuality = (songWriting.level * 10 + Random().nextInt(40)).clamp(
        10,
        100,
      );

      final song = Song(
        title: title,
        genre: genre,
        quality: songQuality,
        releaseDate: DateTime.now(),
        albumTitle: albumTitle ?? existingAlbumTitle,
      );

      songs.add(song);

      // Handle album creation or addition
      if (albumTitle != null) {
        // Create new album
        final album = Album(
          title: albumTitle,
          genre: genre,
          releaseDate: DateTime.now(),
        );
        album.addSong(song);
        albums.add(album);
        eventMessage = 'Created new album "$albumTitle" with song "$title"!';
      } else if (existingAlbumTitle != null) {
        // Add to existing album
        final album = albums.firstWhere(
          (album) => album.title == existingAlbumTitle,
        );
        album.addSong(song);
        eventMessage = 'Added "$title" to album "$existingAlbumTitle"!';
      } else {
        // Single release
        eventMessage = 'Created new single: "$title" (Quality: $songQuality%)!';
      }

      songWriting.addProgress(0.3);
      _addStress(2);
      notifyListeners();
    }
  }

  void performConcert() {
    if (energy >= 15 && fans >= 50) {
      energy -= 15;
      concertsPerformed++;

      int earnings = (fans * 0.5 + charisma.level * 10).round();
      money += earnings;

      fans += Random().nextInt(20) + 5;
      fame += Random().nextInt(15) + 5;

      charisma.addProgress(0.4);
      vocals.addProgress(0.2);

      eventMessage = 'Concert was a success! Earned \$$earnings';
      _addStress(3);
      _addHappiness(5);
      notifyListeners();
    }
  }

  void recordInStudio() {
    if (energy >= 20 && songs.isNotEmpty) {
      energy -= 20;
      money -= 500; // Studio costs

      final song = songs.last;
      song.plays += Random().nextInt(1000) + 100;
      song.likes += Random().nextInt(100) + 10;
      song.revenue += song.plays * 0.001;

      albumsSold += Random().nextInt(50) + 10;
      money += song.revenue.round();

      vocals.addProgress(0.3);
      eventMessage =
          'Studio session completed! "${song.title}" gaining popularity';
      _addStress(4);
      notifyListeners();
    }
  }

  void recordSong(Song song) {
    if (energy >= 20 && money >= 500 && !song.isRecorded) {
      energy -= 20;
      money -= 500; // Studio costs

      song.isRecorded = true;
      song.plays += Random().nextInt(1000) + 100;
      song.likes += Random().nextInt(100) + 10;
      song.revenue += song.plays * 0.001;

      albumsSold += Random().nextInt(50) + 10;
      money += song.revenue.round();

      vocals.addProgress(0.3);
      eventMessage = 'Recorded "${song.title}"! Now available for streaming';
      _addStress(4);
      notifyListeners();
    }
  }

  String createSocialMediaPost({
    required String platform,
    required String content,
  }) {
    if (energy < 5) {
      return 'Not enough energy to post!';
    }

    energy -= 5;

    // Platform-specific engagement modifiers
    Map<String, double> platformModifiers = {
      'Twitter': 1.2,
      'Instagram': 1.0,
      'TikTok': 1.5,
    };

    // Fan reaction categories and their effects
    List<Map<String, dynamic>> reactions = [
      {
        'type': 'viral',
        'probability': 0.1,
        'fameChange': Random().nextInt(500) + 200,
        'followersChange': Random().nextInt(2000) + 500,
        'messages': [
          'Your post went viral! Incredible reach!',
          'Trending worldwide! Your fame skyrockets!',
          'Breaking the internet! Massive viral success!',
        ],
      },
      {
        'type': 'positive',
        'probability': 0.4,
        'fameChange': Random().nextInt(100) + 50,
        'followersChange': Random().nextInt(500) + 100,
        'messages': [
          'Fans love your post! Great engagement!',
          'Positive response from your audience!',
          'Your fans are sharing your content!',
          'Heartwarming comments flooding in!',
        ],
      },
      {
        'type': 'neutral',
        'probability': 0.35,
        'fameChange': Random().nextInt(50) + 10,
        'followersChange': Random().nextInt(100) + 20,
        'messages': [
          'Solid post with decent engagement.',
          'Your regular fans appreciated the update.',
          'Steady growth from your post.',
        ],
      },
      {
        'type': 'negative',
        'probability': 0.1,
        'fameChange': -(Random().nextInt(30) + 10),
        'followersChange': -(Random().nextInt(50) + 10),
        'messages': [
          'Some mixed reactions to your post.',
          'A few critics didn\'t appreciate the content.',
          'Controversial post sparked debate.',
        ],
      },
      {
        'type': 'backlash',
        'probability': 0.05,
        'fameChange': -(Random().nextInt(150) + 50),
        'followersChange': -(Random().nextInt(300) + 100),
        'messages': [
          'Post received significant backlash!',
          'Fans are disappointed with your content.',
          'Negative publicity from your post!',
        ],
      },
    ];

    // Determine reaction based on probability
    double roll = Random().nextDouble();
    double cumulative = 0.0;
    Map<String, dynamic> selectedReaction = reactions.last;

    for (var reaction in reactions) {
      cumulative += reaction['probability'];
      if (roll <= cumulative) {
        selectedReaction = reaction;
        break;
      }
    }

    // Apply platform modifier
    double modifier = platformModifiers[platform] ?? 1.0;

    int fameChange = (selectedReaction['fameChange'] * modifier).round();
    int followersChange = (selectedReaction['followersChange'] * modifier)
        .round();

    // Apply changes
    fame = (fame + fameChange).clamp(0, double.infinity).toInt();
    socialMediaFollowers = (socialMediaFollowers + followersChange)
        .clamp(0, double.infinity)
        .toInt();

    // Update engagement based on platform
    if (platform == 'TikTok') {
      socialMediaEngagement +=
          Random().nextInt(100) + 50; // TikTok has higher engagement
    } else if (platform == 'Twitter') {
      socialMediaEngagement += Random().nextInt(80) + 30;
    } else {
      socialMediaEngagement += Random().nextInt(60) + 25;
    }

    // Skill progress based on outcome
    if (selectedReaction['type'] == 'viral' ||
        selectedReaction['type'] == 'positive') {
      virality.addProgress(0.3);
      marketing.addProgress(0.2);
      fans += Random().nextInt(20) + 10;
    } else if (selectedReaction['type'] == 'neutral') {
      virality.addProgress(0.1);
      marketing.addProgress(0.1);
      fans += Random().nextInt(5) + 1;
    } else {
      // Negative outcomes still provide some learning
      marketing.addProgress(0.05);
    }

    // Create result message
    List<String> messages = List<String>.from(selectedReaction['messages']);
    String baseMessage = messages[Random().nextInt(messages.length)];

    String fameText = fameChange >= 0 ? '+$fameChange' : '$fameChange';
    String followersText = followersChange >= 0
        ? '+$followersChange'
        : '$followersChange';

    eventMessage = '$baseMessage Fame: $fameText, Followers: $followersText';
    notifyListeners();

    return '$baseMessage\n\nFame change: $fameText\nNew followers: $followersText\nPlatform: $platform';
  }

  void hireManager() {
    if (money >= 5000 && !hasManager) {
      money -= 5000;
      hasManager = true;
      eventMessage = 'You hired a manager! Career opportunities increased';
      notifyListeners();
    }
  }

  void signRecordDeal(RecordDeal deal) {
    if (currentDeal == null && fame >= 100) {
      currentDeal = deal;
      money += deal.advance;
      eventMessage =
          'Signed with ${deal.label}! Received \$${deal.advance} advance';
      notifyListeners();
    }
  }

  void improveRelationships() {
    if (energy >= 8) {
      energy -= 8;
      familyRelationship = (familyRelationship + Random().nextInt(10) + 5)
          .clamp(0, 100);
      friendsRelationship = (friendsRelationship + Random().nextInt(10) + 5)
          .clamp(0, 100);

      if (hasPartner) {
        partnerRelationship = (partnerRelationship + Random().nextInt(15) + 5)
            .clamp(0, 100);
      }

      _addHappiness(3);
      _reduceStress(2);
      eventMessage = 'Spent quality time with loved ones';
      notifyListeners();
    }
  }

  void rest() {
    if (energy < maxEnergy) {
      energy = (energy + 20).clamp(0, maxEnergy);
      _reduceStress(5);
      _addHappiness(2);
      eventMessage = 'Feeling refreshed after resting';
      notifyListeners();
    }
  }

  void _addStress(int amount) {
    stress = (stress + amount).clamp(0, 100);
    if (stress > 80) {
      happiness = (happiness - 2).clamp(0, 100);
    }
  }

  void _reduceStress(int amount) {
    stress = (stress - amount).clamp(0, 100);
  }

  void _addHappiness(int amount) {
    happiness = (happiness + amount).clamp(0, 100);
  }

  void _developTraitsAutomatically() {
    // Slow automatic trait development over time
    // Each trait has a small chance to gain progress each week
    final random = Random();

    for (var trait in artistTraits) {
      if (!trait.isMaxLevel) {
        // Base chance of 20% per week, modified by trait level
        double developmentChance = 0.2 - (trait.level * 0.005);
        developmentChance = developmentChance.clamp(
          0.05,
          0.2,
        ); // Min 5%, Max 20%

        if (random.nextDouble() < developmentChance) {
          // Add small progress (0.1 to 0.3)
          double progressGain = 0.1 + (random.nextDouble() * 0.2);
          trait.addProgress(progressGain);

          // If progress is full, auto-upgrade
          if (trait.progress >= 1.0 && !trait.isMaxLevel) {
            trait.upgrade();
          }
        }
      }
    }
  }

  void endWeek() {
    week++;
    if (week > 52) {
      week = 1;
      year++;
    }
    energy = maxEnergy;

    // Weekly income from various sources
    int weeklyIncome = 0;

    // Job income
    if (currentJob != null) {
      weeklyIncome += weeklyJobIncome;
    }

    // Record deal royalties
    if (currentDeal != null) {
      weeklyIncome += (albumsSold * currentDeal!.royaltyRate * 10).round();
    }

    // Social media sponsorships
    if (socialMediaFollowers > 1000) {
      weeklyIncome += (socialMediaFollowers * 0.01).round();
    }

    // Song streaming revenue
    for (var song in songs) {
      weeklyIncome += (song.revenue * 0.1).round();
    }

    // Base income from leadership and marketing
    weeklyIncome += (leadership.level * 10) + (marketing.level * 15);

    money += weeklyIncome;

    // Weekly relationship decay if not maintained
    familyRelationship = (familyRelationship - 1).clamp(0, 100);
    friendsRelationship = (friendsRelationship - 1).clamp(0, 100);
    if (hasPartner) {
      partnerRelationship = (partnerRelationship - 2).clamp(0, 100);
    }

    // Natural stress reduction
    _reduceStress(2);

    // Automatic trait development
    _developTraitsAutomatically();

    String jobIncomeText = currentJob != null
        ? ' (including \$${weeklyJobIncome} from ${currentJob})'
        : '';
    eventMessage =
        'New week! Earned \$$weeklyIncome from various sources$jobIncomeText';
    notifyListeners();
    saveData(); // Save data when week ends
  }

  void clearEvent() {
    eventMessage = null;
    notifyListeners();
  }

  // Helper methods for UI
  String get fameLevel {
    if (fame < 50) return 'Unknown';
    if (fame < 200) return 'Local';
    if (fame < 500) return 'Regional';
    if (fame < 1000) return 'National';
    return 'International';
  }

  // Contact relationship management methods
  String interactWithContact(Contact contact, String actionType) {
    if (energy < 5) {
      return 'Not enough energy to interact!';
    }

    energy -= 5;

    int relationshipChange = 0;
    String outcome = '';

    switch (actionType) {
      case 'compliment':
        relationshipChange = Random().nextInt(15) + 5;
        contact.recentInteractions.add('You complimented ${contact.name}');
        outcome = 'You complimented ${contact.name}. They appreciated it!';
        break;

      case 'collaborate':
        if (contact.relationshipLevel >= 20) {
          relationshipChange = Random().nextInt(20) + 10;
          contact.hasCollabed = true;
          contact.recentInteractions.add('Collaborated on a project');

          // Gain benefits based on contact type and influence
          if (contact.type == 'producer') {
            songWriting.addProgress(0.3);
            fame += contact.influence * 10;
          } else if (contact.type == 'musician') {
            charisma.addProgress(0.2);
            fans += contact.influence * 20;
          } else if (contact.type == 'influencer') {
            virality.addProgress(0.4);
            socialMediaFollowers += contact.influence * 100;
          }

          outcome =
              'Successful collaboration with ${contact.name}! Your career benefits.';
        } else {
          relationshipChange = Random().nextInt(10) + 5;
          outcome = '${contact.name} agreed to collaborate in the future.';
        }
        break;

      case 'gift':
        if (money >= 1000) {
          money -= 1000;
          relationshipChange = Random().nextInt(25) + 15;
          contact.recentInteractions.add('You gave them a thoughtful gift');
          outcome = 'You gave ${contact.name} a gift. They were touched!';
        } else {
          return 'Not enough money for a gift!';
        }
        break;

      case 'diss_track':
        relationshipChange = -(Random().nextInt(40) + 30);
        contact.isInBeef = true;
        contact.recentInteractions.add('You released a diss track about them');

        // Beef can boost fame but damage relationships
        fame += contact.influence * 15;
        virality.addProgress(0.5);
        socialMediaFollowers += contact.influence * 50;

        // But also increase stress and potentially lose fans
        _addStress(10);
        if (Random().nextBool()) {
          fans -= Random().nextInt(contact.influence * 10);
        }

        outcome =
            'You started beef with ${contact.name}! Fame increased but relationship damaged.';
        break;

      case 'subtweet':
        relationshipChange = -(Random().nextInt(20) + 10);
        contact.recentInteractions.add('You subtweeted about them');
        socialMediaEngagement += Random().nextInt(100) + 50;
        outcome =
            'You threw shade at ${contact.name} on social media. Drama ensued!';
        break;

      case 'apologize':
        if (contact.relationshipLevel < 0) {
          relationshipChange = Random().nextInt(30) + 20;
          contact.isInBeef = false;
          contact.recentInteractions.add('You apologized sincerely');
          outcome = 'You apologized to ${contact.name}. They forgave you!';
        } else {
          relationshipChange = Random().nextInt(10) + 5;
          outcome = '${contact.name} appreciated your humility.';
        }
        break;

      case 'ignore':
        relationshipChange = -(Random().nextInt(10) + 1);
        contact.recentInteractions.add(
          'You ignored their attempts to reach out',
        );
        outcome = 'You ignored ${contact.name}. They noticed.';
        break;

      default:
        outcome = 'Invalid action.';
    }

    // Apply relationship change
    contact.relationshipLevel = (contact.relationshipLevel + relationshipChange)
        .clamp(-100, 100);

    // Update status based on new relationship level
    if (contact.relationshipLevel >= 60) {
      contact.status = 'friend';
    } else if (contact.relationshipLevel >= 20) {
      contact.status = 'collaborator';
    } else if (contact.relationshipLevel <= -60) {
      contact.status = 'enemy';
    } else if (contact.relationshipLevel <= -20) {
      contact.status = 'rival';
    } else {
      contact.status = 'neutral';
    }

    // Limit recent interactions to last 3
    if (contact.recentInteractions.length > 3) {
      contact.recentInteractions.removeAt(0);
    }

    eventMessage = outcome;
    notifyListeners();

    return outcome;
  }

  Color get stressColor {
    if (stress < 30) return Colors.green;
    if (stress < 60) return Colors.orange;
    return Colors.red;
  }

  Color get happinessColor {
    if (happiness > 70) return Colors.green;
    if (happiness > 40) return Colors.orange;
    return Colors.red;
  }

  // Job Market Methods
  Map<String, int> getJobSalaries() {
    return {
      'Fast Food Worker': 200,
      'Retail Associate': 250,
      'Barista': 230,
      'Delivery Driver': 280,
      'Tutor': 350,
      'Freelancer': 400,
      'Office Assistant': 320,
      'Music Teacher': 450,
      'Social Media Manager': 500,
      'Event Staff': 300,
    };
  }

  String getJobDescription(String job) {
    switch (job) {
      case 'Fast Food Worker':
        return 'Basic service job. Low pay but flexible hours.';
      case 'Retail Associate':
        return 'Customer service focused. Develops communication skills.';
      case 'Barista':
        return 'Coffee shop work. Good for networking with locals.';
      case 'Delivery Driver':
        return 'Flexible timing, good for music schedule.';
      case 'Tutor':
        return 'Teaching others. Improves your skills too.';
      case 'Freelancer':
        return 'Various gig work. Unpredictable but decent pay.';
      case 'Office Assistant':
        return 'Regular hours and steady income.';
      case 'Music Teacher':
        return 'Share your passion while earning. Boosts music skills.';
      case 'Social Media Manager':
        return 'Manage online presence. Great for building your brand.';
      case 'Event Staff':
        return 'Work at venues. Network with industry professionals.';
      default:
        return 'Part-time work to support your music career.';
    }
  }

  String applyForJob(String jobTitle) {
    if (energy < 10) {
      return 'Not enough energy to apply for jobs!';
    }

    if (currentJob == jobTitle) {
      return 'You already have this job!';
    }

    energy -= 10;
    final jobSalaries = getJobSalaries();

    if (currentJob != null) {
      // Quit current job
      currentJob = null;
      weeklyJobIncome = 0;
    }

    // Apply for new job
    currentJob = jobTitle;
    weeklyJobIncome = jobSalaries[jobTitle] ?? 200;

    // Some jobs provide additional benefits
    switch (jobTitle) {
      case 'Music Teacher':
        songWriting.addProgress(0.1);
        break;
      case 'Social Media Manager':
        virality.addProgress(0.1);
        socialMediaFollowers += 100;
        break;
      case 'Event Staff':
        charisma.addProgress(0.1);
        // Chance to meet industry contacts
        if (Random().nextBool()) {
          fame += 10;
        }
        break;
      case 'Tutor':
        leadership.addProgress(0.1);
        break;
    }

    eventMessage =
        'Congratulations! You got the $jobTitle job. You\'ll earn \$${weeklyJobIncome} per week.';
    notifyListeners();
    saveData(); // Save data when job changes
    return eventMessage!;
  }

  String quitJob() {
    if (currentJob == null) {
      return 'You don\'t have a job to quit!';
    }

    String formerJob = currentJob!;
    currentJob = null;
    weeklyJobIncome = 0;

    eventMessage =
        'You quit your job as $formerJob. Focus on your music career!';
    notifyListeners();
    saveData(); // Save data when job changes
    return eventMessage!;
  }

  // Persistence methods
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save character data
    await prefs.setString('playerName', playerName);
    await prefs.setString('careerType', careerType);
    await prefs.setString('gender', gender);
    await prefs.setString('avatarStyle', avatarStyle);
    await prefs.setString('avatarSkin', avatarSkin);
    await prefs.setString('avatarHair', avatarHair);
    await prefs.setString('avatarHairColor', avatarHairColor);
    await prefs.setString('avatarTop', avatarTop);
    await prefs.setString('avatarAccessories', avatarAccessories);
    await prefs.setString('avatarBackground', avatarBackground);
    await prefs.setBool('characterCreated', characterCreated);

    // Save game progress
    await prefs.setInt('money', money);
    await prefs.setInt('energy', energy);
    await prefs.setInt('maxEnergy', maxEnergy);
    await prefs.setInt('week', week);
    await prefs.setInt('year', year);
    await prefs.setInt('fans', fans);
    await prefs.setInt('fame', fame);
    await prefs.setInt('happiness', happiness);
    await prefs.setInt('stress', stress);
    await prefs.setString('artistName', artistName);
    await prefs.setInt('socialMediaFollowers', socialMediaFollowers);
    await prefs.setInt('socialMediaEngagement', socialMediaEngagement);

    // Save job data
    if (currentJob != null) {
      await prefs.setString('currentJob', currentJob!);
      await prefs.setInt('weeklyJobIncome', weeklyJobIncome);
    } else {
      await prefs.remove('currentJob');
      await prefs.remove('weeklyJobIncome');
    }

    // Save traits
    await prefs.setInt('vocalsLevel', vocals.level);
    await prefs.setDouble('vocalsProgress', vocals.progress);
    await prefs.setInt('songWritingLevel', songWriting.level);
    await prefs.setDouble('songWritingProgress', songWriting.progress);
    await prefs.setInt('rhythmLevel', rhythm.level);
    await prefs.setDouble('rhythmProgress', rhythm.progress);
    await prefs.setInt('charismaLevel', charisma.level);
    await prefs.setDouble('charismaProgress', charisma.progress);
    await prefs.setInt('viralityLevel', virality.level);
    await prefs.setDouble('viralityProgress', virality.progress);
    await prefs.setInt('videoDirectingLevel', videoDirecting.level);
    await prefs.setDouble('videoDirectingProgress', videoDirecting.progress);
    await prefs.setInt('leadershipLevel', leadership.level);
    await prefs.setDouble('leadershipProgress', leadership.progress);
    await prefs.setInt('marketingLevel', marketing.level);
    await prefs.setDouble('marketingProgress', marketing.progress);

    // Save songs
    List<String> songTitles = songs.map((song) => song.title).toList();
    await prefs.setStringList('songTitles', songTitles);

    // Save relationships
    await prefs.setInt('familyRelationship', familyRelationship);
    await prefs.setInt('friendsRelationship', friendsRelationship);
    await prefs.setBool('hasPartner', hasPartner);
    await prefs.setInt('partnerRelationship', partnerRelationship);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load character data
    playerName = prefs.getString('playerName') ?? '';
    careerType = prefs.getString('careerType') ?? 'artist';
    gender = prefs.getString('gender') ?? 'male';
    avatarStyle = prefs.getString('avatarStyle') ?? 'rapper';
    avatarSkin = prefs.getString('avatarSkin') ?? '1';
    avatarHair = prefs.getString('avatarHair') ?? '1';
    avatarHairColor = prefs.getString('avatarHairColor') ?? '1';
    avatarTop = prefs.getString('avatarTop') ?? '1';
    avatarAccessories = prefs.getString('avatarAccessories') ?? '';
    avatarBackground = prefs.getString('avatarBackground') ?? '1';
    characterCreated = prefs.getBool('characterCreated') ?? false;

    // Load game progress
    money = prefs.getInt('money') ?? 500;
    energy = prefs.getInt('energy') ?? 100;
    maxEnergy = prefs.getInt('maxEnergy') ?? 100;
    week = prefs.getInt('week') ?? 1;
    year = prefs.getInt('year') ?? 2023;
    fans = prefs.getInt('fans') ?? 0;
    fame = prefs.getInt('fame') ?? 0;
    happiness = prefs.getInt('happiness') ?? 50;
    stress = prefs.getInt('stress') ?? 0;
    artistName = prefs.getString('artistName') ?? 'Unknown Artist';
    socialMediaFollowers = prefs.getInt('socialMediaFollowers') ?? 0;
    socialMediaEngagement = prefs.getInt('socialMediaEngagement') ?? 0;

    // Load job data
    currentJob = prefs.getString('currentJob');
    weeklyJobIncome = prefs.getInt('weeklyJobIncome') ?? 0;

    // Load traits
    vocals.level = prefs.getInt('vocalsLevel') ?? 10;
    vocals.progress = prefs.getDouble('vocalsProgress') ?? 0.0;
    songWriting.level = prefs.getInt('songWritingLevel') ?? 10;
    songWriting.progress = prefs.getDouble('songWritingProgress') ?? 0.0;
    rhythm.level = prefs.getInt('rhythmLevel') ?? 10;
    rhythm.progress = prefs.getDouble('rhythmProgress') ?? 0.0;
    charisma.level = prefs.getInt('charismaLevel') ?? 10;
    charisma.progress = prefs.getDouble('charismaProgress') ?? 0.0;
    virality.level = prefs.getInt('viralityLevel') ?? 10;
    virality.progress = prefs.getDouble('viralityProgress') ?? 0.0;
    videoDirecting.level = prefs.getInt('videoDirectingLevel') ?? 10;
    videoDirecting.progress = prefs.getDouble('videoDirectingProgress') ?? 0.0;
    leadership.level = prefs.getInt('leadershipLevel') ?? 1;
    leadership.progress = prefs.getDouble('leadershipProgress') ?? 0.0;
    marketing.level = prefs.getInt('marketingLevel') ?? 1;
    marketing.progress = prefs.getDouble('marketingProgress') ?? 0.0;

    // Load relationships
    familyRelationship = prefs.getInt('familyRelationship') ?? 50;
    friendsRelationship = prefs.getInt('friendsRelationship') ?? 50;
    hasPartner = prefs.getBool('hasPartner') ?? false;
    partnerRelationship = prefs.getInt('partnerRelationship') ?? 0;

    notifyListeners();
  }

  Future<void> clearSaveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> resetGame() async {
    await clearSaveData();

    // Reset to initial values
    playerName = "";
    careerType = "artist";
    gender = "male";
    avatarStyle = "rapper";
    avatarSkin = "1";
    avatarHair = "1";
    avatarHairColor = "1";
    avatarTop = "1";
    avatarAccessories = "";
    avatarBackground = "1";
    characterCreated = false;

    money = 500;
    energy = 100;
    maxEnergy = 100;
    week = 1;
    year = 2023;
    fans = 0;
    fame = 0;
    happiness = 50;
    stress = 0;
    artistName = "Unknown Artist";
    socialMediaFollowers = 0;
    socialMediaEngagement = 0;

    currentJob = null;
    weeklyJobIncome = 0;

    songs.clear();
    albums.clear();
    contacts.clear();

    familyRelationship = 50;
    friendsRelationship = 50;
    hasPartner = false;
    partnerRelationship = 0;

    _initializeTraits();
    _initializeContacts();

    eventMessage = null;
    notifyListeners();
  }
}
