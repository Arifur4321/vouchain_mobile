import 'package:vouchain_wallet_app/entity/FaqDTO.dart';
import 'package:vouchain_wallet_app/entity/SupportDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/QrCodeDTO.dart';
import 'package:vouchain_wallet_app/entity/TransactionDTO.dart';
import 'package:vouchain_wallet_app/entity/VoucherDTO.dart';

class DTOList<T> {
  String errorDescription;
  String status;
  List<T> list;

  DTOList({this.status, this.errorDescription, this.list});

  factory DTOList.fromJsonVoucher(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList = json['list'].map((i) => VoucherDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }

  factory DTOList.fromJsonTransaction(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList =
          json['list'].map((i) => TransactionDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }

  factory DTOList.fromJsonMerchant(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList = json['list'].map((i) => MerchantDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }

  factory DTOList.fromJsonSupport(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList = json['list'].map((i) => SupportDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }

  factory DTOList.fromJsonQrCode(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList = json['list'].map((i) => QrCodeDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }

  factory DTOList.fromJsonFaq(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['list'] != null) {
      decodedList = json['list'].map((i) => FaqDTO.fromJson(i)).toList();
    }
    return DTOList(
      status: json["status"],
      errorDescription: json['errorDescription'],
      list: decodedList,
    );
  }
}
