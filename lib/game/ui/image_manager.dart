import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageManager {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  static Future<String?> pickImage({
    bool fromCamera = false,
    required String type, // 'song' or 'album'
    required String name, // song title or album title
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImage(image, type, name);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  /// Save the picked image to app documents directory
  static Future<String?> _saveImage(
    XFile image,
    String type,
    String name,
  ) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String coversDir = path.join(appDir.path, 'covers', type);

      // Create covers directory if it doesn't exist
      await Directory(coversDir).create(recursive: true);

      // Clean filename for filesystem
      final String cleanName = _cleanFileName(name);
      final String extension = path.extension(image.path);
      final String fileName =
          '${cleanName}_${DateTime.now().millisecondsSinceEpoch}$extension';
      final String filePath = path.join(coversDir, fileName);

      // Copy image to app directory
      await File(image.path).copy(filePath);

      return filePath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  /// Get image widget for display
  static Widget getImageWidget(
    String? imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? defaultWidget,
  }) {
    if (imagePath != null && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return defaultWidget ?? _getDefaultCoverWidget(width, height);
        },
      );
    }
    return defaultWidget ?? _getDefaultCoverWidget(width, height);
  }

  /// Default cover widget when no image is available
  static Widget _getDefaultCoverWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.music_note, color: Colors.white, size: 40),
    );
  }

  /// Clean filename for filesystem compatibility
  static String _cleanFileName(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(' ', '_')
        .toLowerCase();
  }

  /// Delete image file
  static Future<bool> deleteImage(String? imagePath) async {
    if (imagePath != null && File(imagePath).existsSync()) {
      try {
        await File(imagePath).delete();
        return true;
      } catch (e) {
        debugPrint('Error deleting image: $e');
      }
    }
    return false;
  }

  /// Show image picker dialog
  static Future<String?> showImagePickerDialog(
    BuildContext context, {
    required String type,
    required String name,
  }) async {
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1625),
        title: const Text(
          'Add Cover Image',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose how to add a cover image for your $type:',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final imagePath = await pickImage(
                        fromCamera: false,
                        type: type,
                        name: name,
                      );
                      Navigator.pop(context, imagePath);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final imagePath = await pickImage(
                        fromCamera: true,
                        type: type,
                        name: name,
                      );
                      Navigator.pop(context, imagePath);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
