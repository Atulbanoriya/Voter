import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class CandidateApply extends StatefulWidget {
  const CandidateApply({super.key});

  @override
  State<CandidateApply> createState() => _CandidateApplyState();
}

class _CandidateApplyState extends State<CandidateApply> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _constituencyController = TextEditingController();
  final _electionTypeController = TextEditingController();
  final _designationController = TextEditingController();
  final _partyController = TextEditingController();
  bool _termsAccepted = false;

  Future<void> _submitApplication() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('CandidateApply').add({
        'userId': _userIdController.text,
        'constituency': _constituencyController.text,
        'electionType': _electionTypeController.text,
        'designation': _designationController.text,
        'party': _partyController.text,
        'termsAccepted': _termsAccepted,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully!')),
      );

      // Clear the form
      _formKey.currentState?.reset();
      setState(() {
        _termsAccepted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: Image.asset(
              "assest/image/logo.png",
              height: 50,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Apply For Candidate",
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    label: const Text("User Id"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your User Id';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _constituencyController,
                  decoration: InputDecoration(
                    label: const Text("Constituency"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Constituency';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _electionTypeController,
                  decoration: InputDecoration(
                    label: const Text("Election Type"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Election Type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _designationController,
                  decoration: InputDecoration(
                    label: const Text("Designation"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Designation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _partyController,
                  decoration: InputDecoration(
                    label: const Text("Party"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Party';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'I accept your Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: _termsAccepted ? _submitApplication : null,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _termsAccepted ? Colors.blue : Colors.grey,
                    ),
                    child: const Center(
                      child: Text(
                        "Submit For Review",
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
      ),
    );
  }
}
