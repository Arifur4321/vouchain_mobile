import 'package:vouchain_wallet_app/entity/VoucherDTO.dart';

class TransactionDTO {
  String usrIdDa;
  String usrIdDaString;
  String usrIdA;
  String usrIdAString;
  String trcId;
  String trcTxId;
  String trcType;
  String trcDate;
  String trcState; //confirmed - pending
  String trcIban;
  String trcPayed; //payed - not_payed
  String trcCancDate;

//Blob trcInvoice: Blob;
  String transactionListExcel;
  String trcValue;
  String trcAccountHolder;

  //transaction detail
  String vchName;
  String vchValue;
  List<dynamic> voucherList;
  String status;
  String trcQrCausale;

  TransactionDTO(
      {this.usrIdDa,
      this.usrIdDaString,
      this.usrIdA,
      this.usrIdAString,
      this.trcId,
      this.trcTxId,
      this.trcType,
      this.trcDate,
      this.trcState,
      this.trcIban,
      this.trcPayed,
      this.trcCancDate,
//Blob trcInvoice: Blob;
      this.transactionListExcel,
      this.trcValue,
      this.trcAccountHolder,
      this.vchName,
      this.vchValue,
      this.voucherList,
      this.status,
      this.trcQrCausale});

  factory TransactionDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> list;

    if (json['voucherList'] != null) {
      list = json['voucherList'].map((i) => VoucherDTO.fromJson(i)).toList();
    }
    return TransactionDTO(
        usrIdDa: json['usrIdDa'],
        usrIdDaString: json['usrIdDaString'],
        usrIdA: json['usrIdA'],
        usrIdAString: json['usrIdAString'],
        trcId: json['trcId'],
        trcTxId: json['trcTxId'],
        trcType: json['trcType'],
        trcDate: json['trcDate'],
        trcState: json['trcState'],
        trcIban: json['trcIban'],
        trcPayed: json['trcPayed'],
        trcCancDate: json['trcCancDate'],
        //trcInvoice: json['trcInvoice'],
        transactionListExcel: json['transactionListExcel'],
        trcValue: json['trcValue'],
        trcAccountHolder: json['trcAccountHolder'],
        vchName: json['vchName'],
        vchValue: json['vchValue'],
        voucherList: list,
        status: json['status'],
        trcQrCausale: json['trcQrCausale']);
  }
}
