class AudioNote {
  final String path;
  final String category;
  final DateTime date;

  AudioNote({
    required this.path,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory AudioNote.fromMap(Map<String, dynamic> map) {
    return AudioNote(
      path: map['path'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}
