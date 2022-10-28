import 'dart:convert';

import 'package:flutter/material.dart';

//DTO
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';
import 'package:vouchain_wallet_app/entity/TransactionDTO.dart';
import 'package:vouchain_wallet_app/entity/CityDTO.dart';
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/ProvinceDTO.dart';

//REST
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/rest/RestGlobals.dart' as globals;

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session/flutter_session.dart';

class UserServices {
  static Future<SimpleDTO> passwordRecovery(
      String email, String profile, BuildContext context) async {
    final http.Response response = await http.post(
        globals.passwordRecovery + profile,
        headers: globals.usrHeader,
        body: jsonEncode(<String, String>{'usrEmail': email}));

    if (response.statusCode == 200) {
      return SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to recover password.');
    }
  }

  // ignore: missing_return
  static Future<SimpleDTO> passwordChange(String psw, String oldPsw,
      String profile, dynamic user, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, user);
    if (sessionResponse.status == "OK") {
      final http.Response response = await http.post(globals.passwordChange,
          headers: globals.usrHeader,
          body: jsonEncode({
            "userId": user.usrId,
            "oldPsw": oldPsw,
            "newPsw": psw,
            "usrProfile": profile
          }));
      //print("PSW RESPONSE ----" + response.statusCode.toString());
      if (response.statusCode == 200) {
        SimpleDTO responsDTOe =
            SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        //print("PSW STATUS --- " + responsDTOe.status);
        //print("PSW ERROR --- " + responsDTOe.toString());
        return responsDTOe;
      }
      utility.genericErrorAlert(context);
      return SimpleDTO(status: "KO");
    } else {
      utility.sortAccessType(context, user);
    }
  }

  static Future<SimpleDTO> passwordReset(
      String code, String psw, BuildContext context) async {
    final http.Response response = await http.post(globals.passwordReset + code,
        headers: globals.usrHeader,
        body: jsonEncode(<String, String>{'usrPassword': psw}));

    if (response.statusCode == 200) {
      return SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to recover password.');
    }
  }

  static verifySession(BuildContext context, dynamic user) async {
    print("USER --- " + user.toString());
    FlutterSession session = FlutterSession();
    String _currentToken = await session.get("sessionId");
    if (_currentToken.isNotEmpty && _currentToken != null) {
      final http.Response response = await http.post(globals.verifySession,
          headers: globals.usrHeader,
          body: jsonEncode(<String, String>{
            'sessionId': _currentToken,
            'username': await session.get("username"),
            'forceUpdate': "false"
          }));
      print("TOKEN (verify) ---- " + await session.get("sessionId"));
      if (response.statusCode == 200) {
        SimpleDTO responseDTO =
            SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        print("SESSION (verify) ---- " + responseDTO.status);
        print("ERROR (verify) ---- " + responseDTO.errorDescription.toString());
        return responseDTO;
      } else {
        utility.genericErrorAlert(context);
        return SimpleDTO(status: "KO");
      }
    }
  }

  // Reimposta la sessione, sostituendo il sessionId nel caso di una
  // riconnessione e inviando una stringa vuota nel caso di un logout
  static resetSession(BuildContext context, dynamic user) async {
    final http.Response response = await http.post(globals.resetSession,
        headers: globals.usrHeader,
        body: jsonEncode(<String, String>{
          'sessionId': await FlutterSession().get("sessionId"),
          'username': await FlutterSession().get("username"),
          'forceUpdate': "true"
        }));
    print("STATUS (reset) ---- " + response.statusCode.toString());
    print("TOKEN (reset) ---- " +
        (await FlutterSession().get("sessionId")).toString());
    if (response.statusCode == 200) {
      SimpleDTO responseDTO =
          SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      print("RESPONSE (reset) ---- " + responseDTO.status.toString());
      return responseDTO.status;
    } else {
      utility.genericErrorAlert(context);
      return "KO";
    }
  }

  // Effettua il logout dell'utente, cancellando anche le sue preferenze di login
  static logout(BuildContext context, dynamic user) async {
    final sessionResponse = await UserServices.verifySession(context, user);
    if (sessionResponse.status == "OK") {
      final storage = FlutterSecureStorage();
      storage.deleteAll();
      user.accessType = null;
      user.pinCode = null;
      var u;
      (user is EmployeeDTO)
          ? u = await EmpServices.modEmpProfile(user, context)
          : u = await MrcServices.modMrcProfile(user, context);
      print("USRID " +
          u.usrId.toString() +
          " --- ACCESSTYPE " +
          u.accessType.toString() +
          " --- PINCODE " +
          u.pinCode.toString());
      FlutterSession _session = FlutterSession();
      String _currentToken = await _session.get("sessionId");
      print("CURRENT TOKEN ---- " + _currentToken.toString());
      if (_currentToken.isNotEmpty && _currentToken != null) {
        await FlutterSession().set("sessionId", "");
        final sessionResponse = await UserServices.resetSession(context, user);
        print("RESPONSE --- $sessionResponse");
        return sessionResponse;
      }
      return "OK";
    } else {
      utility.sortAccessType(context, user);
    }
  }

  static checkSession(BuildContext context, dynamic user) async {
    print("USER --- " + user.toString());
    FlutterSession session = FlutterSession();
    String _currentToken = await session.get("sessionId");
    if (_currentToken.isNotEmpty && _currentToken != null) {
      final http.Response response = await http.post(globals.checkSession,
          headers: globals.usrHeader,
          body: jsonEncode(<String, String>{
            'sessionId': _currentToken,
            'username': await session.get("username"),
            'forceUpdate': "false"
          }));
      print("TOKEN (check) ---- " + await session.get("sessionId"));
      if (response.statusCode == 200) {
        SimpleDTO responseDTO =
            SimpleDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        print("SESSION (check) ---- " + responseDTO.status);
        print("ERROR (check) ---- " + responseDTO.errorDescription.toString());
        return responseDTO;
      } else {
        utility.genericErrorAlert(context);
        return SimpleDTO(status: "KO");
      }
    }
  }

  // Se sono presenti transazioni nell'intervallo di tempo, restituisce una
  // stringa con il file excel delle transazioni in formato codificato base64,
  // altrimenti restituisce null
  // ignore: missing_return
  static Future<String> exportHistory(String profile, DateTimeRange range,
      BuildContext context, dynamic user) async {
    final sessionResponse = await verifySession(context, user);
    if (sessionResponse.status == "OK") {
      final startDate = DateFormat('yyyy-MM-dd').format(range.start).toString();
      final endDate = DateFormat('yyyy-MM-dd').format(range.end).toString();

      final http.Response response = await http.post(globals.transactionExport,
          headers: globals.trcHeader,
          body: jsonEncode(<String, String>{
            'usrId': user.usrId,
            'profile': profile,
            'startDate': startDate,
            'endDate': endDate
          }));
      //print("STATUS (export) ---- " + response.statusCode.toString());
      //print("RESPONSE (export) ---- " + response.body.toString());
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return TransactionDTO.fromJson(
                  json.decode(utf8.decode(response.bodyBytes)))
              .transactionListExcel;
        } else {
          return "empty";
        }
      } else {
        utility.genericErrorAlert(context);
        return "error";
      }
    }
  }

// ignore: missing_return
  static Future<List<ProvinceDTO>> getProvinces(BuildContext context) async {
    final http.Response response =
        await http.get(globals.getAllProvinces, headers: globals.cpyHeader);
    //print("PROVINCE --- " + response.body);
    List<ProvinceDTO> provinces = [];
    if (response.statusCode == 200) {
      if (response.body != null) {
        var decodedList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        provinces = decodedList?.map((i) => ProvinceDTO.fromJson(i))?.toList();
      }
      /*for(ProvinceDTO prov in provinces){
        print(prov.cod);
        print(prov.name);
      }*/
    } else {
      utility.genericErrorAlert(context);
    }
    return provinces;
  }

  // ignore: missing_return
  static Future<List<CityDTO>> getCities(
      String idProvince, BuildContext context) async {
    final http.Response response = await http.get(
        globals.getCitiesByProvince + idProvince,
        headers: globals.cpyHeader);
    //print("CITTà --- " + response.body);
    List<CityDTO> cities = [];
    if (response.statusCode == 200) {
      if (response.body != null) {
        var decodedList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        cities = decodedList?.map((i) => CityDTO.fromJson(i))?.toList();
      }
      /*for(CityDTO city in cities){
        print(city.id);
      }*/
    } else {
      utility.genericErrorAlert(context);
    }
    return cities;
  }

  // ignore: missing_return
  static Future<DTOList<dynamic>> getFaq(
      String profile, dynamic user, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, user);
    if (sessionResponse.status == "OK") {
      final http.Response response =
          await http.get(globals.faq + profile, headers: globals.usrHeader);
      //print("FAQ RESPONSE ----" + response.statusCode.toString());
      DTOList<dynamic> faqList;
      if (response.statusCode == 200) {
        faqList =
            DTOList.fromJsonFaq(json.decode(utf8.decode(response.bodyBytes)));
        //print("FAQ STATUS --- " + faqList.status);
        //print("FAQ ERROR --- " + faqList.errorDescription.toString());
      } else {
        utility.genericErrorAlert(context);
      }
      return faqList;
    } else {
      utility.sortAccessType(context, user);
    }
  }

  // ignore: missing_return
  static Future<DTOList<dynamic>> getSupport(
      dynamic user, BuildContext context) async {
    final sessionResponse = await UserServices.verifySession(context, user);
    if (sessionResponse.status == "OK") {
      final http.Response response =
          await http.get(globals.support, headers: globals.usrHeader);
      //print("SUPPORT RESPONSE ----" + response.statusCode.toString());
      //print("SUPPORT RESPONSE LIST ----" + response.body.toString());
      DTOList<dynamic> supportList;
      if (response.statusCode == 200) {
        supportList = DTOList.fromJsonSupport(
            json.decode(utf8.decode(response.bodyBytes)));
        //print("SUPPORT STATUS --- " + supportList.status);
        //print("SUPPORT ERROR --- " + supportList.errorDescription.toString());
      } else {
        utility.genericErrorAlert(context);
      }
      return supportList;
    } else {
      utility.sortAccessType(context, user);
    }
  }
}
