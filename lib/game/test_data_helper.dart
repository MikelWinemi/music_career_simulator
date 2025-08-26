import 'player_model.dart';

class TestDataHelper {
  static void setupTestData(PlayerModel player) {
    // Add some test songs and albums for vinyl production testing
    if (player.songs.isEmpty) {
      final song1 = Song(
        title: 'Test Hit 1',
        genre: 'Pop',
        quality: 85,
        releaseDate: DateTime.now().subtract(const Duration(days: 30)),
        isRecorded: true,
        isPublished: true,
      );
      song1.coverImagePath = null; // Will use default
      song1.plays = 50000;
      song1.revenue = 500.0;

      final song2 = Song(
        title: 'Test Hit 2',
        genre: 'Rock',
        quality: 80,
        releaseDate: DateTime.now().subtract(const Duration(days: 20)),
        isRecorded: true,
        isPublished: true,
      );
      song2.coverImagePath = null;
      song2.plays = 45000;
      song2.revenue = 450.0;

      final song3 = Song(
        title: 'Test Hit 3',
        genre: 'Electronic',
        quality: 78,
        releaseDate: DateTime.now().subtract(const Duration(days: 10)),
        isRecorded: true,
        isPublished: true,
      );
      song3.coverImagePath = null;
      song3.plays = 40000;
      song3.revenue = 400.0;

      player.songs.addAll([song1, song2, song3]);
    }

    // Add test albums for vinyl production
    if (player.albums.isEmpty) {
      final album1 = Album(
        title: 'Test Album 1',
        genre: 'Pop',
        releaseDate: DateTime.now().subtract(const Duration(days: 25)),
        isReleased: true,
      );
      album1.coverImagePath = null;
      album1.songs.addAll([player.songs[0], player.songs[1]]);
      album1.updateStats(); // This will set the plays and revenue

      final album2 = Album(
        title: 'Test Album 2',
        genre: 'Rock',
        releaseDate: DateTime.now().subtract(const Duration(days: 15)),
        isReleased: true,
      );
      album2.coverImagePath = null;
      album2.songs.add(player.songs[2]);
      album2.updateStats();

      player.albums.addAll([album1, album2]);
    }

    // Add some basic stats for testing touring
    if (player.fame < 100) {
      player.fame = 150; // Enough for touring
      player.fans = 2000; // Enough for tours
      player.money = 10000; // Enough for vinyl production and tours
    }

    // Generate some initial concert invitations for testing
    player.generateConcertInvitations();
  }
}
