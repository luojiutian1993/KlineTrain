import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color.fromARGB(255, 247, 245, 243);
  static const Color surface = Color.fromARGB(255, 252, 251, 250);
  static const Color fg = Color.fromARGB(255, 51, 49, 47);
  static const Color muted = Color.fromARGB(255, 122, 118, 114);
  static const Color border = Color.fromARGB(255, 227, 224, 220);
  static const Color accent = Color.fromARGB(255, 150, 90, 55);
  static const Color accentSoft = Color.fromARGB(38, 150, 90, 55);
  static const Color green = Color.fromARGB(255, 60, 150, 80);
  static const Color red = Color.fromARGB(255, 180, 60, 50);
  static const Color primary = Color.fromARGB(255, 66, 133, 244);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: accent,
      primaryColorLight: accentSoft,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: fg, fontSize: 16),
        bodyMedium: TextStyle(color: fg, fontSize: 14),
        bodySmall: TextStyle(color: muted, fontSize: 12),
        titleLarge: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: fg, fontSize: 14),
      ),
      iconTheme: IconThemeData(color: fg),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: fg,
        elevation: 0,
        titleTextStyle: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: false,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 0.5),
      chipTheme: ChipThemeData(
        backgroundColor: bg,
        selectedColor: accent,
        labelStyle: TextStyle(color: fg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: accent,
      primaryColorLight: accentSoft,
      scaffoldBackgroundColor: const Color.fromARGB(255, 30, 29, 28),
      cardColor: const Color.fromARGB(255, 42, 41, 40),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 16),
        bodyMedium: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 14),
        bodySmall: TextStyle(color: muted, fontSize: 12),
        titleLarge: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 16, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 14),
      ),
      iconTheme: IconThemeData(color: const Color.fromARGB(255, 240, 238, 236)),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(255, 42, 41, 40),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 42, 41, 40),
        selectedItemColor: accent,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 42, 41, 40),
        foregroundColor: const Color.fromARGB(255, 240, 238, 236),
        elevation: 0,
        titleTextStyle: TextStyle(color: const Color.fromARGB(255, 240, 238, 236), fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: false,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 0.5),
      chipTheme: ChipThemeData(
        backgroundColor: const Color.fromARGB(255, 42, 41, 40),
        selectedColor: accent,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 240, 238, 236)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}