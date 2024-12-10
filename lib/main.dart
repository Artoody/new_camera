import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/bluetooth_connect_page.dart';
import 'pages/themeData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BluetoothConnectionStatus(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReceivedData(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyThemes(
            pill2: 'lib/pages/pics/pill2blue.png',
            contacts: 'lib/pages/pics/contactsblue.jpg',
            appointments: 'lib/pages/pics/appointmentsblue.jpg',
            bluetooth: 'lib/pages/pics/bluetoothblue.jpg',
            pharmacies: 'lib/pages/pics/pharmaciesblue.jpg',
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemes>(
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Helmet App',
          theme: theme.currentTheme,
          home: MainPage(),
        );
      },
    );
  }
}
