class Candidate {
  final String candidateName;
  final String electionType;
  final String designation;
  final String party;
  final String votingDate;
  final String imageUrl;
  int voteCount;

  Candidate({
    required this.candidateName,
    required this.electionType,
    required this.designation,
    required this.party,
    required this.votingDate,
    required this.imageUrl,
    this.voteCount = 0,
  });
}
