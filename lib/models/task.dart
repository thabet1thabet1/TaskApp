class Task {
  String content;
  DateTime timestamp;
  bool done;

  Task({
    required this.content,
    required this.timestamp,
    required this.done,
  });

  factory Task.fromMap(Map task) {
    return Task(
      content: task['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(task['timestamp']),
      done: task['done'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'done': done,
    };
  }
}
