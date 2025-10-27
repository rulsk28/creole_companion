class Translation {
  final int? id;
  final String english;
  final String creole;

  Translation({this.id, required this.english, required this.creole});

  Map<String, dynamic> toMap() {
    return {'id': id, 'english': english, 'creole': creole};
  }

  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      id: map['id'],
      english: map['english'],
      creole: map['creole'],
    );
  }
}
