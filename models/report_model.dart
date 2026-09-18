class ReportModel {
  final String id;
  final String reportedUserId;
  final String reportedBy;
  final String reason;
  final String status;

  ReportModel({
    required this.id,
    required this.reportedUserId,
    required this.reportedBy,
    required this.reason,
    required this.status,
  });

  factory ReportModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ReportModel(
      id: id,
      reportedUserId:
          map['reportedUserId'] ?? '',
      reportedBy:
          map['reportedBy'] ?? '',
      reason:
          map['reason'] ?? '',
      status:
          map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportedUserId':
          reportedUserId,
      'reportedBy':
          reportedBy,
      'reason': reason,
      'status': status,
    };
  }
}