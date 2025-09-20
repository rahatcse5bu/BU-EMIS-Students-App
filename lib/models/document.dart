enum DocumentType {
  certificate,
  gradesheet,
  transcript,
}

enum DocumentStatus {
  pending,
  approved,
  hold,
}

class Document {
  final int serialNo;
  final DocumentType type;
  final DateTime requestDate;
  final double fee;
  final DateTime? checkDate;
  final DateTime? finalDeliveryDate;
  final String comments;
  final DocumentStatus status;

  Document({
    required this.serialNo,
    required this.type,
    required this.requestDate,
    required this.fee,
    this.checkDate,
    this.finalDeliveryDate,
    required this.comments,
    required this.status,
  });

  String get typeString {
    switch (type) {
      case DocumentType.certificate:
        return 'Certificate';
      case DocumentType.gradesheet:
        return 'Gradesheet';
      case DocumentType.transcript:
        return 'Transcript';
    }
  }

  String get statusString {
    switch (status) {
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.approved:
        return 'Approved';
      case DocumentStatus.hold:
        return 'Hold';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'serialNo': serialNo,
      'type': type.index,
      'requestDate': requestDate.toIso8601String(),
      'fee': fee,
      'checkDate': checkDate?.toIso8601String(),
      'finalDeliveryDate': finalDeliveryDate?.toIso8601String(),
      'comments': comments,
      'status': status.index,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      serialNo: json['serialNo'] ?? 0,
      type: DocumentType.values[json['type'] ?? 0],
      requestDate: DateTime.parse(json['requestDate']),
      fee: (json['fee'] ?? 0.0).toDouble(),
      checkDate: json['checkDate'] != null ? DateTime.parse(json['checkDate']) : null,
      finalDeliveryDate: json['finalDeliveryDate'] != null ? DateTime.parse(json['finalDeliveryDate']) : null,
      comments: json['comments'] ?? '',
      status: DocumentStatus.values[json['status'] ?? 0],
    );
  }
}
