class QrCodeDTO {
  String errorDescription;
  String status;
  String qrId;
  String qrValue;
  String qrMrc;
  String qrCash;
  String qrImage;
  String qrCodePDF;

  QrCodeDTO(
      {this.status,
      this.errorDescription,
      this.qrId,
      this.qrValue,
      this.qrMrc,
      this.qrCash,
      this.qrImage,
      this.qrCodePDF});

  factory QrCodeDTO.fromJson(Map<String, dynamic> json) {
    return QrCodeDTO(
      status: json["status"],
      errorDescription: json['errorDescription'],
      qrId: json["qrId"],
      qrValue: json['qrValue'],
      qrMrc: json["qrMrc"],
      qrCash: json['qrCash'],
      qrImage: json["qrImage"],
      qrCodePDF: json['qrCodePDF'],
    );
  }

  Map<String, String> toJson() => {
        'status': status,
        'errorDescription': errorDescription,
        'qrId': qrId,
        'qrValue': qrValue,
        'qrMrc': qrMrc,
        'qrCash': qrCash,
        'qrImage': qrImage,
        'qrCodePDF': qrCodePDF,
      };
}
