import 'package:flutter/material.dart';
import 'dart:math';

class Trait {
  final String name;
  final Color color;
  int level;
  double progress;
  int energyCost;

  Trait({
    required this.name,
    required this.color,
    this.level = 1,
    this.progress = 0.0,
    this.energyCost = 2,
  });

  bool canUpgrade(int currentEnergy) {
    return currentEnergy >= energyCost && progress >= 1.0;
  }

  void upgrade() {
    if (progress >= 1.0) {
      level++;
      progress = 0.0;
    }
  }

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

  Song({
    required this.title,
    required this.genre,
    required this.quality,
    this.isRecorded = false,
    this.plays = 0,
    this.likes = 0,
    this.revenue = 0.0,
    required this.releaseDate,
  });
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

  // Social media
  int socialMediaFollowers = 0;
  int socialMediaEngagement = 0;

  // Songs and deals
  List<Song> songs = [];
  RecordDeal? currentDeal;

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
  }

  void _initializeTraits() {
    vocals = Trait(
      name: 'VOCALS',
      color: const Color(0xFF9C27B0),
      energyCost: 2,
    );
    songWriting = Trait(
      name: 'SONGWRITING',
      color: const Color(0xFF673AB7),
      energyCost: 2,
    );
    rhythm = Trait(
      name: 'RHYTHM',
      color: const Color(0xFF2196F3),
      energyCost: 2,
    );
    charisma = Trait(
      name: 'CHARISMA',
      color: const Color(0xFFFF9800),
      energyCost: 2,
    );
    virality = Trait(
      name: 'VIRALITY',
      color: const Color(0xFFFFC107),
      energyCost: 4,
    );
    videoDirecting = Trait(
      name: 'DIRECTING',
      color: const Color(0xFF9C27B0),
      energyCost: 2,
    );

    leadership = Trait(
      name: 'LEADERSHIP',
      color: const Color(0xFFFFB74D),
      level: 2,
      energyCost: 2,
    );
    marketing = Trait(
      name: 'MARKETING',
      color: const Color(0xFFFF7043),
      level: 2,
      energyCost: 2,
    );
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

      eventMessage = 'Concert was a success! Earned \$${earnings}';
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

  void socialMediaPost() {
    if (energy >= 5) {
      energy -= 5;

      socialMediaFollowers += Random().nextInt(100) + 10;
      socialMediaEngagement += Random().nextInt(50) + 5;
      fans += Random().nextInt(10) + 1;

      virality.addProgress(0.2);
      marketing.addProgress(0.1);

      eventMessage =
          'Posted on social media! +${socialMediaFollowers} followers';
      notifyListeners();
    }
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

  void endWeek() {
    week++;
    if (week > 52) {
      week = 1;
      year++;
    }
    energy = maxEnergy;

    // Weekly income from various sources
    int weeklyIncome = 0;

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

    eventMessage = 'New week! Earned \$${weeklyIncome} from various sources';
    notifyListeners();
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
}
