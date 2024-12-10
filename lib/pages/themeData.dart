import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { Dark, Light, Pink }

class MyThemeColors {
  String contacts;
  String appointments;
  String bluetooth;
  String pharmacies;
  String pill2;
  Color primary;
  Color accent;
  Color background;
  Color button;
  Color card;
  Color card2;
  Color bodyText1;
  Color bodyText2;
  Color bodyText3;
  Color iconColor;
  Color iconColor2;
  Color naviconcolor;
  Color navbar;
  Color calanderColor1;
  Color sidebar;
  Color calanderColornotselected;
  Color calanderColorselected;

  MyThemeColors(
      {required this.appointments,
      required this.bluetooth,
      required this.contacts,
      required this.pharmacies,
      required this.pill2,
      required this.primary,
      required this.accent,
      required this.background,
      required this.button,
      required this.card,
      required this.card2,
      required this.bodyText1,
      required this.bodyText2,
      required this.bodyText3,
      required this.iconColor,
      required this.iconColor2,
      required this.naviconcolor,
      required this.navbar,
      required this.calanderColor1,
      required this.sidebar,
      required this.calanderColorselected,
      required this.calanderColornotselected});
}

MyThemeColors lightColors = MyThemeColors(
  pill2: 'lib/pages/pics/pill2blue.png',
  contacts: 'lib/pages/pics/Contactsblue.jpg',
  appointments: 'lib/pages/pics/appointmentsblue.jpg',
  bluetooth: 'lib/pages/pics/bluetoothblue.jpg',
  pharmacies: 'lib/pages/pics/pharmaciesblue.jpg',
  primary: const Color(0xFFFFD700), // Gold primary color
  accent: const Color(0xFFFFFFE0), // Light yellow accent
  background:
      const Color.fromARGB(255, 255, 250, 205), // Lemon Chiffon background
  button: const Color(0xFFFFD700), // Gold button color
  card: const Color(0xFFF0E68C), // Khaki card background
  card2: const Color.fromARGB(
      255, 250, 250, 210), // Light goldenrod yellow for secondary card
  bodyText1: const Color.fromARGB(255, 85, 85, 85), // Dark grey text
  bodyText2:
      const Color.fromARGB(255, 105, 105, 105), // Darker grey for bodyText2
  iconColor2: Colors.black, // Black icons for better visibility
  bodyText3: const Color.fromARGB(255, 80, 80, 80), // Slightly darker grey text
  iconColor: const Color(0xFFFFD700), // Matching gold for icon color
  naviconcolor: Colors.black, // Black nav icon color
  navbar: const Color(0xFFFFD700), // Gold navbar
  sidebar: const Color(0xFFF0E68C), // Khaki sidebar
  calanderColor1: const Color(0xFFFFD700), // Gold for calendar selection
  calanderColorselected:
      const Color.fromARGB(255, 255, 255, 255), // White for selected
  calanderColornotselected:
      const Color.fromARGB(255, 85, 85, 85), // Dark grey for non-selected
);

MyThemeColors pinkColors = MyThemeColors(
  pill2: 'lib/pages/pics/pill2purple.jpg',
  contacts: 'lib/pages/pics/Contactspurple.jpg',
  appointments: 'lib/pages/pics/appointmentspurple.jpg',
  bluetooth: 'lib/pages/pics/bluetoothpurple.jpg',
  pharmacies: 'lib/pages/pics/pharmaciespurple.jpg',
  primary: const Color(0xFF4CAF50), // Green primary color
  accent: const Color(0xFFC8E6C9), // Light green accent
  background:
      const Color.fromARGB(255, 232, 245, 233), // Light green background
  button: const Color(0xFF4CAF50), // Green button color
  card: const Color.fromARGB(255, 200, 230, 201), // Light green card
  card2:
      const Color.fromARGB(255, 165, 214, 167), // Darker green secondary card
  bodyText1: const Color.fromARGB(255, 33, 33, 33), // Dark text for contrast
  bodyText2: const Color.fromARGB(255, 60, 60, 60), // Slightly lighter grey
  bodyText3: const Color.fromARGB(255, 50, 50, 50), // Darker text
  iconColor: const Color(0xFF4CAF50), // Matching green for icons
  iconColor2: const Color.fromARGB(255, 50, 50, 50), // Slightly darker icons
  naviconcolor: const Color.fromARGB(255, 33, 33, 33), // Darker nav icon color
  navbar: const Color(0xFF388E3C), // Darker green for navbar
  sidebar: const Color(0xFF2E7D32), // Darker green sidebar
  calanderColor1: const Color(0xFF4CAF50), // Green for calendar
  calanderColorselected:
      const Color.fromARGB(255, 255, 255, 255), // White for selected
  calanderColornotselected:
      const Color.fromARGB(255, 85, 85, 85), // Dark grey for non-selected
);

MyThemeColors darkColors = MyThemeColors(
  pill2: 'lib/pages/pics/pill2black.jpg',
  contacts: 'lib/pages/pics/Contactsblack.jpg',
  appointments: 'lib/pages/pics/appointmentsblack.jpg',
  bluetooth: 'lib/pages/pics/bluetoothblack.jpg',
  pharmacies: 'lib/pages/pics/pharmaciesblack.jpg',
  primary: const Color(0xFF616161), // Dark gray primary color
  accent: const Color(0xFF9E9E9E), // Medium gray accent
  background: const Color.fromARGB(255, 48, 48, 48), // Dark gray background
  button: const Color(0xFF757575), // Medium gray button color
  card: const Color.fromARGB(255, 41, 41, 41), // Dark gray card
  card2: const Color.fromARGB(
      255, 117, 117, 117), // Medium gray for secondary card
  bodyText1: const Color.fromARGB(255, 245, 245, 245), // Light grey text
  bodyText2:
      const Color.fromARGB(255, 224, 224, 224), // Slightly darker for bodyText2
  bodyText3:
      const Color.fromARGB(255, 189, 189, 189), // Darker grey for bodyText3
  iconColor: const Color.fromARGB(255, 255, 255, 255), // Medium grey for icons
  iconColor2:
      const Color.fromARGB(255, 255, 255, 255), // Slightly lighter icons
  naviconcolor:
      const Color.fromARGB(255, 245, 245, 245), // Light grey for nav icon color
  navbar: const Color(0xFF424242), // Darker gray for navbar
  sidebar: const Color(0xFF212121), // Almost black sidebar
  calanderColor1: const Color(0xFF616161), // Dark gray for calendar
  calanderColorselected:
      const Color.fromARGB(255, 224, 224, 224), // Light grey for selected
  calanderColornotselected:
      const Color.fromARGB(255, 189, 189, 189), // Medium grey for non-selected
);

class MyThemes extends ChangeNotifier {
  String pill2 = lightColors.pill2;
  String contacts = lightColors.contacts;
  String appointments = lightColors.appointments;
  String bluetooth = lightColors.bluetooth;
  String pharmacies = lightColors.pharmacies;
  MyThemes({
    required this.pill2,
    required this.contacts,
    required this.appointments,
    required this.bluetooth,
    required this.pharmacies,
  }) {
    loadTheme();
  }

  int currentThemeIndex = 0;
  ThemeData currentTheme = ThemeData(
    primaryColor: lightColors.primary,
    colorScheme: ColorScheme.light(
      secondary: lightColors.accent,
    ),
    scaffoldBackgroundColor: lightColors.background,
    buttonTheme: ButtonThemeData(
      buttonColor: lightColors.button,
    ),
    cardColor: lightColors.card,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightColors.bodyText1),
      bodyMedium: TextStyle(color: lightColors.bodyText2),
      bodySmall: TextStyle(color: lightColors.bodyText3),
    ),
    iconTheme: IconThemeData(
      color: lightColors.iconColor,
    ),
  );
  MyThemeColors currentColors = lightColors;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    currentThemeIndex = prefs.getInt('theme') ?? 0;
    switchTheme(currentThemeIndex);
  }

  void switchTheme(int index) {
    currentThemeIndex = index;
    if (currentThemeIndex == 0) {
      currentTheme = ThemeData(
        primaryColor: darkColors.primary,
        colorScheme: ColorScheme.dark(
          secondary: darkColors.accent,
        ),
        scaffoldBackgroundColor: darkColors.background,
        buttonTheme: ButtonThemeData(
          buttonColor: darkColors.button,
        ),
        cardColor: darkColors.card,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: darkColors.bodyText1),
          bodyMedium: TextStyle(color: darkColors.bodyText2),
        ),
        iconTheme: IconThemeData(
          color: darkColors.iconColor,
        ),
      );
      currentColors = darkColors;
    } else if (currentThemeIndex == 1) {
      currentTheme = ThemeData(
        primaryColor: lightColors.primary,
        colorScheme: ColorScheme.light(
          secondary: lightColors.accent,
        ),
        scaffoldBackgroundColor: lightColors.background,
        buttonTheme: ButtonThemeData(
          buttonColor: lightColors.button,
        ),
        cardColor: lightColors.card,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: lightColors.bodyText1),
          bodyMedium: TextStyle(color: lightColors.bodyText2),
        ),
        iconTheme: IconThemeData(
          color: lightColors.iconColor,
        ),
      );
      currentColors = lightColors;
    } else {
      currentTheme = ThemeData(
        primaryColor: pinkColors.primary,
        colorScheme: ColorScheme.light(
          secondary: pinkColors.accent,
        ),
        scaffoldBackgroundColor: pinkColors.background,
        buttonTheme: ButtonThemeData(
          buttonColor: pinkColors.button,
        ),
        cardColor: pinkColors.card,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: pinkColors.bodyText1),
          bodyMedium: TextStyle(color: pinkColors.bodyText2),
        ),
        iconTheme: IconThemeData(
          color: pinkColors.iconColor,
        ),
      );
      currentColors = pinkColors;
    }
    notifyListeners();
    saveTheme();
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', currentThemeIndex);
  }
}
