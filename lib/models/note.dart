class Note {
  String id;
  String title;
  String content;
  String category;
  String? audioPath;
  DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.audioPath,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
    'audioPath': audioPath,
    'date': date.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    category: json['category'],
    audioPath: json['audioPath'],
    date: DateTime.parse(json['date']),
  );
}
