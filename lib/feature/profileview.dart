import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          _userData = snapshot.data();
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  bool _isAllFieldsVerified() {
    if (_userData == null) return false;
    return _userData!.values.every((value) => value != null && value.toString().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        title: const Center(
          child: Padding(
              padding: EdgeInsets.only(right: 80),
              child: Text(
                "Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              )
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Name"),
                  prefixIcon: const Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['name']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Email"),
                  prefixIcon: const Icon(CupertinoIcons.mail),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['email']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Address"),
                  prefixIcon: const Icon(CupertinoIcons.home),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['addressLine2']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("City"),
                  prefixIcon: const Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['city']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("State"),
                  prefixIcon: const Icon(Icons.change_history),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['state']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Country"),
                  prefixIcon: const Icon(CupertinoIcons.map),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['country']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Pin Code"),
                  prefixIcon: const Icon(CupertinoIcons.location_solid),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['zipCode']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("Constituency ID"),
                  prefixIcon: const Icon(Icons.location_history),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['constituency']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("No Document"),
                  prefixIcon: const Icon(CupertinoIcons.doc),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['noDocument']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  label: const Text("UUID"),
                  prefixIcon: const Icon(Icons.verified_user_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                controller: TextEditingController(text: _userData?['uuid']),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isAllFieldsVerified() ? Colors.green : Colors.red,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const Row(
                  children: [
                    Icon(Icons.verified_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Account Status",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
