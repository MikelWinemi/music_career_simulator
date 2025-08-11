import 'package:flutter/material.dart';

class AppTheme {
  // Unique color palette inspired by music industry
  static const Color primaryPurple = Color(0xFF6B46C1); // Deep purple
  static const Color accentGold = Color(0xFFFFD700); // Gold
  static const Color backgroundDark = Color(0xFF0F0A1A); // Very dark purple
  static const Color cardBackground = Color(0xFF1A1625); // Dark purple-grey
  static const Color secondaryCard = Color(0xFF2D1B69); // Medium purple
  static const Color energyRed = Color(0xFFFF5757); // Bright red
  static const Color successGreen = Color(0xFF10B981); // Emerald green
  static const Color warningOrange = Color(0xFFFF8C00); // Dark orange
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB794F6); // Light purple
  static const Color textMuted = Color(0xFF9CA3AF); // Grey

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1625), Color(0xFF2D1B69)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F0A1A), Color(0xFF1A1625)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryPurple,
    foregroundColor: textPrimary,
    elevation: 8,
    shadowColor: primaryPurple.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  static ButtonStyle goldButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentGold,
    foregroundColor: Colors.black,
    elevation: 8,
    shadowColor: accentGold.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: primaryPurple.withOpacity(0.3), width: 1),
    boxShadow: [
      BoxShadow(
        color: primaryPurple.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );

  // Progress bar decoration
  static BoxDecoration progressBarBackground = BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration progressBarForeground(Color color) => BoxDecoration(
    gradient: LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Text styles
  static const TextStyle titleLarge = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    color: textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle accentText = TextStyle(
    color: accentGold,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
}
