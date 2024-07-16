import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voting_app/feature/login.dart';

class LetsFinishView extends StatefulWidget {
  const LetsFinishView({super.key});

  @override
  State<LetsFinishView> createState() => _LetsFinishViewState();
}

class _LetsFinishViewState extends State<LetsFinishView> {
  final _formKey = GlobalKey<FormState>();
  final _constituencyController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  bool _acceptedTerms = false;
  String? _filePath;

  @override
  void dispose() {
    _constituencyController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    // Check if permission is granted
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If permission is not granted, request it
      var result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        if (kDebugMode) {
          print('Permission denied');
        }
        return;
      }
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowCompression: true,
      );
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while picking the file: $e');
      }
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must accept the terms and conditions')),
        );
        return;
      }

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'constituency': _constituencyController.text,
            'country': _countryController.text,
            'state': _stateController.text,
            'city': _cityController.text,
            'zipCode': _zipCodeController.text,
            'filePath': _filePath,
          });

          _showSuccessDialog();
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your information has been saved successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()), // Navigate to Login screen
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Local Voter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade800,
                      child: const Text(
                        "3",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Let's Finish!!!",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Upload Id Proof: Choose Only .ZIP file.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text(_filePath == null ? 'Choose file...' : _filePath!),
                ),
                const Divider(color: Colors.black),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _constituencyController,
                  decoration: const InputDecoration(
                      label: Text("Constituency"),
                    prefixIcon: Icon(Icons.location_history),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your constituency';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    label: Text("Country Name"),
                    prefixIcon: Icon(CupertinoIcons.map),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    label: Text("State Name"),
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    label: Text("City Name"),
                    prefixIcon: Icon(Icons.business_center),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(
                    label: Text("Pin Or Zip Code"),
                    prefixIcon: Icon(CupertinoIcons.location_solid),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pin or zip code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptedTerms = value!;
                        });
                      },
                    ),
                    const Text('I accept your Terms & Conditions'),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _saveData,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue),
                    child: const Center(
                      child: Text(
                        "Finish",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
