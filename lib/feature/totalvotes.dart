import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/model/candidate.dart';

class TotalVotes extends StatefulWidget {
  const TotalVotes({super.key});

  @override
  State<TotalVotes> createState() => _TotalVotesState();
}

class _TotalVotesState extends State<TotalVotes> {
  final List<Candidate> candidates = [];
  int totalVotes = 0;

  @override
  void initState() {
    super.initState();
    fetchCandidatesWithVotes();
    // fetchUpComingElectionWithVotes();
  }

  Future<void> fetchCandidatesWithVotes() async {
    final candidateSnapshot = await FirebaseFirestore.instance.collection('UpcomingElection').get();
    final List<Candidate> fetchedCandidates = [];

    for (var doc in candidateSnapshot.docs) {
      final data = doc.data();
      final candidateName = data['userId'] ?? 'Unknown';
      final voteSnapshot = await FirebaseFirestore.instance.collection('votes')
          .where('candidateName', isEqualTo: candidateName)
          .get();
      final voteCount = voteSnapshot.size;

      fetchedCandidates.add(Candidate(
        candidateName: candidateName,
        electionType: data['electionType'] ?? 'Unknown',
        designation: data['designation'] ?? 'Unknown',
        party: data['party'] ?? 'Unknown',
        votingDate: data['votingDate'] ?? 'Unknown',
        imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
        voteCount: voteCount,
      ));
    }

    setState(() {
      candidates.addAll(fetchedCandidates);
      totalVotes = fetchedCandidates.fold(0, (sum, candidate) => sum + candidate.voteCount);
    });
  }


  // Future<void> fetchUpComingElectionWithVotes() async {
  //   final candidateSnapshot = await FirebaseFirestore.instance.collection('CandidateApply').get();
  //   final List<Candidate> fetchedCandidates = [];
  //
  //   for (var doc in candidateSnapshot.docs) {
  //     final data = doc.data();
  //     final candidateName = data['userId'] ?? 'Unknown';
  //     final voteSnapshot = await FirebaseFirestore.instance.collection('votes')
  //         .where('candidateName', isEqualTo: candidateName)
  //         .get();
  //     final voteCount = voteSnapshot.size;
  //
  //     fetchedCandidates.add(Candidate(
  //       candidateName: candidateName,
  //       electionType: data['electionType'] ?? 'Unknown',
  //       designation: data['designation'] ?? 'Unknown',
  //       party: data['party'] ?? 'Unknown',
  //       votingDate: data['votingDate'] ?? 'Unknown',
  //       imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
  //       voteCount: voteCount,
  //     ));
  //   }
  //
  //   setState(() {
  //     candidates.addAll(fetchedCandidates);
  //     totalVotes = fetchedCandidates.fold(0, (sum, candidate) => sum + candidate.voteCount);
  //   });
  // }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              height: 80,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Voters:",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$totalVotes",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
                "Candidate Total Votes :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,

              ),
            ),
          ),

          SizedBox(height: 10,),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: candidates.map((candidate) {
                  return Container(
                    width: 55,
                    height: 110,// Set a fixed width for each container
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          // Add the candidate's image if available
                          backgroundImage: NetworkImage(candidate.imageUrl),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${candidate.candidateName}',
                          maxLines:1,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'T.V.: ${candidate.voteCount}',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
