import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themeData.dart';

class PlaylistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context).currentColors;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Playlist', style: TextStyle(color: currentColors.bodyText1)),
        backgroundColor: currentColors.navbar,
      ),
      body: Center(
        child: Text(
          'Playlist Page',
          style: TextStyle(color: currentColors.bodyText1, fontSize: 24),
        ),
      ),
    );
  }
}
