import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themeData.dart'; // Import your theme data

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _currentTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentTheme = Provider.of<MyThemes>(context).currentThemeIndex;
  }

  @override
  Widget build(BuildContext context) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context)
        .currentColors; // Access the current theme colors

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: currentColors.background,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<int>(
              value: _currentTheme,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Light'),
                ),
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Dark'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Green'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  if (_currentTheme != value) {
                    _currentTheme = value!;
                    var themeProvider =
                        Provider.of<MyThemes>(context, listen: false);
                    themeProvider.switchTheme(_currentTheme);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
