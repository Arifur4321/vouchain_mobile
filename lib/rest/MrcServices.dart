import 'dart:convert';
import 'package:flutter/material.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/QrCodeDTO.dart';

//REST
import 'package:vouchain_wallet_app/rest/RestGlobals.dart' as globals;
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class MrcServices {
  // ignore: missing_return
  static Future<MerchantDTO> authMerchant(
      String email, String password, BuildContext context) async {
    final http.Response response = await http
        .post(globals.mrcLogin,
            headers: globals.mrcHeader,
            body: jsonEncode(
                <String, String>{'usrEmail': email, 'usrPassword': password}))
        .timeout(
      Duration(seconds: 15),
      onTimeout: () {
        return http.Response(jsonEncode(<String, String>{'status': "KO"}), 200);
      },
    );
    //print("STATUS ---- "+ response.statusCode.toString());
    if (response.statusCode == 200) {
      MerchantDTO mrc =
          MerchantDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (mrc.status == "OK") {
        var session = FlutterSession();
        var token = await session.get("sessionId");
        if (token == null || token.isEmpty) {
          await session.set("sessionId", utility.generateAlphaNumericString());
          await session.set("username", mrc.usrEmail);
        }
      }
      return mrc;
    } else {
      utility.genericErrorAlert(context);
      return MerchantDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<MerchantDTO> getMrcProfile(String usrId,
      {BuildContext context}) async {
    final http.Response response = await http
        .get(globals.getMrcProfile + usrId, headers: globals.mrcHeader)
        .timeout(Duration(seconds: 15), onTimeout: () {
      return http.Response(jsonEncode(<String, String>{'status': "KO"}), 408);
    });
    if (response.statusCode == 200) {
      return MerchantDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      if (context != null) {
        utility.genericErrorAlert(context);
      }
      return MerchantDTO(status: "KO");
    }
  }

  static modMrcProfile(MerchantDTO mrc, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, mrc);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.modMrcProfile,
          headers: globals.mrcHeader, body: jsonEncode(mrc.toJson()));
      //print("MOD RESPONSE ----" + response.statusCode.toString());
      if (response.statusCode == 200) {
        MerchantDTO mrcResponse =
            MerchantDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        //print("MRC STATUS --- " + mrcResponse.status);
        //print("MRC ERROR --- " + mrcResponse.toString());
        if (mrcResponse.status == "OK") {
          return mrcResponse;
        }
      }
      utility.genericErrorAlert(context);
      return MerchantDTO(status: "KO");
    } else {
      utility.sortAccessType(context, mrc);
    }
  }

  // ignore: missing_return
  static Future<DTOList> mrcVoucherList(
      MerchantDTO mrc, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, mrc);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.get(
        globals.mrcVoucherList + mrc.usrId,
        headers: globals.vchHeader,
      );
      if (response.statusCode == 200) {
        DTOList list = DTOList.fromJsonVoucher(
            json.decode(utf8.decode(response.bodyBytes)));
        if (list.status != "OK") {
          utility.genericErrorAlert(context);
        }
        return list;
      } else {
        utility.genericErrorAlert(context);
        return DTOList(status: "KO");
      }
    } else {
      utility.sortAccessType(context, mrc);
    }
  }

  // ignore: missing_return
  static Future<DTOList> mrcTransactionList(String startDate, String endDate,
      MerchantDTO mrc, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, mrc);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.transactionList,
          headers: globals.trcHeader,
          body: jsonEncode(<String, String>{
            'startDate': startDate,
            'endDate': endDate,
            'usrId': mrc.usrId,
            'profile': 'merchant'
          }));
      if (response.statusCode == 200) {
        return DTOList.fromJsonTransaction(
            json.decode(utf8.decode(response.bodyBytes)));
      } else {
        utility.genericErrorAlert(context);
        return DTOList(status: "KO");
      }
    } else {
      utility.sortAccessType(context, mrc);
    }
  }

  // ignore: missing_return
  static Future<DTOList> mrcCheckUpdateTransactionList(String startDate,
      String endDate, MerchantDTO mrc, BuildContext context) async {
    final http.Response response = await http.post(globals.transactionList,
        headers: globals.trcHeader,
        body: jsonEncode(<String, String>{
          'startDate': startDate,
          'endDate': endDate,
          'usrId': mrc.usrId,
          'profile': 'merchant'
        }));
    if (response.statusCode == 200) {
      return DTOList.fromJsonTransaction(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      utility.genericErrorAlert(context);
      return DTOList(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<DTOList> mrcGISList(String longitude, String latitude,
      String range, BuildContext context) async {
    //print("RANGE SERVIZIO--- " + range);
    final http.Response response = await http.post(globals.mrcGISList,
        headers: globals.mrcHeader,
        body: jsonEncode(<String, String>{
          'longitude': longitude,
          'latitude': latitude,
          'raggio': range,
        }));
    print("---------- SONO IN MERCHANTLIST -----------");

    //print('RESPONSE STATUS ----- ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      //print('BODY LISTA ----- ' + response.body.toString());
      return DTOList.fromJsonMerchant(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      utility.genericErrorAlert(context);
      return DTOList(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<DTOList<dynamic>> getQrList(
      MerchantDTO mrc, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, mrc);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http
          .get(
        globals.getQrList + mrc.usrId,
        headers: globals.qrHeader,
      )
          .timeout(
        Duration(seconds: 15),
        onTimeout: () {
          return http.Response(
              jsonEncode(<String, String>{'status': "KO"}), 408);
        },
      );
      DTOList<dynamic> list;
      if (response.statusCode == 200) {
        list = DTOList.fromJsonQrCode(
            json.decode(utf8.decode(response.bodyBytes)));
        return list;
      } else {
        utility.genericErrorAlert(context);
        return DTOList(status: "KO");
      }
    } else {
      utility.sortAccessType(context, mrc);
    }
  }

  // ignore: missing_return
  static Future<QrCodeDTO> manageQrCode(
      MerchantDTO mrc, String mod, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, mrc);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.manageQrCode + mod,
          headers: globals.qrHeader, body: jsonEncode(mrc.toJson()));
      print("MANAGE QR RESPONSE STATUS----" + response.statusCode.toString());
      QrCodeDTO qrResponse;
      if (response.statusCode == 200) {
        qrResponse =
            QrCodeDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        return qrResponse;
      }
      utility.genericErrorAlert(context);
      qrResponse = QrCodeDTO();
      qrResponse.status = "KO";
      return qrResponse;
    } else {
      utility.sortAccessType(context, mrc);
      return QrCodeDTO(status: "KO");
    }
  }
}
