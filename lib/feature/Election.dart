import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/model/candidate.dart';

class ElectionScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const ElectionScreen({super.key, this.userData});

  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final List<Candidate> candidates = [];
  bool hasVoted = false;
  int? votedCandidateIndex;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    final snapshot = await FirebaseFirestore.instance.collection('CandidateApply').get();
    final List<Candidate> fetchedCandidates = snapshot.docs.map((doc) {
      final data = doc.data();
      return Candidate(
        candidateName: data['userId'] ?? 'Unknown',
        electionType: data['electionType'] ?? 'Unknown',
        designation: data['designation'] ?? 'Unknown',
        party: data['party'] ?? 'Unknown',
        votingDate: data['votingDate'] ?? 'Unknown',
        imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      );
    }).toList();

    setState(() {
      candidates.addAll(fetchedCandidates);
    });

    await fetchVotingState();
  }

  Future<void> fetchVotingState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final votesSnapshot = await FirebaseFirestore.instance.collection('votes').doc(user.uid).get();
      if (votesSnapshot.exists) {
        final voteData = votesSnapshot.data();
        final candidateName = voteData!['candidateName'];
        final index = candidates.indexWhere((candidate) => candidate.candidateName == candidateName);
        if (index != -1) {
          setState(() {
            hasVoted = true;
            votedCandidateIndex = index;
          });
        }
      }
    }
  }

  Future<void> voteForCandidate(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        hasVoted = true;
        votedCandidateIndex = index;
      });

      // Save the vote to Firebase
      await FirebaseFirestore.instance.collection('votes').doc(user.uid).set({
        'candidateName': candidates[index].candidateName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Handle the case when the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to vote.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            final candidate = candidates[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(candidate.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Name: ${candidate.candidateName}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Election Type: ${candidate.electionType}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Designation: ${candidate.designation}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text('Party: ${candidate.party}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    if (!hasVoted)
                      InkWell(
                        onTap: () => voteForCandidate(index),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text(
                              "Vote",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (votedCandidateIndex == index)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green,
                        ),
                        child: const Center(
                          child: Text(
                            "Voted",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}