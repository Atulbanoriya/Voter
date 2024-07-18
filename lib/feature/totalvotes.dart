import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voting_app/model/candidate.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';


class TotalVotes extends StatefulWidget {
  const TotalVotes({super.key});

  @override
  State<TotalVotes> createState() => _TotalVotesState();
}

class _TotalVotesState extends State<TotalVotes> {
  final List<Candidate> candidates = [];
  int totalVotes = 0;
  bool showVotes = false;

  @override
  void initState() {
    super.initState();
    checkTimeAndFetchVotes();
  }

  Future<void> checkTimeAndFetchVotes() async {
    final now = DateTime.now();
    print("Current time: ${now.hour}:${now.minute}"); // Logging the current time
    if (now.hour > 17 || (now.hour == 17 && now.minute >= 59)) {
      print("Time condition met. Fetching candidates with votes.");
      setState(() {
        showVotes = true;
      });
      await fetchCandidatesWithVotes();
    } else {
      print("Time condition not met. Votes will not be shown.");
    }
  }

  Future<void> fetchCandidatesWithVotes() async {
    final fetchedCandidates = <Candidate>[];

    // Fetching candidates from UpcomingElection
    final upcomingSnapshot = await FirebaseFirestore.instance.collection('UpcomingElection').get();
    for (var doc in upcomingSnapshot.docs) {
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

    // Fetching candidates from CandidateApply
    final candidateApplySnapshot = await FirebaseFirestore.instance.collection('CandidateApply').get();
    for (var doc in candidateApplySnapshot.docs) {
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
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffa0cf1a),
            ),
            child: Center(
              child: TextAnimator(
                  'Voter winner will be announced 15 minutes after voting ends' ,
                  atRestEffect: WidgetRestingEffects.pulse(),
                  maxLines: 1,
                  style: GoogleFonts.sanchez(textStyle: const TextStyle(color: Colors.black, fontSize: 11))
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Candidate Total Votes:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Voters:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 4,),
                  Text(
                    "$totalVotes",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "State Votes Status:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: candidates.map((candidate) {
                  return Container(
                    width: 55,
                    height: 110, // Set a fixed width for each container
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffa0cf1a),
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
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                        if (showVotes) ...[
                          const SizedBox(height: 10),
                          Text(
                            'T.V.: ${candidate.voteCount}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            textAlign: TextAlign.center, // Center align the text
                          ),
                        ],
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