import 'dart:math';
import 'player_model.dart';

// Award categories for major award shows
enum AwardCategory {
  // Grammy Awards - Music categories
  recordOfTheYear,
  albumOfTheYear,
  songOfTheYear,
  bestNewArtist,
  bestPopVocalAlbum,
  bestPopSolo,
  bestPopDuo,
  bestRapPerformance,
  bestRapAlbum,
  bestRockPerformance,
  bestRockAlbum,
  bestAlternativeAlbum,
  bestRBPerformance,
  bestRBAlbum,
  bestCountryAlbum,
  bestCountrySong,
  bestCountryDuo,
  bestElectronicAlbum,
  bestDanceRecording,
  bestJazzVocalAlbum,
  bestJazzInstrumentalAlbum,
  bestBluesAlbum,
  bestFolkAlbum,
  bestAmericanaAlbum,
  bestReggaeAlbum,
  bestWorldMusicAlbum,
  bestLatinPopAlbum,
  bestLatinRockAlbum,
  bestClassicalAlbum,
  bestOperaRecording,
  bestChamberMusicPerformance,
  bestInstrumentalComposition,
  bestMusicVideo,
  bestMusicFilm,
  bestAlbumNotes,
  bestHistoricalAlbum,
  bestEngineeredAlbum,
  bestProducerOfTheYear,
  bestRemixedRecording,
  bestImmersiveAudioAlbum,

  // Producer-specific awards
  bestHipHopProducer,
  bestPopProducer,
  bestRockProducer,
  bestRBProducer,
  bestCountryProducer,
  bestElectronicProducer,
  bestJazzProducer,
  bestAlternativeProducer,
  bestCollaborativeProducer,
  producerOfTheYear,
  bestProducedAlbum,
  bestProducedSong,

  // AMA Awards - Performance categories
  artistOfTheYear,
  newArtistOfTheYear,
  collaborationOfTheYear,
  tourOfTheYear,
  videoOfTheYear,
  songOfTheYearAMA,
  albumOfTheYearAMA,
  favoritePopArtist,
  favoriteRockArtist,
  favoriteCountryArtist,
  favoriteRapArtist,
  favoriteRBArtist,
  favoriteDanceArtist,
  favoriteLatinArtist,
  favoriteChristianArtist,
  favoriteGospelArtist,
  favoriteJazzArtist,
  favoriteBluesArtist,
  favoriteIndie,
  favoriteElectronic,
  favoriteReggae,
  favoriteWorldMusic,
  favoriteClassical,
  socialArtistOfTheYear,
  trendingArtist,
}

// Award shows
enum AwardShow { grammys, ama }

// Individual award won by player
class Award {
  final AwardShow show;
  final AwardCategory category;
  final int year;
  final int week;
  final String description;

  Award({
    required this.show,
    required this.category,
    required this.year,
    required this.week,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'show': show.toString(),
      'category': category.toString(),
      'year': year,
      'week': week,
      'description': description,
    };
  }

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      show: AwardShow.values.firstWhere((e) => e.toString() == json['show']),
      category: AwardCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      year: json['year'],
      week: json['week'],
      description: json['description'],
    );
  }
}

// Award nomination (player might not win)
class Nomination {
  final AwardShow show;
  final AwardCategory category;
  final int year;
  final bool won;

  Nomination({
    required this.show,
    required this.category,
    required this.year,
    required this.won,
  });
}

class AwardSystem {
  static final Random _random = Random();

  // Get all categories for a specific genre/style
  static List<AwardCategory> getCategoriesForStyle(
    String musicStyle, {
    String careerType = "artist",
  }) {
    if (careerType == "producer") {
      return getProducerCategoriesForStyle(musicStyle);
    }

    switch (musicStyle.toLowerCase()) {
      case 'pop':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestPopVocalAlbum,
          AwardCategory.bestPopSolo,
          AwardCategory.bestPopDuo,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoritePopArtist,
          AwardCategory.collaborationOfTheYear,
        ];
      case 'rap':
      case 'hip hop':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestRapPerformance,
          AwardCategory.bestRapAlbum,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteRapArtist,
          AwardCategory.trendingArtist,
        ];
      case 'rock':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestRockPerformance,
          AwardCategory.bestRockAlbum,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteRockArtist,
        ];
      case 'country':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestCountryAlbum,
          AwardCategory.bestCountrySong,
          AwardCategory.bestCountryDuo,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteCountryArtist,
        ];
      case 'r&b':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestRBPerformance,
          AwardCategory.bestRBAlbum,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteRBArtist,
        ];
      case 'electronic':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestElectronicAlbum,
          AwardCategory.bestDanceRecording,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteDanceArtist,
          AwardCategory.favoriteElectronic,
        ];
      case 'jazz':
        return [
          AwardCategory.bestNewArtist,
          AwardCategory.bestJazzVocalAlbum,
          AwardCategory.bestJazzInstrumentalAlbum,
          AwardCategory.favoriteJazzArtist,
        ];
      case 'alternative':
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.bestAlternativeAlbum,
          AwardCategory.artistOfTheYear,
          AwardCategory.favoriteIndie,
        ];
      default:
        return [
          AwardCategory.recordOfTheYear,
          AwardCategory.albumOfTheYear,
          AwardCategory.songOfTheYear,
          AwardCategory.bestNewArtist,
          AwardCategory.artistOfTheYear,
        ];
    }
  }

  // Get producer-specific categories for a genre/style
  static List<AwardCategory> getProducerCategoriesForStyle(String musicStyle) {
    List<AwardCategory> baseProducerCategories = [
      AwardCategory.bestProducerOfTheYear,
      AwardCategory.producerOfTheYear,
      AwardCategory.bestProducedAlbum,
      AwardCategory.bestProducedSong,
      AwardCategory.bestCollaborativeProducer,
    ];

    switch (musicStyle.toLowerCase()) {
      case 'pop':
        return [...baseProducerCategories, AwardCategory.bestPopProducer];
      case 'rap':
      case 'hip hop':
        return [...baseProducerCategories, AwardCategory.bestHipHopProducer];
      case 'rock':
        return [...baseProducerCategories, AwardCategory.bestRockProducer];
      case 'country':
        return [...baseProducerCategories, AwardCategory.bestCountryProducer];
      case 'r&b':
        return [...baseProducerCategories, AwardCategory.bestRBProducer];
      case 'electronic':
        return [
          ...baseProducerCategories,
          AwardCategory.bestElectronicProducer,
        ];
      case 'jazz':
        return [...baseProducerCategories, AwardCategory.bestJazzProducer];
      case 'alternative':
        return [
          ...baseProducerCategories,
          AwardCategory.bestAlternativeProducer,
        ];
      default:
        return baseProducerCategories;
    }
  }

  // Calculate player's eligibility and chances for each category
  static Map<AwardCategory, double> calculateEligibility(PlayerModel player) {
    Map<AwardCategory, double> eligibility = {};

    // Base eligibility factors
    double fameScore = player.fame / 100.0;
    double albumScore = (player.albumsSold / 10000.0).clamp(0.0, 1.0);
    double songScore = (player.songs.length / 20.0).clamp(0.0, 1.0);
    double concertScore = (player.concertsPerformed / 50.0).clamp(0.0, 1.0);
    double socialScore = (player.socialMediaFollowers / 100000.0).clamp(
      0.0,
      1.0,
    );

    // Calculate scores for relevant categories based on player's music style
    List<AwardCategory> relevantCategories = getCategoriesForStyle(
      player.avatarStyle,
      careerType: player.careerType,
    );

    for (AwardCategory category in relevantCategories) {
      double chance = 0.0;

      switch (category) {
        case AwardCategory.recordOfTheYear:
        case AwardCategory.albumOfTheYear:
        case AwardCategory.songOfTheYear:
          chance = (fameScore * 0.4 + albumScore * 0.3 + songScore * 0.3);
          break;

        case AwardCategory.bestNewArtist:
          // Only eligible in first 2 years
          if (player.year <= 2025) {
            chance = (fameScore * 0.5 + songScore * 0.3 + socialScore * 0.2);
          }
          break;

        case AwardCategory.artistOfTheYear:
          chance =
              (fameScore * 0.5 +
              albumScore * 0.2 +
              concertScore * 0.2 +
              socialScore * 0.1);
          break;

        case AwardCategory.tourOfTheYear:
          chance = concertScore;
          break;

        case AwardCategory.socialArtistOfTheYear:
          chance = socialScore;
          break;

        case AwardCategory.collaborationOfTheYear:
          // Check if player has collaborations (songs with "feat." or collaborative albums)
          int songCollaborations = player.songs
              .where((song) => song.title.toLowerCase().contains('feat.'))
              .length;
          int albumCollaborations = player.albums
              .where((album) => album.isCollaborativeAlbum)
              .length;
          int totalCollaborations = songCollaborations + albumCollaborations;
          chance = (totalCollaborations / 3.0).clamp(0.0, 1.0) * fameScore;
          break;

        // Producer-specific awards
        case AwardCategory.bestProducerOfTheYear:
        case AwardCategory.producerOfTheYear:
          if (player.careerType == "producer") {
            chance = (fameScore * 0.5 + albumScore * 0.3 + songScore * 0.2);
          }
          break;

        case AwardCategory.bestProducedAlbum:
          if (player.careerType == "producer") {
            chance = (albumScore * 0.6 + fameScore * 0.4);
          }
          break;

        case AwardCategory.bestProducedSong:
          if (player.careerType == "producer") {
            chance = (songScore * 0.6 + fameScore * 0.4);
          }
          break;

        case AwardCategory.bestHipHopProducer:
        case AwardCategory.bestPopProducer:
        case AwardCategory.bestRockProducer:
        case AwardCategory.bestRBProducer:
        case AwardCategory.bestCountryProducer:
        case AwardCategory.bestElectronicProducer:
        case AwardCategory.bestJazzProducer:
        case AwardCategory.bestAlternativeProducer:
        case AwardCategory.bestCollaborativeProducer:
          if (player.careerType == "producer") {
            double baseChance =
                (fameScore * 0.6 + albumScore * 0.2 + songScore * 0.2);

            // Bonus for collaborative albums for bestCollaborativeProducer
            if (category == AwardCategory.bestCollaborativeProducer) {
              int collaborativeAlbums = player.albums
                  .where((album) => album.isCollaborativeAlbum)
                  .length;
              baseChance *= (1.0 + collaborativeAlbums * 0.2);
            }

            chance = baseChance;
          }
          break;

        default:
          // Genre-specific awards
          chance = (fameScore * 0.6 + albumScore * 0.2 + songScore * 0.2);
          break;
      }

      // Add some randomness and scale based on career level
      chance *=
          (0.5 + _random.nextDouble() * 0.5); // 50-100% of calculated chance

      // Higher chances for more successful players
      if (player.fame > 80) chance *= 1.5;
      if (player.albumsSold > 50000) chance *= 1.3;
      if (player.concertsPerformed > 100) chance *= 1.2;

      // Cap at reasonable maximum
      chance = chance.clamp(0.0, 0.8); // Max 80% chance

      if (chance > 0.1) {
        // Only include if decent chance
        eligibility[category] = chance;
      }
    }

    return eligibility;
  }

  // Generate nominations and awards for the year
  static List<Nomination> generateAwardShow(
    PlayerModel player,
    AwardShow show,
  ) {
    List<Nomination> nominations = [];
    Map<AwardCategory, double> eligibility = calculateEligibility(player);

    for (var entry in eligibility.entries) {
      AwardCategory category = entry.key;
      double chance = entry.value;

      // Check if nominated (higher threshold for nomination)
      if (_random.nextDouble() < chance * 0.8) {
        // Check if won (lower chance)
        bool won = _random.nextDouble() < chance;

        nominations.add(
          Nomination(
            show: show,
            category: category,
            year: player.year,
            won: won,
          ),
        );

        // If won, add to player's awards
        if (won) {
          Award award = Award(
            show: show,
            category: category,
            year: player.year,
            week: player.week,
            description: _getAwardDescription(show, category),
          );
          player.awards.add(award);
        }
      }
    }

    return nominations;
  }

  // Get description for award
  static String _getAwardDescription(AwardShow show, AwardCategory category) {
    String showName = show == AwardShow.grammys
        ? "Grammy Awards"
        : "American Music Awards";
    String categoryName = getCategoryDisplayName(category);
    return "$showName - $categoryName";
  }

  // Convert category enum to display name
  static String getCategoryDisplayName(AwardCategory category) {
    switch (category) {
      case AwardCategory.recordOfTheYear:
        return "Record of the Year";
      case AwardCategory.albumOfTheYear:
        return "Album of the Year";
      case AwardCategory.songOfTheYear:
        return "Song of the Year";
      case AwardCategory.bestNewArtist:
        return "Best New Artist";
      case AwardCategory.bestPopVocalAlbum:
        return "Best Pop Vocal Album";
      case AwardCategory.bestPopSolo:
        return "Best Pop Solo Performance";
      case AwardCategory.bestPopDuo:
        return "Best Pop Duo/Group Performance";
      case AwardCategory.bestRapPerformance:
        return "Best Rap Performance";
      case AwardCategory.bestRapAlbum:
        return "Best Rap Album";
      case AwardCategory.bestRockPerformance:
        return "Best Rock Performance";
      case AwardCategory.bestRockAlbum:
        return "Best Rock Album";
      case AwardCategory.bestAlternativeAlbum:
        return "Best Alternative Music Album";
      case AwardCategory.bestRBPerformance:
        return "Best R&B Performance";
      case AwardCategory.bestRBAlbum:
        return "Best R&B Album";
      case AwardCategory.bestCountryAlbum:
        return "Best Country Album";
      case AwardCategory.bestCountrySong:
        return "Best Country Song";
      case AwardCategory.bestCountryDuo:
        return "Best Country Duo/Group Performance";
      case AwardCategory.bestElectronicAlbum:
        return "Best Electronic/Dance Album";
      case AwardCategory.bestDanceRecording:
        return "Best Dance/Electronic Recording";
      case AwardCategory.artistOfTheYear:
        return "Artist of the Year";
      case AwardCategory.newArtistOfTheYear:
        return "New Artist of the Year";
      case AwardCategory.collaborationOfTheYear:
        return "Collaboration of the Year";
      case AwardCategory.tourOfTheYear:
        return "Tour of the Year";
      case AwardCategory.videoOfTheYear:
        return "Video of the Year";
      case AwardCategory.favoritePopArtist:
        return "Favorite Pop Artist";
      case AwardCategory.favoriteRockArtist:
        return "Favorite Rock Artist";
      case AwardCategory.favoriteCountryArtist:
        return "Favorite Country Artist";
      case AwardCategory.favoriteRapArtist:
        return "Favorite Rap Artist";
      case AwardCategory.favoriteRBArtist:
        return "Favorite R&B Artist";
      case AwardCategory.socialArtistOfTheYear:
        return "Social Artist of the Year";
      case AwardCategory.trendingArtist:
        return "Trending Artist";
      case AwardCategory.bestProducerOfTheYear:
        return "Best Producer of the Year";
      case AwardCategory.bestHipHopProducer:
        return "Best Hip-Hop Producer";
      case AwardCategory.bestPopProducer:
        return "Best Pop Producer";
      case AwardCategory.bestRockProducer:
        return "Best Rock Producer";
      case AwardCategory.bestRBProducer:
        return "Best R&B Producer";
      case AwardCategory.bestCountryProducer:
        return "Best Country Producer";
      case AwardCategory.bestElectronicProducer:
        return "Best Electronic Producer";
      case AwardCategory.bestJazzProducer:
        return "Best Jazz Producer";
      case AwardCategory.bestAlternativeProducer:
        return "Best Alternative Producer";
      case AwardCategory.bestCollaborativeProducer:
        return "Best Collaborative Producer";
      case AwardCategory.producerOfTheYear:
        return "Producer of the Year";
      case AwardCategory.bestProducedAlbum:
        return "Best Produced Album";
      case AwardCategory.bestProducedSong:
        return "Best Produced Song";
      default:
        return category
            .toString()
            .replaceAll('AwardCategory.', '')
            .replaceAll(RegExp(r'([A-Z])'), ' \$1')
            .trim();
    }
  }

  // Check if it's award season (week 52 = end of year)
  static bool isAwardSeason(int week) {
    return week == 52;
  }

  // Run award shows for the year
  static Map<AwardShow, List<Nomination>> runAwardShows(PlayerModel player) {
    Map<AwardShow, List<Nomination>> results = {};

    if (isAwardSeason(player.week)) {
      // Run Grammy Awards
      results[AwardShow.grammys] = generateAwardShow(player, AwardShow.grammys);

      // Run AMA Awards
      results[AwardShow.ama] = generateAwardShow(player, AwardShow.ama);
    }

    return results;
  }
}
