import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'personalprofile.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';
import 'themeData.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _imagePath = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserInfo();
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _email = prefs.getString('email') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _imagePath = prefs.getString('imagePath') ?? '';
      if (_imagePath.isNotEmpty) {
        _imageFile = File(_imagePath);
      }
    });
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    await prefs.setString('imagePath', _imageFile?.path ?? '');
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(image!.path);
      _imagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context).currentColors;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        backgroundColor: currentColors.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentColors.primary,
              currentColors.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _name.isEmpty
                ? _buildForm(currentColors)
                : _buildUserInfo(currentColors),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(MyThemeColors currentColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: currentColors.background.withOpacity(0.5),
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.person,
                        size: 50, color: currentColors.iconColor)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: _pickImage,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                  backgroundColor: currentColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Complete your profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Name',
                icon: Icons.person,
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 10),
              _buildTextField(
                label: 'Email',
                icon: Icons.email,
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 10),
              _buildTextField(
                label: 'Phone',
                icon: Icons.phone,
                onSaved: (value) => _phone = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveUserInfo();
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentColors.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildUserInfo(MyThemeColors currentColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: currentColors.background.withOpacity(0.5),
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? Icon(Icons.person, size: 50, color: currentColors.iconColor)
                : null,
          ),
        ),
        SizedBox(height: 20),
        Text(
          '$_name',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: currentColors.bodyText1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.email, color: currentColors.iconColor),
          title: Text(_email, style: TextStyle(fontSize: 16)),
        ),
        ListTile(
          leading: Icon(Icons.phone, color: currentColors.iconColor),
          title: Text(_phone, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 20),
        _buildNavigationButton(
          label: 'Personal Information',
          icon: Icons.person,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalProfilePage()),
            );
          },
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 10),
        _buildNavigationButton(
          label: 'Settings',
          icon: Icons.settings,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 10),
        _buildNavigationButton(
          label: 'Help',
          icon: Icons.help,
          onPressed: () async {
            const url = 'http://pillmate.ca/pillmateapp/help';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          backgroundColor: Colors.orange,
        ),
        SizedBox(height: 10),
        _buildNavigationButton(
          label: 'Info',
          icon: Icons.info,
          onPressed: () async {
            const url = 'http://pillmate.ca';
            try {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                print('Could not launch $url');
              }
            } catch (e) {
              print('Error launching URL: $e');
            }
          },
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
