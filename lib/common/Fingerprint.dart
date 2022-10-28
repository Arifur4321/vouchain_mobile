import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/common/NewPin.dart';
import 'package:vouchain_wallet_app/common/Reconnect.dart';
import 'package:vouchain_wallet_app/common/AccessSettings.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class Fingerprint extends StatefulWidget {
  final user;
  final profile;
  final LocalAuthentication auth = LocalAuthentication();

  Fingerprint({this.user, BuildContext context, this.profile});

  @override
  _FingerprintState createState() => _FingerprintState();

  _authenticate(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: VouchainLocalizations.of(context).touchSensorForAuth,
          useErrorDialogs: true,
          stickyAuth: true);
      //print("AUTH ----" + authenticated.toString());
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void setFingerprintAccess(dynamic user, BuildContext context) async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await _authenticate(context);
      if (authenticated) {
        user.accessType = "FINGER";
        user.pinCode = null;
        dynamic response;
        (user is EmployeeDTO)
            ? response = await EmpServices.modEmpProfile(user, context)
            : response = await MrcServices.modMrcProfile(user, context);
        //final storage = new FlutterSecureStorage();
        //await storage.write(key: "usrId", value: response.usrId);
        //print("SESSIONSTORAGE (Fingerprint)--- " + (await FlutterSecureStorage().read(key: "usrId")).toString());
        /*await storage.write(
          key: "profile",
          value: (user is EmployeeDTO) ? "employee" : "merchant");*/
        return showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).fingerPrintSet,
                  style: TextStyle(fontSize: 52.5.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).okButton,
                        style: TextStyle(fontSize: 40.sp)),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      (response is EmployeeDTO)
                                          ? EmpDashboard(emp: response)
                                          : MrcDashboard(mrc: response)))
                        })
              ]),
        );
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccessSettings(user: user)));
      }
    } else {
      noBiometricsAvailableAlert(context);
    }
  }

  void changeToPin(dynamic user, BuildContext context, String profile) async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await _authenticate(context);
      if (authenticated) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => NewPin(user: user, profile: profile)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccessSettings(user: user)));
      }
    } else {
      noBiometricsAvailableAlert(context);
    }
  }

  void removeFingerprintAccess(dynamic user, BuildContext context) async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await _authenticate(context);
      if (authenticated) {
        final storage = new FlutterSecureStorage();
        user.accessType = null;
        user.pinCode = null;
        dynamic response;
        (user is EmployeeDTO)
            ? response = await EmpServices.modEmpProfile(user, context)
            : response = await MrcServices.modMrcProfile(user, context);
        //print("USER (pin) --- " + response.usrId.toString());
        storage.delete(key: "usrId");
        storage.delete(key: "profile");
        return showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).removedFingerMode,
                  style: TextStyle(fontSize: 52.5.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).okButton,
                        style: TextStyle(fontSize: 40.sp)),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      (response is EmployeeDTO)
                                          ? EmpDashboard(emp: response)
                                          : MrcDashboard(mrc: response)))
                        })
              ]),
        );
      }
    } else {
      noBiometricsAvailableAlert(context);
    }
  }

  noBiometricsAvailableAlert(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (_) => AlertDialog(
          title: Text(VouchainLocalizations.of(context).noBiometricsOnDevice,
              style: TextStyle(fontSize: 52.5.sp)),
          actions: [
            RaisedButton(
                child: Text(VouchainLocalizations.of(context).okButton,
                    style: TextStyle(fontSize: 40.sp)),
                color: colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                onPressed: () => Navigator.pop(context))
          ]),
    );
  }
}

class _FingerprintState extends State<Fingerprint> {
  Future<dynamic> _authenticated;
  dynamic _loginResponse;

  @override
  void initState() {
    super.initState();
    _authenticated = authFingerprint(widget.user, context, widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    /*if (widget.user != null) {
      authFingerprint(widget.user, context, widget.profile);
    }*/
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          utility.background(),
          utility.backgroundTop(),
          FutureBuilder(
              future: _authenticated,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Widget page = Homepage();
                  if (snapshot.data.status == "OK" ||
                      snapshot.data.errorDescription == "session_expired") {
                    page = (widget.user is EmployeeDTO)
                        ? EmpDashboard(emp: _loginResponse)
                        : MrcDashboard(mrc: _loginResponse);
                  } else if (snapshot.data.errorDescription ==
                      "not_corresponding_session") {
                    page = Reconnect(user: _loginResponse);
                  } else {
                    utility.genericErrorAlert(context);
                  }
                  return page;
                }
                return Center(child: CircularProgressIndicator());
              })
        ]),
      ),
    );
  }

  authFingerprint(user, BuildContext context, String profile) async {
    bool canCheckBiometrics = await widget.auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await widget._authenticate(context);
      if (authenticated) {
        // Prende la password memorizzata nello storage per poter fare il login
        final storage = FlutterSecureStorage();
        final password = await storage.read(key: "psw");
        //print("PSW (finger)--- " + password);
        //fa il login

        (profile == "employee")
            ? _loginResponse =
                await EmpServices.authEmployee(user.usrEmail, password, context)
            : _loginResponse = await MrcServices.authMerchant(
                user.usrEmail, password, context);
        //se il login è ok, controlla la sessione
        //print("LOGIN (finger)--- " + loginResponse.status);
        if (_loginResponse.status == 'OK') {
          final sessionResponse =
              await UserServices.verifySession(context, _loginResponse);
          //se la sessione è ok o è presente solo una sessione scaduta, reindirizza l'utente alla sua dashboard
          //se l'errore mostra che c'è una sessione già aperta in un altro dispositivo, reindirizza alla pagina di reconnect
          //altrimenti ritorna un alert di errore
          //print("SESSION (finger)--- " + sessionResponse.status.toString());
          //print("ERROR (finger)--- " + sessionResponse.errorDescription.toString());
          return sessionResponse;
        } else {
          utility.genericErrorAlert(context);
        }

        /* else if (profile == "merchant"){
          MerchantDTO loginResponse =
          await MrcServices.authMerchant(user.usrEmail, password);
          if (loginResponse.status == 'OK') {
            final sessionResponse =
            await UserServices.verifySession(context, loginResponse);
            if (sessionResponse == "OK") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MrcDashboard(mrc: loginResponse)),
              );
            }
          } else {
            utility.genericErrorAlert(context);
          }
        }*/
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }
}
