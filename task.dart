class Task {
  final String id;
  String title;
  String subject;
  String description;
  String deadline;
  String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.deadline,
    required this.priority,
    this.isCompleted = false,
  });
}
