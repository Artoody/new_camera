import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'themeData.dart';
import 'bluetooth_connect_page.dart';
import 'user_info.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int smokeCounter = 0;
  double heartRate = 75.0;
  double spO2 = 98.0;
  Color smokeIndicatorColor = Colors.green;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _simulateHealthMetrics();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _simulateHealthMetrics() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        heartRate = 60 + Random().nextInt(40).toDouble(); // Random heart rate
        spO2 = 95 + Random().nextInt(5).toDouble(); // Random SpO2
      });
    });
  }

  void _updateSmokeCounter(int value) {
    setState(() {
      smokeCounter += value;
      if (smokeCounter < 5) {
        smokeIndicatorColor = Colors.green;
      } else if (smokeCounter < 10) {
        smokeIndicatorColor = Colors.orange;
      } else {
        smokeIndicatorColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context).currentColors;
    BluetoothConnectionStatus connectionStatus =
        Provider.of<BluetoothConnectionStatus>(context);

    return Scaffold(
      drawer: Drawer(child: UserInfoPage()), // Sidebar for user info
      body: Column(
        children: [
          _buildHeader(currentColors),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    currentColors,
                    title: 'Daily Smoke Count',
                    subtitle: '$smokeCounter Cigarettes',
                    icon: Icons.smoke_free,
                    progress: smokeCounter / 10,
                    color: smokeIndicatorColor,
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    currentColors,
                    title: 'Heart Rate',
                    subtitle: '${heartRate.toStringAsFixed(1)} bpm',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    currentColors,
                    title: 'SpO2',
                    subtitle: '${spO2.toStringAsFixed(1)}%',
                    icon: Icons.air,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  _buildBluetoothCard(currentColors, connectionStatus),
                  SizedBox(height: 20),
                  Text(
                    'Recommended Workouts:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.directions_run,
                              color: currentColors.iconColor),
                          title: Text('Cardio Exercises'),
                          onTap: () => _launchURL(
                              'https://www.medicalnewstoday.com/articles/cardio-exercises-at-home'),
                        ),
                        ListTile(
                          leading: Icon(Icons.self_improvement,
                              color: currentColors.iconColor),
                          title: Text('Breathing Techniques'),
                          onTap: () => _launchURL(
                              'https://cheshirechangehub.org/news/exercise-safely/breathing-exercise-to-help-you-quit-smoking/#:~:text=Deep%20breathing%20exercise&text=Put%20your%20hands%20on%20your,down%2C%20feel%20your%20belly%20deflate.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(MyThemeColors currentColors) {
    return Stack(
      children: [
        ClipPath(
          clipper: CurvedClipper(), // Custom clipper for curved edges
          child: Container(
            height: 220,
            width: double.infinity,
            child: Lottie.asset(
              'lib/assets/animations/smoke.json',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Icon(Icons.menu, color: Colors.white, size: 28),
              ),
              Text(
                'Smart Bracelet Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: currentColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    MyThemeColors currentColors, {
    required String title,
    required String subtitle,
    required IconData icon,
    double progress = 0.0,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(subtitle),
                  if (progress > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        color: color,
                        backgroundColor: color.withOpacity(0.1),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothCard(
      MyThemeColors currentColors, BluetoothConnectionStatus connectionStatus) {
    String bluetoothStatus = connectionStatus.isDeviceConnected
        ? 'Connected to ${connectionStatus.connectedDevice!.name}'
        : 'Not Connected';

    Color bluetoothColor =
        connectionStatus.isDeviceConnected ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BluetoothDevicesPage()),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: bluetoothColor.withOpacity(0.1),
                child: Icon(Icons.bluetooth, color: bluetoothColor),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bluetooth Status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(bluetoothStatus),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
