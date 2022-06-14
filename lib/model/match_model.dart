class Match {
  final String match;
  final String label;
  final String sentence;

  const Match({
    required this.match,
    required this.label,
    required this.sentence,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      match: json['match'],
      label: json['label'],
      sentence: json['sentence'],
    );
  }
}
