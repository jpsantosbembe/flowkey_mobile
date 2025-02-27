class KeyModel {
  final int id;
  final String label;
  final String description;

  KeyModel({required this.id, required this.label, required this.description});

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      id: json['id'],
      label: json['label'],
      description: json['description'],
    );
  }
}
