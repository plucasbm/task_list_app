class Task {
  final String title;
  final DateTime date;

  Task({
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'date_time': date.toIso8601String(),
    };
  }

  Task.fromJson(Map<String,dynamic> json)
  : title = json['title'],
    date = DateTime.parse(json['date_time']);
}
