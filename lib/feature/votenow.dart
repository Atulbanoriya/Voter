import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voting_app/feature/Election.dart';
import 'package:voting_app/feature/upcomingVoterlist.dart';


class VoteNow extends StatefulWidget {
  const VoteNow({super.key});

  @override
  State<VoteNow> createState() => _VoteNowState();
}

class _VoteNowState extends State<VoteNow> {
  bool _isLoading = true;

  List<Map<String, dynamic>> _currentElections = [];
  List<Map<String, dynamic>> _upcomingElections = [];

  @override
  void initState() {
    super.initState();
    _fetchElectionsData();
  }

  Future<void> _fetchElectionsData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> currentSnapshot = await FirebaseFirestore.instance.collection('CandidateApply').get();
        QuerySnapshot<Map<String, dynamic>> upcomingSnapshot = await FirebaseFirestore.instance.collection('UpcomingElection').get();

        setState(() {
          _currentElections = currentSnapshot.docs.map((doc) => doc.data()).toList();
          _upcomingElections = upcomingSnapshot.docs.map((doc) => doc.data()).toList();
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching elections data: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 5,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Image.asset(
                "assest/image/logo.png",
                height: 50,
              ),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
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
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Elections",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

            ElectionCard(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upcoming Elections",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
               UpComingData(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ElectionCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ElectionCard({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    // Ensure the timestamp is correctly retrieved and converted
    DateTime dateTime;
    if (userData?['timestamp'] is Timestamp) {
      dateTime = (userData?['timestamp'] as Timestamp).toDate();
    } else {
      dateTime = DateTime.now(); // Default value if timestamp is not available
    }

    // Format the DateTime
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ElectionScreen(userData: userData, electionType: '',)));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: 320,
          height: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 320,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12))),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Election : Current General Elections",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Constituency:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userData?['constituency'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Election Date:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Voting Start Time:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "08:00:08",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Voting End Time:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "18:00:24",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Designations:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: userData?['designation'] ?? "N/A",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class UpComingData extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const UpComingData({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    // Ensure the timestamp is correctly retrieved and converted
    DateTime dateTime;
    if (userData?['timestamp'] is Timestamp) {
      dateTime = (userData?['timestamp'] as Timestamp).toDate();
    } else {
      dateTime = DateTime.now(); // Default value if timestamp is not available
    }

    // Format the DateTime
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UpComingVoterList(userData: userData)));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: 320,
          height: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 320,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12))),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Election : General State Elections",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Constituency:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userData?['constituency'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Election Date:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Voting Start Time:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "08:00:08",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Voting End Time:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "18:00:24",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Designations:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: userData?['designation'] ?? "N/A",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
