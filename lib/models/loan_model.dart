import 'key_model.dart';

class LoanModel {
  final int id;
  final int borrowedByUserId;
  final int givenByUserId;
  final int borrowedKeyId;
  final String borrowedAt;
  final KeyModel key;
  final String givenByName;
  final String borrowedByName;

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
    // Print para debug - visualizar a estrutura completa do JSON
    print("Recebido JSON de empréstimo: ${json.keys.join(', ')}");

    String borrowedBy = 'Usuário atual';

    // Verificar se existe o campo borrowed_by no JSON
    if (json.containsKey('borrowed_by')) {
      // Se existir e for um Map, pegar o name
      if (json['borrowed_by'] is Map) {
        borrowedBy = json['borrowed_by']['name'] ?? borrowedBy;
      }
    }

    return LoanModel(
      id: json['id'],
      borrowedByUserId: json['borrowed_by_user_id'],
      givenByUserId: json['given_by_user_id'],
      borrowedKeyId: json['borrowed_key_id'],
      borrowedAt: json['borrowed_at'],
      key: KeyModel.fromJson(json['key']),
      givenByName: json['given_by'] != null ? json['given_by']['name'] : 'Desconhecido',
      borrowedByName: borrowedBy,
    );
  }
}