import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vouchain_wallet_app/main.dart';
import 'package:vouchain_wallet_app/employee/EmpLogin.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';
import 'package:vouchain_wallet_app/merchant/MrcLogin.dart';
import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/common/Fingerprint.dart';
import 'package:vouchain_wallet_app/common/Pin.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';

//Rest
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_session/flutter_session.dart';

const VERSION = '1.2.7';
const MAX_SIZE = 5000;
const Duration NOTIFICATION_INTERVAL = Duration(minutes: 3);

// ----- VALIDATORS -----
validPassword(String password, BuildContext context) {
  RegExp _regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\S]{8,}$');
  if (password.isEmpty) {
    return VouchainLocalizations.of(context).insertPassword;
  }
  if (!_regex.hasMatch(password)) {
    return VouchainLocalizations.of(context).invalidPassword;
  }
  return null;
}

validPasswordWithExplanation(
    String password, String rePassword, BuildContext context) {
  RegExp _regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\S]{8,}$');
  if (password.isEmpty) {
    return VouchainLocalizations.of(context).insertPassword;
  }
  if (!_regex.hasMatch(rePassword) && rePassword == password) {
    return "";
  }
  if (!_regex.hasMatch(password)) {
    return VouchainLocalizations.of(context).invalidPasswordExplanation;
  }
  return null;
}

validReEnterPassword(String password, String rePassword, BuildContext context) {
  RegExp _regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\S]{8,}$');
  if (rePassword.isEmpty) {
    return VouchainLocalizations.of(context).insertPassword;
  }
  if (!_regex.hasMatch(rePassword) && rePassword == password) {
    return VouchainLocalizations.of(context).invalidPasswordExplanation;
  }
  if (password != rePassword) {
    return VouchainLocalizations.of(context).passwordMustCoincide;
  }
  return null;
}

// ----- BACKGROUNDS -----
background() {
  return Positioned(
    bottom: 0,
    child: Image(
      image: AssetImage("assets/images/vouchain_bg_bottom.png"),
      alignment: Alignment.bottomLeft,
      height: 510.h, //180
      //width: 600//600,
    ),
  );
}

backgroundTop() {
  return Positioned(
    top: 0,
    right: 0,
    child: Image(
      image: AssetImage("assets/images/vouchain_bg_top.png"),
      alignment: Alignment.topRight,
      height: 510.h, //180
      //width: 600,
    ),
  );
}

// ----- RESPONSIVE -----
orientation(context) {
  bool portrait = (MediaQuery.of(context).orientation == Orientation.portrait);
  (portrait)
      ? ScreenUtil.init(context,
          designSize: Size(1080, 1920), allowFontScaling: false)
      : ScreenUtil.init(context,
          designSize: Size(1920, 1080), allowFontScaling: false);
  return portrait;
}

// ----- SESSION -----
//Genera il token per la sessione
String generateAlphaNumericString() {
  int count = 32;
  const ALPHA_NUMERIC_STRING = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  String builder = '';
  while (count-- != 0) {
    int random = Random().nextInt(ALPHA_NUMERIC_STRING.length);
    builder += ALPHA_NUMERIC_STRING[random];
  }
  return builder;
}

//Inoltra l'utente alla corretta schermata di accesso a sessione scaduta
sortAccessType(BuildContext context, dynamic user) {
  print("---------Sort Access Type----------");
  switch (user.accessType.toString()) {
    case "null":
      {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (user is EmployeeDTO)
                  ? EmpLogin(expired: true)
                  : MrcLogin(expired: true)),
        );
        break;
      }
    case "PIN":
      {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Pin(
                  profile: (user is EmployeeDTO) ? "employee" : "merchant",
                  user: user,
                  task: "auth")),
        );
        break;
      }
    case "FINGER":
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Fingerprint(
                    user: user,
                    context: context,
                    profile: (user is EmployeeDTO) ? "employee" : "merchant")));
        break;
      }
  }
}

//// ----- NOTIFICATION -----
//Utilizza il servizio per mostrare le notifiche
Future<void> showNotification(
    Map<String, dynamic> payload, int id, String title, String body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'vouchain', 'vouchain', 'vouchain',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
    color: colors.blue,
    styleInformation: BigTextStyleInformation(''),
    //largeIcon: const DrawableResourceAndroidBitmap('ic_notification')
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id, title, body, platformChannelSpecifics,
      payload: jsonEncode(payload));
}

//Fa partire il timer per l'aggiornamento delle transazioni
void timedNotification(MerchantDTO mrc, BuildContext context) async {
  var session = FlutterSession();
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  DTOList<dynamic> initTransList =
      await MrcServices.mrcCheckUpdateTransactionList(
          today, today, mrc, context);
  int lastId;
  if (initTransList.status == "OK" &&
      initTransList.list != null &&
      initTransList.list.isNotEmpty) {
    lastId = int.parse(initTransList.list[0]?.trcId);
  } else {
    lastId = 0;
  }
  await session.set("lastTransactionId", lastId);
  int notificationId = 1;
  print("LAST ID FUORI DAL PERIODIC --- " +
      (await session.get("lastTransactionId")).toString());

  //Avvio il timer per il controllo delle transazioni
  timer = Timer.periodic(NOTIFICATION_INTERVAL, (timer) async {
    //Controllo che l'utente sia in sessione senza refreshare la sessione
    SimpleDTO sessionResponse = await UserServices.checkSession(context, mrc);
    if (sessionResponse.status == "OK") {
      //Mi faccio inviare le transazioni dell'ultima giornata
      DTOList transList = await MrcServices.mrcCheckUpdateTransactionList(
          today, today, mrc, context);
      print("LISTA --- " + transList.list.toString());
      if (transList.status == "OK" &&
          transList.list != null &&
          transList.list.isNotEmpty) {
        int newId = int.parse(transList.list[0]?.trcId);
        print("NEWID ----- " + newId.toString());
        if (newId != null) {
          lastId = await session.get("lastTransactionId");
          print("LASTID ---- " + lastId.toString());
          if (newId > lastId) {
            print("Sono entrato nel confronto");
            Map<String, dynamic> payload = {
              'notificationType': "transactionsUpdate",
              'mrcId': mrc.usrId
            };
            Map<String, String> notificationTexts =
                _chooseTexts(lastId, transList.list, context);
            showNotification(payload, notificationId,
                notificationTexts["title"], notificationTexts["body"]);
            notificationId++;
          }
          if (newId != lastId) {
            await session.set("lastTransactionId", newId);
            print("il nuovo id memorizzato nella sessione è " +
                (await session.get("lastTransactionId")).toString());
          }
        }
      } else {
        print("Setto l'id a 0");
        await session.set("lastTransactionId", 0);
      }
    } else {
      timer.cancel();
    }
  });
}

//Sceglie che messaggio inserire nella notifica di una o più nuove transazioni
Map<String, String> _chooseTexts(
    int lastId, List<dynamic> list, BuildContext context) {
  Map<String, String> texts = Map();
  texts["title"] = "Vouchain app";
  texts["body"] = "";
  int i = 0;
  while (i < list.length && lastId < int.parse(list[i].trcId)) {
    i++;
  }
  if (i == 1) {
    texts["title"] = VouchainLocalizations.of(context).transactionReceived;
    texts["body"] = NumberFormat.currency(
                locale: "eu", symbol: "€", name: "EUR", decimalDigits: 2)
            .format(double.parse(list[0].trcValue)) +
        " da " +
        list[0].usrIdDaString +
        "\n" +
        VouchainLocalizations.of(context).openApp;
  }
  if (i > 1) {
    texts["title"] = VouchainLocalizations.of(context).received +
        "$i " +
        VouchainLocalizations.of(context).transaction(2).toLowerCase();
    texts["body"] = VouchainLocalizations.of(context).openApp;
  }
  return texts;
}

//Permette di aprire la prima applicazione di mappe presente sul telefono
openMaps(dynamic mrc) async {
  final availableMaps = await MapLauncher.installedMaps;
  await availableMaps.first.showDirections(
      destination: Coords(
          double.parse(mrc.mrcLatitude), double.parse(mrc.mrcLongitude)));
}

// ----- Messaggi -----
//Dialog errori generici (con stringa per messaggi più precisi)
genericErrorAlert(BuildContext context, {String msg}) {
  //print("CONTEXT --- "+context.widget.toString());
  //print("WIDGET --- "+widget.toString());
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) => AlertDialog(
        title: Text(VouchainLocalizations.of(context).error,
            style: TextStyle(fontSize: 52.5.sp)),
        content: Text(
            msg ?? VouchainLocalizations.of(context).generalErrorRetry,
            style: TextStyle(fontSize: 40.sp)),
        actions: [
          FlatButton(
              child: Text(VouchainLocalizations.of(context).okButton,
                  style: TextStyle(fontSize: 40.sp)),
              padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]),
  );
}

//Dialog conferma logout
logoutAlert(BuildContext context, dynamic user) {
  Future<dynamic> session = UserServices.logout(context, user);
  Text text;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        title: Text(VouchainLocalizations.of(context).logout,
            style: TextStyle(fontSize: 52.5.sp)),
        children: [
          Container(
            height: 0.15.sh,
            width: 0.7.sw,
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: FutureBuilder(
              future: session,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "OK") {
                    text = Text(
                      VouchainLocalizations.of(context).logoutSuccesful,
                      style: TextStyle(fontSize: 45.sp),
                    );
                  } else {
                    text = Text(
                        VouchainLocalizations.of(context).generalErrorRetry,
                        style: TextStyle(fontSize: 45.sp));
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text,
                      RaisedButton(
                          color: colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 28.w, vertical: 28.h),
                          child: Text(
                              VouchainLocalizations.of(context).okButton,
                              style: TextStyle(
                                  fontSize: 40.sp, color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (snapshot.data == "OK")
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                              );
                          }),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return genericErrorAlert(context);
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    ),
  );
}

//          content: Text(
//             VouchainLocalizations.of(context).logoutSuccesful,
//             style: TextStyle(fontSize: 52.5.sp),
//           ),
//           actions: [
//             FlatButton(
//                 padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
//                 child: Text(VouchainLocalizations.of(context).okButton,
//                     style: TextStyle(fontSize: 40.sp)),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => Homepage()),
//                   );
//                 }),
//           ]
