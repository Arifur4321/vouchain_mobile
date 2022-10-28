import 'dart:convert';
import 'package:flutter/material.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';
import 'package:vouchain_wallet_app/entity/VoucherDTO.dart';

//REST
import 'package:vouchain_wallet_app/rest/RestGlobals.dart' as globals;
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class EmpServices {
  // ignore: missing_return
  static Future<EmployeeDTO> authEmployee(
      String email, String password, BuildContext context) async {
    final http.Response response = await http
        .post(globals.empLogin,
            headers: globals.empHeader,
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
      EmployeeDTO emp =
          EmployeeDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (emp.status == "OK") {
        var session = FlutterSession();
        String token = await session.get("sessionId");
        print("TOKEN AUTH ----" + token.toString());
        if (token == null || token.isEmpty) {
          await session.set("sessionId", utility.generateAlphaNumericString());
          await session.set("username", emp.usrEmail);
        }
      }
      return emp;
    } else {
      utility.genericErrorAlert(context);
      return EmployeeDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<EmployeeDTO> checkInvitationCode(
      String code, BuildContext context) async {
    final http.Response response = await http.get(
      globals.checkInvitationCode + code,
      headers: globals.empHeader,
    );
    print("RESPONSE INVITATION CODE");
    print("STATUS --- " + response.statusCode.toString());
    print("BODY --- " + response.body.toString());
    if (response.statusCode == 200) {
      return EmployeeDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      utility.genericErrorAlert(context);
      return EmployeeDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<EmployeeDTO> empSignup(
      EmployeeDTO emp, BuildContext context) async {
    final http.Response response = await http.post(globals.empSignup,
        headers: globals.empHeader, body: jsonEncode(emp.toJson()));
    if (response.statusCode == 200) {
      EmployeeDTO empRespAuth =
          await authEmployee(emp.usrEmail, emp.usrPassword, context);
      return empRespAuth;
    } else {
      utility.genericErrorAlert(context);
      return EmployeeDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<EmployeeDTO> getEmpProfile(String usrId,
      {BuildContext context}) async {
    final http.Response response = await http
        .get(globals.getEmpProfile + usrId, headers: globals.empHeader)
        .timeout(Duration(seconds: 15), onTimeout: () {
      print("TIMEOUT");
      return http.Response(jsonEncode(<String, String>{'status': "KO"}), 408);
    });
    print(
        "RESPONSE STATUS (getProfile) ----- " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return EmployeeDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      if (context != null) {
        utility.genericErrorAlert(context);
      }
      return EmployeeDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<EmployeeDTO> modEmpProfile(
      EmployeeDTO emp, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, emp);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.modEmpProfile,
          headers: globals.empHeader, body: jsonEncode(emp.toJson()));
      print("MOD RESPONSE CODE----" + response.statusCode.toString());
      if (response.statusCode == 200) {
        EmployeeDTO empResponse =
            EmployeeDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        print("MOD EMP STATUS --- " + empResponse.status);
        print("MOD EMP ERROR --- " + empResponse.toString());
        if (empResponse.status == "OK") {
          return empResponse;
        }
      }
      utility.genericErrorAlert(context);
      return EmployeeDTO(status: "KO");
    } else {
      utility.sortAccessType(context, emp);
    }
  }

  // ignore: missing_return
  static Future<DTOList> empVoucherList(
      EmployeeDTO emp, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, emp);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http
          .get(globals.empVoucherList + emp.usrId, headers: globals.vchHeader)
          .timeout(Duration(seconds: 10), onTimeout: () {
        return http.Response(jsonEncode(<String, String>{'status': "KO"}), 200);
      });
      //print("STATUS ---- "+ response.statusCode.toString());
      //print("---------- SONO IN VOUCHER -----------");
      //print("RESPONSE ---- "+ response.body);
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
      utility.sortAccessType(context, emp);
    }
  }

//   new API for wallet ALL

static Future<DTOList> empVoucherListAll(
      EmployeeDTO emp, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, emp);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http
          .get(globals.empVoucherListAll + emp.usrId, headers: globals.vchHeader)
          .timeout(Duration(seconds: 10), onTimeout: () {
        return http.Response(jsonEncode(<String, String>{'status': "KO"}), 200);
      });
      //print("STATUS ---- "+ response.statusCode.toString());
      //print("---------- SONO IN VOUCHER -----------");
      //print("RESPONSE ---- "+ response.body);
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
      utility.sortAccessType(context, emp);
    }
  }



  // ignore: missing_return
  static Future<DTOList> empTransactionList(String startDate, String endDate,
      EmployeeDTO emp, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, emp);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.transactionList,
          headers: globals.trcHeader,
          body: jsonEncode(<String, String>{
            'startDate': startDate,
            'endDate': endDate,
            'usrId': emp.usrId,
            'profile': 'employee'
          }));
      if (response.statusCode == 200) {
        return DTOList.fromJsonTransaction(
            json.decode(utf8.decode(response.bodyBytes)));
      } else {
        utility.genericErrorAlert(context);
        return DTOList(status: "KO");
      }
    } else {
      utility.sortAccessType(context, emp);
    }
  }

  // ignore: missing_return
  static Future<MerchantDTO> getMerchantFromQrCode(
      String qr, BuildContext context) async {
    final http.Response response =
        await http.post(globals.getMerchantFromQrCode,
            headers: globals.qrHeader,
            body: jsonEncode(<String, String>{
              'qrValue': qr,
              'qrMrc': null,
              'qrCash': null,
            }));
    print("STATUS ---- " + response.statusCode.toString());
    print("RESPONSE ---- " + response.body);
    if (response.statusCode == 200) {
      return MerchantDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      utility.genericErrorAlert(context);
      return MerchantDTO(status: "KO");
    }
  }

  // ignore: missing_return
  static Future<SimpleDTO> allocateVoucher(EmployeeDTO emp, MerchantDTO mrc,
      List<VoucherDTO> vouchers, BuildContext context,
      {String qr}) async {
    final sessionResponse = await UserServices.verifySession(context, emp);
    print("STATUS SESSION ---- " + sessionResponse.status.toString());
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.allocateVoucher,
          headers: globals.vchHeader,
          body: jsonEncode([
            {
              "fromId": emp.usrId,
              "profile": "employee",
              "toId": mrc.usrId,
              "qrValue": qr,
              "voucherList": vouchers
            }
          ]));
      print("STATUS ---- " + response.statusCode.toString());
      print("RESPONSE ---- " + response.body);
      if (response.statusCode == 200) {
        return SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        utility.genericErrorAlert(context);
        return SimpleDTO(status: "KO");
      }
    } else {
      utility.sortAccessType(context, emp);
    }
  }
}
