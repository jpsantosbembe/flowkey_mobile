import 'key_model.dart';

class LoanModel {
  final int id;
  final int borrowedByUserId;
  final int givenByUserId;
  final int borrowedKeyId;
  final String borrowedAt;
  final KeyModel key;
  final String givenByName;
  final String borrowedByName; // 🔥 Novo campo

  LoanModel({
    required this.id,
    required this.borrowedByUserId,
    required this.givenByUserId,
    required this.borrowedKeyId,
    required this.borrowedAt,
    required this.key,
    required this.givenByName,
    required this.borrowedByName,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      borrowedByUserId: json['borrowed_by_user_id'],
      givenByUserId: json['given_by_user_id'],
      borrowedKeyId: json['borrowed_key_id'],
      borrowedAt: json['borrowed_at'],
      key: KeyModel.fromJson(json['key']),
      givenByName: json['given_by']['name'],
      borrowedByName: json['borrowed_by']['name'],
    );
  }
}
