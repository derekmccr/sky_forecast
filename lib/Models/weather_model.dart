class Weather {
  final int userId;
  final int id;
  final String title;
  final String body;

  Weather({this.userId, this.id, this.title, this.body});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}