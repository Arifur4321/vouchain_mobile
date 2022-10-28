import 'dart:core';

class MerchantDTO {
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
  String mrcRagioneSociale;
  String mrcPartitaIva;
  String mrcCodiceFiscale;
  String mrcAddress;
  String mrcCity;
  String mrcProv;
  String mrcZip;
  String mrcPhoneNo;
  String mrcFirstNameReq;
  String mrcLastNameReq;
  String mrcRoleReq;
  String mrcOfficeName;
  String mrcPhoneNoOffice;
  String mrcFirstNameRef;
  String mrcLastNameRef;
  String mrcAddressOffice;
  String mrcCityOffice;
  String mrcProvOffice;
  String mrcIban;
  String mrcBank;
  String mrcChecked;
  String mrcCash;
  String mrcLongitude;
  String mrcLatitude;
  String mrcImageProfile;
  String mrcDistanza;

  MerchantDTO(
      {this.status,
      this.errorDescription,
      this.usrId,
      this.usrBchAddress,
      this.usrPrivateKey,
      this.usrEmail,
      this.usrPassword,
      this.usrActive,
      this.mrcRagioneSociale,
      this.mrcPartitaIva,
      this.mrcCodiceFiscale,
      this.mrcAddress,
      this.mrcCity,
      this.mrcProv,
      this.mrcZip,
      this.mrcPhoneNo,
      this.mrcFirstNameReq,
      this.mrcLastNameReq,
      this.mrcRoleReq,
      this.mrcOfficeName,
      this.mrcPhoneNoOffice,
      this.mrcFirstNameRef,
      this.mrcLastNameRef,
      this.mrcAddressOffice,
      this.mrcCityOffice,
      this.mrcProvOffice,
      this.mrcIban,
      this.mrcBank,
      this.mrcChecked,
      this.accessType,
      this.pinCode,
      this.mrcCash,
      this.mrcLongitude,
      this.mrcLatitude,
      this.mrcImageProfile,
      this.mrcDistanza,
      this.notificationEnabled});

  factory MerchantDTO.fromJson(Map<String, dynamic> json) {
    return MerchantDTO(
        status: json["status"],
        errorDescription: json['errorDescription'],
        usrId: json["usrId"],
        usrBchAddress: json["usrBchAddress"],
        usrPrivateKey: json["usrPrivateKey"],
        usrEmail: json["usrEmail"],
        usrPassword: json["usrPassword"],
        usrActive: json["usrActive"],
        mrcRagioneSociale: json["mrcRagioneSociale"],
        mrcPartitaIva: json["mrcPartitaIva"],
        mrcCodiceFiscale: json["mrcCodiceFiscale"],
        mrcAddress: json["mrcAddress"],
        mrcCity: json["mrcCity"],
        mrcProv: json["mrcProv"],
        mrcZip: json["mrcZip"],
        mrcPhoneNo: json["mrcPhoneNo"],
        mrcFirstNameReq: json["mrcFirstNameReq"],
        mrcLastNameReq: json["mrcLastNameReq"],
        mrcRoleReq: json["mrcRoleReq"],
        mrcOfficeName: json["mrcOfficeName"],
        mrcPhoneNoOffice: json["mrcPhoneNoOffice"],
        mrcFirstNameRef: json["mrcFirstNameRef"],
        mrcLastNameRef: json["mrcLastNameRef"],
        mrcAddressOffice: json["mrcAddressOffice"],
        mrcCityOffice: json["mrcCityOffice"],
        mrcProvOffice: json["mrcProvOffice"],
        mrcIban: json["mrcIban"],
        mrcBank: json["mrcBank"],
        mrcChecked: json["mrcChecked"],
        accessType: json["accessType"],
        pinCode: json["pinCode"],
        mrcCash: json["mrcCash"],
        mrcLongitude: json["mrcLongitude"],
        mrcLatitude: json["mrcLatitude"],
        mrcImageProfile: json["mrcImageProfile"],
        mrcDistanza: json["mrcDistanza"],
        notificationEnabled: json["mrcNotificationEnabled"]);
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
        'mrcRagioneSociale': mrcRagioneSociale,
        'mrcPartitaIva': mrcPartitaIva,
        'mrcCodiceFiscale': mrcCodiceFiscale,
        'mrcAddress': mrcAddress,
        'mrcCity': mrcCity,
        'mrcProv': mrcProv,
        'mrcZip': mrcZip,
        'mrcPhoneNo': mrcPhoneNo,
        'mrcFirstNameReq': mrcFirstNameReq,
        'mrcLastNameReq': mrcLastNameReq,
        'mrcRoleReq': mrcRoleReq,
        'mrcOfficeName': mrcOfficeName,
        'mrcPhoneNoOffice': mrcPhoneNoOffice,
        'mrcFirstNameRef': mrcFirstNameRef,
        'mrcLastNameRef': mrcLastNameRef,
        'mrcAddressOffice': mrcAddressOffice,
        'mrcCityOffice': mrcCityOffice,
        'mrcProvOffice': mrcProvOffice,
        'mrcIban': mrcIban,
        'mrcBank': mrcBank,
        'mrcChecked': mrcChecked,
        'accessType': accessType,
        'pinCode': pinCode,
        'mrcCash': mrcCash,
        'mrcLongitude': mrcLongitude,
        'mrcLatitude': mrcLatitude,
        'mrcImageProfile': mrcImageProfile,
        'mrcDistanza': mrcDistanza,
        'mrcNotificationEnabled': notificationEnabled
      };
}
