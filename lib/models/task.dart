import 'dart:convert';

class Task {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  Task copyWith({String? id, String? title, bool? done, DateTime? createdAt}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static String encodeList(List<Task> tasks) => jsonEncode(tasks.map((t) => t.toJson()).toList());
  static List<Task> decodeList(String raw) {
    final data = jsonDecode(raw) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(Task.fromJson).toList();
  }
}


