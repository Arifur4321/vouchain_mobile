import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/common/Fingerprint.dart';
import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/common/PasswordReset.dart';
import 'package:vouchain_wallet_app/common/Pin.dart';
import 'package:vouchain_wallet_app/employee/EmpInvitationCode.dart';
import 'package:vouchain_wallet_app/employee/EmpTransactionHistory.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/merchant/MrcTransactionHistory.dart';

//Rest
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Pub.dev Packages
import 'localization/vouchain_localizations.dart';
import 'localization/vouchain_localizations_delegate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:uni_links/uni_links.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
StreamSubscription sub;
Widget _home;

Future<void> main() async {
  print("---------Main----------");
  WidgetsFlutterBinding.ensureInitialized();

  final android = AndroidInitializationSettings('@mipmap/ic_notification');
  final iOS = IOSInitializationSettings();
  final initSettings = InitializationSettings(android: android, iOS: iOS);

  flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: _onSelectNotification);

  await _sortPage();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Color.fromRGBO(44, 97, 241, 1), fontFamily: 'Graphik'),
    localizationsDelegates: [
      const VouchainLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
    //locale: const Locale('it'),
    supportedLocales: [
      // The order of this list matters.
      const Locale('it'),
      const Locale('en'),
    ],
    onGenerateTitle: (context) => VouchainLocalizations.of(context).title,
    home: _home,
  ));
}

Future<void> _sortPage() async {
  _home = Homepage();
  bool link = false;
  dynamic _user = await _sort();

  Uri _initialUri;
  // Attach a listener to the Uri links stream
  sub = getUriLinksStream().listen((Uri uri) {
    link = _sortLink(uri);
  }, onError: (Object err) {
    return;
  });
  // Get the latest Uri
  try {
    _initialUri = await getInitialUri();
    link = _sortLink(_initialUri);
  } on Exception {
    return;
  }

  if (_user != "error" && !link) {
    var profile = (_user is EmployeeDTO) ? "employee" : "merchant";
    switch (_user.accessType) {
      case 'FINGER':
        {
          _home = Fingerprint(user: _user, profile: profile);
          break;
        }
      case 'PIN':
        {
          _home = Pin(profile: profile, user: _user, task: "auth");
          break;
        }
    }
  }
}

bool _sortLink(Uri uri) {
  String _code;
  if (uri != null) {
    switch (uri.path) {
      case "/VouChain/usrResetPass":
        {
          _code = uri.queryParameters.values.first;
          print("CODICE RESET --- $_code");
          _home = PasswordReset(code: _code);
          return true;
        }
      case "/VouChain/employee/empInvitationCode":
        {
          _code = uri.queryParameters.values.first;
          print("CODICE INVITO --- $_code");
          _home = EmpInvitationCode(code: _code);
          return true;
        }
    }
  }
  return false;
}

_sort() async {
  final storage = new FlutterSecureStorage();

  print("SESSIONSTORAGE --- " + (await storage.read(key: "usrId")).toString());
  final usrId = await storage.read(key: "usrId");
  if (usrId != null) {
    final profile = await storage.read(key: "profile");
    print("PROFILE --- " + (await storage.read(key: "profile")).toString());
    dynamic user;
    (profile == "employee")
        ? user = await EmpServices.getEmpProfile(usrId)
        : user = await MrcServices.getMrcProfile(usrId);
    if (user.status == "OK") {
      return user;
    } else {
      return "error";
    }
  }
  return "error";
}

// ignore: missing_return
Future _onSelectNotification(String payload) async {
  final decoded = jsonDecode(payload);
  switch (decoded['notificationType']) {
    case 'download':
      OpenFile.open(decoded['filePath']);
      break;
    case 'confirmTransaction':
      {
        print("EMPLOYEE PASSATO ---- " + decoded['empId'].toString());
        EmployeeDTO emp = await EmpServices.getEmpProfile(decoded['empId']);
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => EmpTransactionHistory(emp: emp)));
        break;
      }
    case 'transactionsUpdate':
      {
        print("MERCHANT PASSATO ---- " + decoded['mrcId'].toString());
        MerchantDTO mrc = await MrcServices.getMrcProfile(decoded['mrcId']);
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => MrcTransactionHistory(mrc: mrc)));
        break;
      }
  }
}
