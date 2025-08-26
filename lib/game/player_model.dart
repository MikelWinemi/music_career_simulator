import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'award_system.dart';

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
  bool isPublished;
  int plays;
  int likes;
  double revenue;
  DateTime releaseDate;
  DateTime? publishDate;
  String? albumTitle; // Which album this song belongs to, if any
  String? groupName; // If this is a group song
  SongPopularity popularity;
  bool isGroupSong;
  String? coverImagePath; // Path to the song's cover image

  Song({
    required this.title,
    required this.genre,
    required this.quality,
    this.isRecorded = false,
    this.isPublished = false,
    this.plays = 0,
    this.likes = 0,
    this.revenue = 0.0,
    required this.releaseDate,
    this.publishDate,
    this.albumTitle,
    this.groupName,
    SongPopularity? popularity,
    this.isGroupSong = false,
    this.coverImagePath,
  }) : popularity = popularity ?? SongPopularity();

  void publish() {
    isPublished = true;
    publishDate = DateTime.now();
  }

  void updateDailyStats(int playerFame) {
    if (isPublished) {
      popularity.updatePopularity(playerFame, quality);
      plays = popularity.streams;

      // Calculate revenue based on streams
      double baseRevenue = popularity.streams * 0.001; // $0.001 per stream
      if (popularity.isViral) {
        baseRevenue *= 5; // Viral songs get bonus revenue
      } else if (popularity.isHit) {
        baseRevenue *= 2;
      }
      revenue += baseRevenue;
    }
  }

  bool get isCharting => popularity.isCharting;
  bool get isViral => popularity.isViral;
  bool get isHit => popularity.isHit;
  int get chartPosition => popularity.peakPosition;
}

class Album {
  final String title;
  final String genre;
  final DateTime releaseDate;
  List<Song> songs;
  bool isReleased;
  int totalPlays;
  double totalRevenue;
  List<String> collaborators; // List of collaborator names
  String? producedBy; // Producer name if applicable
  bool isCollaborativeAlbum;
  String? coverImagePath; // Path to the album's cover image
  bool hasVinyl; // Whether a vinyl version exists
  DateTime? vinylReleaseDate;
  int vinylSales;

  Album({
    required this.title,
    required this.genre,
    required this.releaseDate,
    List<Song>? songs,
    this.isReleased = false,
    this.totalPlays = 0,
    this.totalRevenue = 0.0,
    List<String>? collaborators,
    this.producedBy,
    this.isCollaborativeAlbum = false,
    this.coverImagePath,
    this.hasVinyl = false,
    this.vinylReleaseDate,
    this.vinylSales = 0,
  }) : songs = songs ?? [],
       collaborators = collaborators ?? [];

  void addSong(Song song) {
    songs.add(song);
  }

  int get songCount => songs.length;

  void updateStats() {
    totalPlays = songs.fold(0, (sum, song) => sum + song.plays);
    totalRevenue = songs.fold(0.0, (sum, song) => sum + song.revenue);
  }

  // Check if album is eligible for vinyl release
  bool get canCreateVinyl {
    if (hasVinyl) return false;
    updateStats();
    return totalPlays >= 10000 || totalRevenue >= 5000;
  }

  void createVinyl() {
    if (canCreateVinyl) {
      hasVinyl = true;
      vinylReleaseDate = DateTime.now();
      vinylSales = 0;
    }
  }
}

class Vinyl {
  final String albumTitle;
  final DateTime releaseDate;
  int unitsSold;
  double pricePerUnit;
  String? specialEdition; // "Limited", "Colored", "Picture Disc", etc.

  Vinyl({
    required this.albumTitle,
    required this.releaseDate,
    this.unitsSold = 0,
    this.pricePerUnit = 25.0,
    this.specialEdition,
  });

  double get totalRevenue => unitsSold * pricePerUnit;
}

class Concert {
  final String name;
  final String venue;
  final String city;
  final DateTime date;
  final String type; // "Solo", "Festival", "Tour", "Opening Act"
  int capacity;
  int ticketsSold;
  double ticketPrice;
  bool isCompleted;
  int fansGained;
  double revenue;

  Concert({
    required this.name,
    required this.venue,
    required this.city,
    required this.date,
    required this.type,
    this.capacity = 1000,
    this.ticketsSold = 0,
    this.ticketPrice = 50.0,
    this.isCompleted = false,
    this.fansGained = 0,
    this.revenue = 0.0,
  });

  double get totalRevenue => ticketsSold * ticketPrice;
  bool get isSoldOut => ticketsSold >= capacity;
  double get attendanceRate => capacity > 0 ? ticketsSold / capacity : 0.0;
}

class Tour {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  List<Concert> concerts;
  bool isActive;
  bool isCompleted;
  double totalRevenue;
  int totalFansGained;

  Tour({
    required this.name,
    required this.startDate,
    required this.endDate,
    List<Concert>? concerts,
    this.isActive = false,
    this.isCompleted = false,
    this.totalRevenue = 0.0,
    this.totalFansGained = 0,
  }) : concerts = concerts ?? [];

  void addConcert(Concert concert) {
    concerts.add(concert);
  }

  void updateStats() {
    totalRevenue = concerts.fold(0.0, (sum, concert) => sum + concert.revenue);
    totalFansGained = concerts.fold(
      0,
      (sum, concert) => sum + concert.fansGained,
    );
  }

  int get completedConcerts => concerts.where((c) => c.isCompleted).length;
  int get totalConcerts => concerts.length;
  bool get canStart => concerts.isNotEmpty && !isActive && !isCompleted;
}

class Group {
  final String name;
  final String genre;
  final DateTime formedDate;
  List<String> members;
  String leader; // Name of the group leader (usually the player)
  bool isActive;
  int fame;
  int fanBase;
  List<Song> groupSongs;
  List<Album> groupAlbums;
  double groupRevenue;
  String? recordLabel;

  Group({
    required this.name,
    required this.genre,
    required this.formedDate,
    required this.members,
    required this.leader,
    this.isActive = true,
    this.fame = 0,
    this.fanBase = 0,
    List<Song>? groupSongs,
    List<Album>? groupAlbums,
    this.groupRevenue = 0.0,
    this.recordLabel,
  }) : groupSongs = groupSongs ?? [],
       groupAlbums = groupAlbums ?? [];

  void addMember(String memberName) {
    if (!members.contains(memberName)) {
      members.add(memberName);
    }
  }

  void removeMember(String memberName) {
    members.removeWhere((member) => member == memberName);
  }

  void addGroupSong(Song song) {
    groupSongs.add(song);
  }

  void updateGroupStats() {
    groupRevenue = groupSongs.fold(0.0, (sum, song) => sum + song.revenue);
    fanBase = groupSongs.fold(0, (sum, song) => sum + song.plays) ~/ 100;
  }

  bool get hasEnoughMembers => members.length >= 2;
}

class SongPopularity {
  int streams;
  int views; // For music videos
  int dailyGrowth;
  double trendingScore; // 0.0 to 1.0
  List<String> platforms; // 'Spotify', 'YouTube', 'Apple Music', etc.
  bool isCharting;
  int peakPosition;
  int weeksOnChart;

  SongPopularity({
    this.streams = 0,
    this.views = 0,
    this.dailyGrowth = 0,
    this.trendingScore = 0.0,
    List<String>? platforms,
    this.isCharting = false,
    this.peakPosition = 0,
    this.weeksOnChart = 0,
  }) : platforms = platforms ?? ['Independent'];

  void updatePopularity(int playerFame, int songQuality) {
    // Base growth calculation
    int baseGrowth = (playerFame * songQuality / 100).round();
    baseGrowth = baseGrowth.clamp(10, 10000);

    // Random factor for viral potential
    double viralChance = Random().nextDouble();
    if (viralChance > 0.95) {
      baseGrowth *= 10; // Viral hit!
    } else if (viralChance > 0.85) {
      baseGrowth *= 3; // Popular song
    }

    dailyGrowth = baseGrowth;
    streams += dailyGrowth;
    views += (dailyGrowth * 0.7).round(); // Slightly fewer views than streams

    // Update trending score
    trendingScore = (dailyGrowth / 10000.0).clamp(0.0, 1.0);

    // Check if song enters charts
    if (streams > 100000 && !isCharting) {
      isCharting = true;
      peakPosition = Random().nextInt(100) + 1;
    }

    if (isCharting) {
      weeksOnChart++;
    }
  }

  bool get isViral => streams > 1000000;
  bool get isHit => streams > 500000;
  bool get isPopular => streams > 100000;
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
  int year = 2025;
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
  int age = 18; // Player's starting age

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
  List<Group> groups = []; // Groups the player is part of
  Group? currentGroup; // Currently active group
  RecordDeal? currentDeal;

  // Touring and concerts
  List<Concert> concerts = [];
  List<Tour> tours = [];
  Tour? activeTour;
  List<Vinyl> vinyls = [];

  // Concert invitations and opportunities
  List<Concert> concertInvitations = [];

  // Awards and achievements
  List<Award> awards = [];

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
      final genres = [
        'Pop',
        'Rock',
        'Hip-Hop',
        'R&B',
        'Electronic',
        'Country',
        'Rage',
      ];
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
    String? coverImagePath,
    String? albumCoverImagePath,
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
        coverImagePath: coverImagePath,
      );

      songs.add(song);

      // Handle album creation or addition
      if (albumTitle != null) {
        // Create new album
        final album = Album(
          title: albumTitle,
          genre: genre,
          releaseDate: DateTime.now(),
          coverImagePath:
              albumCoverImagePath ??
              coverImagePath, // Use album cover or fall back to song cover
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

  // Create a collaborative album with another artist or producer
  bool createCollaborativeAlbum({
    required String albumTitle,
    required String collaboratorName,
    required String collaboratorType, // "artist" or "producer"
    required String genre,
    List<Song>? initialSongs,
    String? coverImagePath,
  }) {
    if (energy < 30 || money < 1000) {
      eventMessage = 'Not enough energy or money for a collaborative album!';
      return false;
    }

    energy -= 30;
    money -= 1000; // Higher cost for collaboration

    final album = Album(
      title: albumTitle,
      genre: genre,
      releaseDate: DateTime.now(),
      songs: initialSongs ?? [],
      isCollaborativeAlbum: true,
      collaborators: [collaboratorName],
      producedBy: collaboratorType == "producer" ? collaboratorName : null,
      coverImagePath: coverImagePath,
    );

    albums.add(album);

    // Boost fame and other stats for collaboration
    fame += Random().nextInt(20) + 10;
    fans += Random().nextInt(100) + 50;

    // Add collaboration-specific benefits
    if (collaboratorType == "producer") {
      songWriting.addProgress(0.4);
      vocals.addProgress(0.3);
    } else {
      charisma.addProgress(0.3);
      socialMediaFollowers += Random().nextInt(5000) + 1000;
    }

    eventMessage =
        'Created collaborative album "$albumTitle" with $collaboratorName!';
    _addStress(3);
    _addHappiness(4);
    notifyListeners();
    return true;
  }

  // VINYL CREATION METHODS
  bool canCreateVinyl(Album album) {
    if (album.hasVinyl) return false;
    album.updateStats();
    return album.totalPlays >= 10000 ||
        album.totalRevenue >= 5000 ||
        fame >= 500;
  }

  bool createVinyl(Album album, {String? specialEdition}) {
    if (!canCreateVinyl(album) || energy < 25 || money < 2000) {
      eventMessage = 'Cannot create vinyl: requirements not met!';
      return false;
    }

    energy -= 25;
    money -= 2000; // Vinyl production cost

    album.hasVinyl = true;
    album.vinylReleaseDate = DateTime.now();

    double basePrice = 25.0;
    if (specialEdition != null) {
      basePrice *= 1.5; // Special editions cost more
    }

    final vinyl = Vinyl(
      albumTitle: album.title,
      releaseDate: DateTime.now(),
      pricePerUnit: basePrice,
      specialEdition: specialEdition,
    );

    vinyls.add(vinyl);

    // Initial sales based on popularity
    int initialSales = (fans * 0.1 + fame * 0.05).round().clamp(10, 1000);
    vinyl.unitsSold = initialSales;
    album.vinylSales = initialSales;

    double vinylRevenue = vinyl.totalRevenue;
    money += vinylRevenue.round();

    fame += 15;
    fans += Random().nextInt(200) + 50;

    eventMessage =
        'Created vinyl for "${album.title}"! Sold $initialSales units!';
    _addHappiness(3);
    notifyListeners();
    return true;
  }

  // TOURING AND CONCERT METHODS
  bool get canGoOnTour {
    return fame >= 200 && fans >= 1000 && energy >= 50;
  }

  bool get hasActiveTour {
    return activeTour != null && activeTour!.isActive;
  }

  void generateConcertInvitations() {
    if (fans < 500) return; // Need minimum fanbase

    // Clear old invitations
    concertInvitations.clear();

    int numInvitations = 0;

    // Fame-based invitation generation
    if (fame >= 100) numInvitations += 1;
    if (fame >= 300) numInvitations += 1;
    if (fame >= 500) numInvitations += 1;
    if (fame >= 1000) numInvitations += 2;

    // Fan-based invitation generation
    if (fans >= 1000) numInvitations += 1;
    if (fans >= 5000) numInvitations += 1;
    if (fans >= 10000) numInvitations += 2;

    final venues = [
      'The Mercury Lounge',
      'Webster Hall',
      'Brooklyn Bowl',
      'Terminal 5',
      'Madison Square Garden',
      'Barclays Center',
      'Red Rocks',
      'The Fillmore',
      'House of Blues',
      'The Troubadour',
      'The Roxy',
      'The Wiltern',
    ];

    final cities = [
      'New York',
      'Los Angeles',
      'Chicago',
      'Nashville',
      'Austin',
      'Atlanta',
      'Seattle',
      'Denver',
      'Boston',
      'Philadelphia',
    ];

    final concertTypes = ['Solo', 'Festival', 'Opening Act'];

    for (int i = 0; i < numInvitations; i++) {
      final venue = venues[Random().nextInt(venues.length)];
      final city = cities[Random().nextInt(cities.length)];
      final type = concertTypes[Random().nextInt(concertTypes.length)];

      int capacity = 500;
      double ticketPrice = 30.0;

      // Adjust based on fame and type
      if (fame >= 500) {
        capacity = Random().nextInt(2000) + 1000;
        ticketPrice = 50.0;
      }
      if (fame >= 1000) {
        capacity = Random().nextInt(5000) + 2000;
        ticketPrice = 75.0;
      }

      if (type == 'Festival') {
        capacity = Random().nextInt(10000) + 5000;
        ticketPrice = 100.0;
      } else if (type == 'Opening Act') {
        capacity = Random().nextInt(1000) + 500;
        ticketPrice = 25.0;
      }

      final concert = Concert(
        name: '$type at $venue',
        venue: venue,
        city: city,
        date: DateTime.now().add(Duration(days: Random().nextInt(60) + 7)),
        type: type,
        capacity: capacity,
        ticketPrice: ticketPrice,
      );

      concertInvitations.add(concert);
    }

    if (concertInvitations.isNotEmpty) {
      eventMessage =
          'You have ${concertInvitations.length} new concert invitation(s)!';
      notifyListeners();
    }
  }

  bool acceptConcertInvitation(Concert concert) {
    if (energy < 30) {
      eventMessage = 'Not enough energy to accept concert invitation!';
      return false;
    }

    concerts.add(concert);
    concertInvitations.remove(concert);

    eventMessage = 'Accepted concert invitation for ${concert.name}!';
    notifyListeners();
    return true;
  }

  bool performScheduledConcert(Concert concert) {
    if (energy < 30 || concert.isCompleted) {
      eventMessage = 'Cannot perform concert!';
      return false;
    }

    energy -= 30;

    // Calculate attendance based on fame and local popularity
    double attendanceRate = 0.4; // Base 40% attendance

    if (fame >= 300) attendanceRate += 0.2;
    if (fame >= 500) attendanceRate += 0.2;
    if (fame >= 1000) attendanceRate += 0.2;

    // Add some randomness
    attendanceRate += (Random().nextDouble() - 0.5) * 0.3;
    attendanceRate = attendanceRate.clamp(0.2, 1.0);

    concert.ticketsSold = (concert.capacity * attendanceRate).round();
    concert.revenue = concert.ticketsSold * concert.ticketPrice;
    concert.fansGained = (concert.ticketsSold * 0.1).round();
    concert.isCompleted = true;

    // Add earnings and fans
    money += concert.revenue.round();
    fans += concert.fansGained;
    fame += (concert.fansGained * 0.1).round() + 5;

    // Skill progression
    charisma.addProgress(0.4);
    vocals.addProgress(0.3);

    // Update concert count
    concertsPerformed++;

    eventMessage =
        'Concert performed! Earned \$${concert.revenue.round()} and gained ${concert.fansGained} fans!';
    _addHappiness(4);
    _addStress(3);
    notifyListeners();
    return true;
  }

  Tour? createTour({
    required String tourName,
    required List<Concert> tourConcerts,
  }) {
    if (!canGoOnTour || money < 5000) {
      eventMessage = 'Cannot create tour: requirements not met!';
      return null;
    }

    money -= 5000; // Tour setup costs

    final tour = Tour(
      name: tourName,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(
        Duration(days: 7 + (tourConcerts.length * 3)),
      ),
      concerts: tourConcerts,
    );

    tours.add(tour);
    eventMessage =
        'Created tour "$tourName" with ${tourConcerts.length} concerts!';
    notifyListeners();
    return tour;
  }

  bool startTour(Tour tour) {
    if (activeTour != null || energy < 50) {
      eventMessage = 'Cannot start tour!';
      return false;
    }

    tour.isActive = true;
    activeTour = tour;

    eventMessage = 'Started tour "${tour.name}"!';
    _addHappiness(5);
    notifyListeners();
    return true;
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

    // Check for award shows at the end of the year
    if (AwardSystem.isAwardSeason(week)) {
      Map<AwardShow, List<Nomination>> awardResults = AwardSystem.runAwardShows(
        this,
      );
      _processAwardResults(awardResults);
    }

    // Update song popularity and streaming daily
    updateSongPopularity();

    // Generate concert invitations based on popularity
    if (Random().nextDouble() < 0.3) {
      // 30% chance each week
      generateConcertInvitations();
    }

    // Update vinyl sales
    for (var vinyl in vinyls) {
      int weeklySales = (fans * 0.01 + fame * 0.005).round().clamp(0, 50);
      vinyl.unitsSold += weeklySales;
      money += (weeklySales * vinyl.pricePerUnit).round();
    }

    String jobIncomeText = currentJob != null
        ? ' (including \$${weeklyJobIncome} from ${currentJob})'
        : '';
    eventMessage =
        'New week! Earned \$$weeklyIncome from various sources$jobIncomeText';
    notifyListeners();
    saveData(); // Save data when week ends
  }

  // Process award show results and update player stats
  void _processAwardResults(Map<AwardShow, List<Nomination>> awardResults) {
    List<String> awardMessages = [];
    int totalAwards = 0;
    int totalNominations = 0;

    for (var entry in awardResults.entries) {
      AwardShow show = entry.key;
      List<Nomination> nominations = entry.value;

      String showName = show == AwardShow.grammys
          ? "Grammy Awards"
          : "American Music Awards";

      for (var nomination in nominations) {
        totalNominations++;
        if (nomination.won) {
          totalAwards++;
          awardMessages.add(
            "🏆 Won ${AwardSystem.getCategoryDisplayName(nomination.category)} at $showName!",
          );

          // Award benefits
          fame += 50; // Major fame boost
          money += 10000; // Prize money
          happiness += 20; // Personal satisfaction
          socialMediaFollowers += (fame * 0.1).round(); // More followers
        } else {
          awardMessages.add(
            "🌟 Nominated for ${AwardSystem.getCategoryDisplayName(nomination.category)} at $showName",
          );
          fame += 10; // Nomination still gives fame
          happiness += 5;
        }
      }
    }

    // Update event message with award results
    if (awardMessages.isNotEmpty) {
      String yearSummary = "🎊 AWARD SEASON $year RESULTS 🎊\n\n";
      yearSummary += awardMessages.join('\n');

      if (totalAwards > 0) {
        yearSummary +=
            "\n\n🎉 Congratulations! You won $totalAwards award(s) this year!";
        if (totalAwards >= 3) {
          yearSummary += "\n🌟 What an incredible year for your career!";
        }
      } else if (totalNominations > 0) {
        yearSummary +=
            "\n\n⭐ Great job getting $totalNominations nomination(s)! Keep working hard!";
      }

      eventMessage = yearSummary;
    }
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

            // Chance for collaborative album with producer
            if (Random().nextBool() && albums.length < 10) {
              String albumTitle = "Produced by ${contact.name}";
              createCollaborativeAlbum(
                albumTitle: albumTitle,
                collaboratorName: contact.name,
                collaboratorType: "producer",
                genre: avatarStyle,
                coverImagePath: null,
              );
              outcome =
                  'Created collaborative album with producer ${contact.name}!';
            } else {
              outcome =
                  'Successful collaboration with ${contact.name}! Your career benefits.';
            }
          } else if (contact.type == 'musician') {
            charisma.addProgress(0.2);
            fans += contact.influence * 20;

            // Chance for collaborative album with artist
            if (Random().nextBool() && albums.length < 10) {
              String albumTitle = "$artistName & ${contact.name}";
              createCollaborativeAlbum(
                albumTitle: albumTitle,
                collaboratorName: contact.name,
                collaboratorType: "artist",
                genre: avatarStyle,
                coverImagePath: null,
              );
              outcome = 'Created joint album with ${contact.name}!';
            } else {
              outcome =
                  'Successful collaboration with ${contact.name}! Your career benefits.';
            }
          } else if (contact.type == 'influencer') {
            virality.addProgress(0.4);
            socialMediaFollowers += contact.influence * 100;
            outcome =
                'Successful collaboration with ${contact.name}! Your career benefits.';
          }
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

      case 'collab_album':
        if (contact.relationshipLevel >= 30) {
          if (money >= 1000 && energy >= 30) {
            String albumTitle = "${artistName} & ${contact.name}";
            String collaboratorType = contact.type == 'producer'
                ? 'producer'
                : 'artist';

            bool success = createCollaborativeAlbum(
              albumTitle: albumTitle,
              collaboratorName: contact.name,
              collaboratorType: collaboratorType,
              genre: avatarStyle,
              coverImagePath: null,
            );

            if (success) {
              relationshipChange = Random().nextInt(30) + 20;
              contact.hasCollabed = true;
              contact.recentInteractions.add(
                'Created collaborative album together',
              );
              outcome =
                  'Successfully created collaborative album "$albumTitle" with ${contact.name}!';
            } else {
              outcome =
                  'Failed to create collaborative album. Try again later.';
            }
          } else {
            outcome =
                'Not enough money (\$1,000) or energy (30) for a collaborative album!';
          }
        } else {
          relationshipChange = Random().nextInt(10) + 5;
          outcome =
              '${contact.name} wants to build a stronger relationship first before making albums together.';
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

  // Group management methods
  void createGroup(String groupName, String genre, List<String> memberNames) {
    if (energy >= 20) {
      energy -= 20;

      List<String> allMembers = [artistName, ...memberNames];

      final newGroup = Group(
        name: groupName,
        genre: genre,
        formedDate: DateTime.now(),
        members: allMembers,
        leader: artistName,
      );

      groups.add(newGroup);
      currentGroup = newGroup;

      eventMessage =
          'Created group "$groupName" with ${allMembers.length} members!';

      // Boost fame for group creation
      fame += 50;
      fans += 100;

      leadership.addProgress(0.4);
      charisma.addProgress(0.3);
      _addStress(5);

      notifyListeners();
    }
  }

  void joinGroup(Group group) {
    if (!group.members.contains(artistName)) {
      group.addMember(artistName);
      groups.add(group);
      currentGroup = group;

      eventMessage = 'Joined group "${group.name}"!';

      // Boost from joining established group
      fame += 30;
      fans += group.fanBase ~/ 10;

      charisma.addProgress(0.2);
      notifyListeners();
    }
  }

  void leaveGroup(Group group) {
    group.removeMember(artistName);
    groups.removeWhere((g) => g.name == group.name);

    if (currentGroup?.name == group.name) {
      currentGroup = null;
    }

    eventMessage = 'Left group "${group.name}"';

    // Small penalty for leaving
    fans -= 50;
    _addStress(3);

    notifyListeners();
  }

  void createGroupSong(String title, String genre, Group group) {
    if (energy >= 15 && currentGroup != null) {
      energy -= 15;

      int baseQuality = songWriting.level * 5;
      int collaborationBonus =
          group.members.length * 10; // Bonus for collaboration
      int groupFameBonus = group.fame ~/ 50;

      int songQuality = (baseQuality + collaborationBonus + groupFameBonus)
          .clamp(10, 100);

      final song = Song(
        title: title,
        genre: genre,
        quality: songQuality,
        releaseDate: DateTime.now(),
        groupName: group.name,
        isGroupSong: true,
      );

      songs.add(song);
      group.addGroupSong(song);

      eventMessage =
          'Created group song "$title" with ${group.name}! Quality: $songQuality%';

      songWriting.addProgress(0.4);
      leadership.addProgress(0.2);
      _addStress(3);

      notifyListeners();
    }
  }

  void publishSong(Song song) {
    if (!song.isPublished && song.isRecorded) {
      song.publish();

      // Initial boost based on player fame and song quality
      int initialStreams = ((fame * song.quality / 10).clamp(
        100,
        10000,
      )).round();
      song.popularity.streams = initialStreams;
      song.popularity.views = (initialStreams * 0.8).round();

      eventMessage =
          'Published "${song.title}"! Initial streams: ${song.popularity.streams}';

      // Small fame boost for publishing
      fame += 10;
      fans += 25;

      marketing.addProgress(0.3);
      notifyListeners();
    }
  }

  void updateSongPopularity() {
    // Update all published songs daily
    for (var song in songs.where((s) => s.isPublished)) {
      song.updateDailyStats(fame);

      // Check for milestones
      if (song.isViral && !song.popularity.platforms.contains('Trending')) {
        song.popularity.platforms.add('Trending');
        eventMessage = '"${song.title}" has gone VIRAL! 🔥';
        fame += 500;
        fans += 10000;
      } else if (song.isHit && !song.popularity.platforms.contains('Popular')) {
        song.popularity.platforms.add('Popular');
        eventMessage = '"${song.title}" is now a HIT! 🎵';
        fame += 200;
        fans += 2000;
      } else if (song.popularity.isPopular &&
          !song.popularity.platforms.contains('Rising')) {
        song.popularity.platforms.add('Rising');
        eventMessage = '"${song.title}" is gaining popularity! 📈';
        fame += 50;
        fans += 500;
      }
    }

    // Update group stats if in a group
    if (currentGroup != null) {
      currentGroup!.updateGroupStats();
    }

    notifyListeners();
  }

  void promoteOnSocialMedia(Song song) {
    if (energy >= 10 && song.isPublished) {
      energy -= 10;

      // Boost song popularity through social media promotion
      int promotionBoost = (socialMediaFollowers / 100 + marketing.level * 10)
          .round();
      song.popularity.streams += promotionBoost;
      song.popularity.views += (promotionBoost * 1.2).round();

      // Gain followers from promotion
      socialMediaFollowers += Random().nextInt(100) + 20;

      eventMessage =
          'Promoted "${song.title}" on social media! +$promotionBoost streams';

      marketing.addProgress(0.3);
      virality.addProgress(0.2);

      notifyListeners();
    }
  }

  List<Group> get availableGroupsToJoin {
    // Generate some available groups based on player's genre preferences and fame
    List<Group> availableGroups = [];

    final groupNames = [
      'The Rising Stars',
      'Midnight Collective',
      'Sound Revolution',
      'Urban Legends',
      'Electric Dreams',
      'Harmony Squad',
    ];
    final groupGenres = ['Pop', 'Rock', 'Hip-Hop', 'Electronic', 'R&B', 'Rage'];

    for (int i = 0; i < 3; i++) {
      if (!groups.any((g) => g.name == groupNames[i])) {
        availableGroups.add(
          Group(
            name: groupNames[i],
            genre: groupGenres[i % groupGenres.length],
            formedDate: DateTime.now().subtract(
              Duration(days: Random().nextInt(365)),
            ),
            members: ['Member 1', 'Member 2'],
            leader: 'Member 1',
            fame: Random().nextInt(1000) + 100,
            fanBase: Random().nextInt(5000) + 500,
          ),
        );
      }
    }

    return availableGroups;
  }

  // Persistence methods
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save character data
    await prefs.setString('playerName', playerName);
    await prefs.setString('careerType', careerType);
    await prefs.setString('gender', gender);
    await prefs.setInt('age', age);
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

    // Save songs with detailed information
    List<String> songData = songs.map((song) {
      return '${song.title}|${song.genre}|${song.quality}|${song.isRecorded}|${song.isPublished}|${song.plays}|${song.likes}|${song.revenue}|${song.releaseDate.millisecondsSinceEpoch}|${song.publishDate?.millisecondsSinceEpoch ?? 0}|${song.albumTitle ?? ""}|${song.groupName ?? ""}|${song.isGroupSong}|${song.popularity.streams}|${song.popularity.views}|${song.popularity.dailyGrowth}|${song.popularity.trendingScore}|${song.popularity.peakPosition}|${song.popularity.platforms.join(",")}|${song.coverImagePath ?? ""}';
    }).toList();
    await prefs.setStringList('songData', songData);

    // Save groups
    List<String> groupData = groups.map((group) {
      return '${group.name}|${group.genre}|${group.formedDate.millisecondsSinceEpoch}|${group.members.join(",")}|${group.leader}|${group.fame}|${group.fanBase}|${group.groupRevenue}';
    }).toList();
    await prefs.setStringList('groupData', groupData);

    // Save current group
    await prefs.setString('currentGroupName', currentGroup?.name ?? '');

    // Save albums
    List<String> albumData = albums.map((album) {
      return '${album.title}|${album.genre}|${album.releaseDate.millisecondsSinceEpoch}|${album.isReleased}|${album.totalPlays}|${album.totalRevenue}|${album.collaborators.join(",")}|${album.producedBy ?? ""}|${album.isCollaborativeAlbum}|${album.coverImagePath ?? ""}|${album.hasVinyl}|${album.vinylReleaseDate?.millisecondsSinceEpoch ?? 0}|${album.vinylSales}';
    }).toList();
    await prefs.setStringList('albumData', albumData);

    // Save vinyls
    List<String> vinylData = vinyls.map((vinyl) {
      return '${vinyl.albumTitle}|${vinyl.releaseDate.millisecondsSinceEpoch}|${vinyl.unitsSold}|${vinyl.pricePerUnit}|${vinyl.specialEdition ?? ""}';
    }).toList();
    await prefs.setStringList('vinylData', vinylData);

    // Save concerts
    List<String> concertData = concerts.map((concert) {
      return '${concert.name}|${concert.venue}|${concert.city}|${concert.date.millisecondsSinceEpoch}|${concert.type}|${concert.capacity}|${concert.ticketsSold}|${concert.ticketPrice}|${concert.isCompleted}|${concert.fansGained}|${concert.revenue}';
    }).toList();
    await prefs.setStringList('concertData', concertData);

    // Save tours
    List<String> tourData = tours.map((tour) {
      return '${tour.name}|${tour.startDate.millisecondsSinceEpoch}|${tour.endDate.millisecondsSinceEpoch}|${tour.isActive}|${tour.isCompleted}|${tour.totalRevenue}|${tour.totalFansGained}';
    }).toList();
    await prefs.setStringList('tourData', tourData);

    // Save active tour
    await prefs.setString('activeTourName', activeTour?.name ?? '');

    // Save concert invitations
    List<String> invitationData = concertInvitations.map((concert) {
      return '${concert.name}|${concert.venue}|${concert.city}|${concert.date.millisecondsSinceEpoch}|${concert.type}|${concert.capacity}|${concert.ticketPrice}';
    }).toList();
    await prefs.setStringList('concertInvitations', invitationData);

    // Save relationships
    await prefs.setInt('familyRelationship', familyRelationship);
    await prefs.setInt('friendsRelationship', friendsRelationship);
    await prefs.setBool('hasPartner', hasPartner);
    await prefs.setInt('partnerRelationship', partnerRelationship);

    // Save awards
    List<String> awardJsonList = awards
        .map(
          (award) =>
              '${award.show.toString()}|${award.category.toString()}|${award.year}|${award.week}|${award.description}',
        )
        .toList();
    await prefs.setStringList('awards', awardJsonList);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load character data
    playerName = prefs.getString('playerName') ?? '';
    careerType = prefs.getString('careerType') ?? 'artist';
    gender = prefs.getString('gender') ?? 'male';
    age = prefs.getInt('age') ?? 18;
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
    year = prefs.getInt('year') ?? 2025;
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

    // Load songs
    List<String>? songDataList = prefs.getStringList('songData');
    songs.clear();
    if (songDataList != null) {
      for (String songInfo in songDataList) {
        List<String> parts = songInfo.split('|');
        if (parts.length >= 19) {
          try {
            List<String> platforms = parts[18].isEmpty
                ? ['Independent']
                : parts[18].split(',');
            Song song = Song(
              title: parts[0],
              genre: parts[1],
              quality: int.parse(parts[2]),
              isRecorded: parts[3] == 'true',
              isPublished: parts[4] == 'true',
              plays: int.parse(parts[5]),
              likes: int.parse(parts[6]),
              revenue: double.parse(parts[7]),
              releaseDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(parts[8]),
              ),
              publishDate: parts[9] != '0'
                  ? DateTime.fromMillisecondsSinceEpoch(int.parse(parts[9]))
                  : null,
              albumTitle: parts[10].isEmpty ? null : parts[10],
              groupName: parts[11].isEmpty ? null : parts[11],
              isGroupSong: parts[12] == 'true',
              popularity: SongPopularity(
                streams: int.parse(parts[13]),
                views: int.parse(parts[14]),
                dailyGrowth: int.parse(parts[15]),
                trendingScore: double.parse(parts[16]),
                peakPosition: int.parse(parts[17]),
                platforms: platforms,
              ),
              coverImagePath: parts.length > 19 && parts[19].isNotEmpty
                  ? parts[19]
                  : null,
            );
            songs.add(song);
          } catch (e) {
            // Skip invalid song data
          }
        }
      }
    }

    // Load groups
    List<String>? groupDataList = prefs.getStringList('groupData');
    groups.clear();
    if (groupDataList != null) {
      for (String groupInfo in groupDataList) {
        List<String> parts = groupInfo.split('|');
        if (parts.length >= 8) {
          try {
            Group group = Group(
              name: parts[0],
              genre: parts[1],
              formedDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(parts[2]),
              ),
              members: parts[3].split(','),
              leader: parts[4],
              fame: int.parse(parts[5]),
              fanBase: int.parse(parts[6]),
              groupRevenue: double.parse(parts[7]),
            );
            groups.add(group);
          } catch (e) {
            // Skip invalid group data
          }
        }
      }
    }

    // Load current group
    String currentGroupName = prefs.getString('currentGroupName') ?? '';
    currentGroup = null;
    if (currentGroupName.isNotEmpty) {
      try {
        currentGroup = groups.firstWhere((g) => g.name == currentGroupName);
      } catch (e) {
        currentGroup = null;
      }
    }

    // Load albums
    List<String>? albumDataList = prefs.getStringList('albumData');
    albums.clear();
    if (albumDataList != null) {
      for (String albumInfo in albumDataList) {
        List<String> parts = albumInfo.split('|');
        if (parts.length >= 9) {
          try {
            Album album = Album(
              title: parts[0],
              genre: parts[1],
              releaseDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(parts[2]),
              ),
              isReleased: parts[3] == 'true',
              totalPlays: int.parse(parts[4]),
              totalRevenue: double.parse(parts[5]),
              collaborators: parts[6]
                  .split(',')
                  .where((s) => s.isNotEmpty)
                  .toList(),
              producedBy: parts[7].isEmpty ? null : parts[7],
              isCollaborativeAlbum: parts[8] == 'true',
              coverImagePath: parts.length > 9 && parts[9].isNotEmpty
                  ? parts[9]
                  : null,
              hasVinyl: parts.length > 10 ? parts[10] == 'true' : false,
              vinylReleaseDate: parts.length > 11 && parts[11] != '0'
                  ? DateTime.fromMillisecondsSinceEpoch(int.parse(parts[11]))
                  : null,
              vinylSales: parts.length > 12 ? int.parse(parts[12]) : 0,
            );
            albums.add(album);
          } catch (e) {
            // Skip invalid album data
          }
        }
      }
    }

    // Load vinyls
    List<String>? vinylDataList = prefs.getStringList('vinylData');
    vinyls.clear();
    if (vinylDataList != null) {
      for (String vinylInfo in vinylDataList) {
        List<String> parts = vinylInfo.split('|');
        if (parts.length >= 5) {
          try {
            Vinyl vinyl = Vinyl(
              albumTitle: parts[0],
              releaseDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(parts[1]),
              ),
              unitsSold: int.parse(parts[2]),
              pricePerUnit: double.parse(parts[3]),
              specialEdition: parts[4].isEmpty ? null : parts[4],
            );
            vinyls.add(vinyl);
          } catch (e) {
            // Skip invalid vinyl data
          }
        }
      }
    }

    // Load concerts
    List<String>? concertDataList = prefs.getStringList('concertData');
    concerts.clear();
    if (concertDataList != null) {
      for (String concertInfo in concertDataList) {
        List<String> parts = concertInfo.split('|');
        if (parts.length >= 11) {
          try {
            Concert concert = Concert(
              name: parts[0],
              venue: parts[1],
              city: parts[2],
              date: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[3])),
              type: parts[4],
              capacity: int.parse(parts[5]),
              ticketsSold: int.parse(parts[6]),
              ticketPrice: double.parse(parts[7]),
              isCompleted: parts[8] == 'true',
              fansGained: int.parse(parts[9]),
              revenue: double.parse(parts[10]),
            );
            concerts.add(concert);
          } catch (e) {
            // Skip invalid concert data
          }
        }
      }
    }

    // Load tours
    List<String>? tourDataList = prefs.getStringList('tourData');
    tours.clear();
    if (tourDataList != null) {
      for (String tourInfo in tourDataList) {
        List<String> parts = tourInfo.split('|');
        if (parts.length >= 7) {
          try {
            Tour tour = Tour(
              name: parts[0],
              startDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(parts[1]),
              ),
              endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[2])),
              isActive: parts[3] == 'true',
              isCompleted: parts[4] == 'true',
              totalRevenue: double.parse(parts[5]),
              totalFansGained: int.parse(parts[6]),
            );
            tours.add(tour);
          } catch (e) {
            // Skip invalid tour data
          }
        }
      }
    }

    // Load active tour
    String activeTourName = prefs.getString('activeTourName') ?? '';
    activeTour = null;
    if (activeTourName.isNotEmpty) {
      try {
        activeTour = tours.firstWhere((t) => t.name == activeTourName);
      } catch (e) {
        activeTour = null;
      }
    }

    // Load concert invitations
    List<String>? invitationDataList = prefs.getStringList(
      'concertInvitations',
    );
    concertInvitations.clear();
    if (invitationDataList != null) {
      for (String invitationInfo in invitationDataList) {
        List<String> parts = invitationInfo.split('|');
        if (parts.length >= 7) {
          try {
            Concert invitation = Concert(
              name: parts[0],
              venue: parts[1],
              city: parts[2],
              date: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[3])),
              type: parts[4],
              capacity: int.parse(parts[5]),
              ticketPrice: double.parse(parts[6]),
            );
            concertInvitations.add(invitation);
          } catch (e) {
            // Skip invalid invitation data
          }
        }
      }
    }

    // Load awards
    List<String>? awardJsonList = prefs.getStringList('awards');
    awards.clear();
    if (awardJsonList != null) {
      for (String awardData in awardJsonList) {
        List<String> parts = awardData.split('|');
        if (parts.length >= 5) {
          try {
            Award award = Award(
              show: AwardShow.values.firstWhere(
                (e) => e.toString() == parts[0],
              ),
              category: AwardCategory.values.firstWhere(
                (e) => e.toString() == parts[1],
              ),
              year: int.parse(parts[2]),
              week: int.parse(parts[3]),
              description: parts[4],
            );
            awards.add(award);
          } catch (e) {
            // Skip invalid award data
          }
        }
      }
    }

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
    year = 2025;
    age = 18;
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
    groups.clear();
    currentGroup = null;
    contacts.clear();
    awards.clear();

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
