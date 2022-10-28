class VoucherDTO {
  String status;
  String errorDescription;
  String usrId;
  String usrBchAddress;
  String usrPrivateKey;
  String usrEmail;
  String usrPassword;
  String usrActive;
  String vchName;
  String vchCreationDate;
  String vchEndDate;
  String vchValue;
  String vchQuantity;
  String companyId;
  String vchState;

  VoucherDTO(
      {this.status,
      this.errorDescription,
      this.usrId,
      this.usrBchAddress,
      this.usrPrivateKey,
      this.usrEmail,
      this.usrPassword,
      this.usrActive,
      this.vchName,
      this.vchCreationDate,
      this.vchEndDate,
      this.vchValue,
      this.vchQuantity,
      this.companyId,
      this.vchState});

  factory VoucherDTO.fromJson(Map<String, dynamic> json) {
    return VoucherDTO(
        status: json["status"],
        errorDescription: json['errorDescription'],
        usrId: json["usrId"],
        usrBchAddress: json["usrBchAddress"],
        usrPrivateKey: json["usrPrivateKey"],
        usrEmail: json["usrEmail"],
        usrPassword: json["usrPassword"],
        usrActive: json["usrActive"],
        vchName: json["vchName"],
        vchCreationDate: json["vchCreationDate"],
        vchEndDate: json["vchEndDate"],
        vchValue: json["vchValue"],
        vchQuantity: json["vchQuantity"],
        companyId: json["companyId"],
        vchState: json["vchState"]);
  }

  Map<String, String> toJson() => {
        "status": status,
        "errorDescription": errorDescription,
        "usrId": usrId,
        "usrBchAddress": usrBchAddress,
        "usrPrivateKey": usrPrivateKey,
        "usrEmail": usrEmail,
        "usrPassword": usrPassword,
        "usrActive": usrActive,
        "vchName": vchName,
        "vchCreationDate": vchCreationDate,
        "vchEndDate": vchEndDate,
        "vchValue": vchValue,
        "vchQuantity": vchQuantity,
        "companyId": companyId,
        "vchState": vchState
      };
}
