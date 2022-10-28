import 'dart:core';

class EmployeeDTO {
//from DTO
  String status;
  String errorDescription;

  String usrId;
  String usrBchAddress;
  String usrPrivateKey;
  String usrEmail;
  String usrPassword;
  String usrActive;
  String accessType;
  String pinCode;
  String notificationEnabled;

//from EmployeeDTO
  String empFirstName;
  String empLastName;
  String empMatricola;
  String empInvitationCode;
  String empCheckedLogin;
  String cpyUsrId;

  EmployeeDTO(
      {this.status,
      this.errorDescription,
      this.usrId,
      this.usrBchAddress,
      this.usrPrivateKey,
      this.usrEmail,
      this.usrPassword,
      this.usrActive,
      this.empFirstName,
      this.empLastName,
      this.empMatricola,
      this.empInvitationCode,
      this.empCheckedLogin,
      this.cpyUsrId,
      this.accessType,
      this.pinCode,
      this.notificationEnabled});

  factory EmployeeDTO.fromJson(Map<String, dynamic> json) {
    return EmployeeDTO(
        status: json["status"],
        errorDescription: json['errorDescription'],
        usrId: json["usrId"],
        usrBchAddress: json["usrBchAddress"],
        usrPrivateKey: json["usrPrivateKey"],
        usrEmail: json["usrEmail"],
        usrPassword: json["usrPassword"],
        usrActive: json["usrActive"],
        empFirstName: json["empFirstName"],
        empLastName: json["empLastName"],
        empMatricola: json["empMatricola"],
        empInvitationCode: json["empInvitationCode"],
        empCheckedLogin: json["empCheckedLogin"],
        cpyUsrId: json["cpyUsrId"],
        accessType: json["accessType"],
        pinCode: json["pinCode"],
        notificationEnabled: json["empNotificationEnabled"]);
  }

  Map<String, String> toJson() => {
        'status': status,
        'errorDescription': errorDescription,
        'usrId': usrId,
        'usrBchAddress': usrBchAddress,
        'usrPrivateKey': usrPrivateKey,
        'usrEmail': usrEmail,
        'usrPassword': usrPassword,
        'usrActive': usrActive,
        'empFirstName': empFirstName,
        'empLastName': empLastName,
        'empMatricola': empMatricola,
        'empInvitationCode': empInvitationCode,
        'empCheckedLogin': empCheckedLogin,
        'cpyUsrId': cpyUsrId,
        'accessType': accessType,
        'pinCode': pinCode,
        'empNotificationEnabled': notificationEnabled
      };
}
