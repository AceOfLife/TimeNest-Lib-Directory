class KycRequestModel {
  final String id;
  final String userId;
  final String fullName;
  final String idType;
  final String idImageUrl;
  final String selfieUrl;
  final String status;

  KycRequestModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.idType,
    required this.idImageUrl,
    required this.selfieUrl,
    required this.status,
  });

  factory KycRequestModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return KycRequestModel(
      id: id,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      idType: map['idType'] ?? '',
      idImageUrl: map['idImageUrl'] ?? '',
      selfieUrl: map['selfieUrl'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'idType': idType,
      'idImageUrl': idImageUrl,
      'selfieUrl': selfieUrl,
      'status': status,
    };
  }
}