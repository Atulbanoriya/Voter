import 'package:flutter/material.dart';

class ElectionDetailScreen extends StatelessWidget {
  final String candidateName;
  final String electionType;
  final String designation;
  final String party;
  final String votingDate;

  const ElectionDetailScreen({
    super.key,
    required this.candidateName,
    required this.electionType,
    required this.designation,
    required this.party,
    required this.votingDate,
  });

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
        child: Container(
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
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with actual image URL
                  ),
                ),
                const SizedBox(height: 20),
                Text('Name: $candidateName',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text('Election Type: $electionType',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Designation: $designation',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Party: $party', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    child:  Center(
                      child: Text(
                        "Voting Date was 2024-06-03 ",
                        style: TextStyle(
                          fontSize: 16,
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
