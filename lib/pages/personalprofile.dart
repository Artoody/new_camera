import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'themeData.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({super.key});

  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _medicineBoxesController = TextEditingController();

  bool _isEditing = false;
  List<Map<String, dynamic>> _medicalRecords = [];
  final TextEditingController _newRecordTitleController = TextEditingController();
  final TextEditingController _newRecordDescriptionController =
      TextEditingController();

  File? _imageFile; // N

  @override
  void dispose() {
    _saveUserInfo();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print(
          'Picked image path: ${image.path}'); // print the picked image's path

      setState(() {
        _imageFile = File(image.path); // update _imageFile and rebuild the form
      });
    }
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            if (_imageFile != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_imageFile!),
              ),
            const SizedBox(height: 16),
            if (_isEditing)
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Change Image'),
                onPressed: _pickImage,
              ),
            const SizedBox(height: 16),
            _buildTextField(_nameController, 'Name'),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone'),
            const SizedBox(height: 16),
            _buildTextField(_bloodTypeController, 'Blood Type'),
            const SizedBox(height: 16),
            _buildTextField(_addressController, 'Address'),
            const SizedBox(height: 16),
            _buildTextField(
                _medicineBoxesController, 'Number of Medicine Boxes'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context)
        .currentColors; // Access the current theme colors
    if (_isEditing && label == 'Number of Medicine Boxes') {
      return DropdownButtonFormField<String>(
        value: _medicineBoxesController.text.isEmpty
            ? null
            : _medicineBoxesController.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: <String>['1', '2', '3']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _medicineBoxesController.text = newValue!;
          });
        },
      );
    } else {
      return _isEditing
          ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
            )
          : ListTile(
              title: Text(
                label,
                style: TextStyle(color: currentColors.bodyText1, fontSize: 16),
              ),
              subtitle: Text(
                controller.text,
                style: const TextStyle(fontSize: 16),
              ),
            );
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _bloodTypeController.text = prefs.getString('bloodType') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _medicineBoxesController.text = prefs.getString('medicineBoxes') ?? '';
      _medicalRecords = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('medicalRecords') ?? '[]'),
      );
      String imagePath = prefs.getString('imagePath') ?? '';
      if (imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
    });
  }

  void _addMedicalRecord() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Medical Record'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: _newRecordTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _newRecordDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  _medicalRecords.add({
                    'title': _newRecordTitleController.text,
                    'description': _newRecordDescriptionController.text,
                  });
                  _newRecordTitleController.clear();
                  _newRecordDescriptionController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('bloodType', _bloodTypeController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('medicalRecords', jsonEncode(_medicalRecords));
    await prefs.setString('imagePath', _imageFile?.path ?? '');
    await prefs.setString('medicineBoxes', _medicineBoxesController.text);
  }

  @override
  Widget build(BuildContext context) {
    MyThemeColors currentColors = Provider.of<MyThemes>(context)
        .currentColors; // Access the current theme colors
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile'),
        backgroundColor: currentColors.background,
        actions: <Widget>[
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                _saveUserInfo();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildForm(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Medical Records',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _medicalRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_medicalRecords[index]['title']!),
                    subtitle: Text(_medicalRecords[index]['description']!),
                  );
                },
              ),
            ),
            const SizedBox(height: 50), // Add extra space at the bottom
          ],
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _isEditing ? _addMedicalRecord : null,
              backgroundColor: currentColors.button,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
