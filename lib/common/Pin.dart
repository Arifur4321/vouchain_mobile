import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vouchain_wallet_app/common/Fingerprint.dart';
import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/common/Reconnect.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Pin extends StatefulWidget {
  final user;
  final String profile;
  final String task;

  Pin(
      {Key key,
      @required this.user,
      @required this.profile,
      @required this.task})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinState(user: user, profile: profile, task: task);
  }
}

class PinState extends State<Pin> {
  final user;
  final String profile;
  final String task;
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();

  bool _loginButtonPressed = false;
  bool _logoutButtonPressed = false;

  PinState({this.user, this.profile, this.task});

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    bool portrait = utility.orientation(context);
    return WillPopScope(
      onWillPop: (task == "auth") ? () async => false : null,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 157.5.h,
            title: Text(
              VouchainLocalizations.of(context).vouchain,
              style: TextStyle(fontSize: 52.5.sp),
            ),
          ),
          body: LoadingOverlay(
            isLoading: _loginButtonPressed || _logoutButtonPressed,
            color: colors.lightGrey,
            opacity: 0.3,
            child: Stack(fit: StackFit.expand, children: <Widget>[
              utility.background(),
              ListView(
                children: [
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: (portrait) ? 225.h : 65.w,
                          bottom: (portrait) ? 150.h : 75.w),
                      child: Image(
                        height: (portrait) ? 0.2.sh : 0.17.sw, //130-no,
                        image: AssetImage(
                            "assets/images/vouchain_logo_vert_blugrigio.png"),
                      ),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              width: (portrait) ? 0.49.sw : 0.49.sh,
                              child: TextFormField(
                                obscureText: true,
                                controller: _pinController,
                                validator: (value) => _pinValidator(value),
                                style: TextStyle(fontSize: 42.sp),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: VouchainLocalizations.of(context)
                                        .pinAccess,
                                    errorStyle: TextStyle(fontSize: 32.4.sp),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colors.blue)),
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.w),
                                      child: Icon(
                                        Icons.lock,
                                        size: 64.w,
                                        color: colors.blue,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(height: 58.h),
                            RaisedButton(
                              color: colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.w, vertical: 28.h),
                              onPressed: (!_loginButtonPressed)
                                  ? () {
                                      setState(() {
                                        _loginButtonPressed = true;
                                      });
                                      _sort();
                                    }
                                  : null,
                              child: Text(
                                (task == "auth")
                                    ? VouchainLocalizations.of(context).login
                                    : VouchainLocalizations.of(context).confirm,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36.5.sp, //14
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 55.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  VouchainLocalizations.of(context)
                                      .forgottenPin,
                                  style: TextStyle(
                                      fontSize: 36.5.sp,
                                      color: Colors.blueGrey),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _logoutButtonPressed = true;
                                    });
                                    await UserServices.logout(context, user);
                                    setState(() {
                                      _loginButtonPressed = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage()));
                                  },
                                  child: Text(
                                    VouchainLocalizations.of(context).logout,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.blue,
                                        fontSize: 36.5.sp,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 750.h),
                          ])),
                ],
              ),
            ]),
          )),
    );
  }

//controlla se il pin digitato è valido e corrisponde a quello memorizzato nell'utente
  _pinValidator(String value) {
    if (value.isEmpty) {
      return VouchainLocalizations.of(context).insertPin;
    }
    if (user.pinCode != value) {
      return VouchainLocalizations.of(context).wrongPin;
    }
  }

  _sort() {
    switch (task) {
      case "auth":
        _submitAuthUser();
        break;
      case "fingerprint":
        _submitChange();
        break;
      case "delete":
        _submitDelete();
    }
  }

  void _submitAuthUser() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      // Prende la password memorizzata nello storage per poter fare il login
      final storage = FlutterSecureStorage();
      final password = await storage.read(key: "psw");
      print("PSW (pin)--- " + password);
      //fa il login
      dynamic loginResponse = (user is EmployeeDTO)
          ? await EmpServices.authEmployee(user.usrEmail, password, context)
          : await MrcServices.authMerchant(user.usrEmail, password, context);
      //se il login è ok, controlla la sessione
      print("LOGIN (pin)--- " + loginResponse.status);
      if (loginResponse.status == 'OK') {
        final sessionResponse =
            await UserServices.verifySession(context, loginResponse);
        //se la sessione è ok o è presente solo una sessione scaduta, reindirizza l'utente alla sua dashboard
        //se l'errore mostra che c'è una sessione già aperta in un altro dispositivo, reindirizza alla pagina di reconnect
        //altrimenti ritorna un alert di errore
        print("SESSION (pin)--- " + sessionResponse.status.toString());
        print("ERROR (pin)--- " + sessionResponse.errorDescription.toString());
        if (sessionResponse.status == "OK" ||
            sessionResponse.errorDescription == "session_expired") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (user is EmployeeDTO)
                    ? EmpDashboard(emp: loginResponse)
                    : MrcDashboard(mrc: loginResponse)),
          );
        } else if (sessionResponse.errorDescription ==
            "not_corresponding_session") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Reconnect(user: loginResponse)),
          );
        } else {
          utility.genericErrorAlert(context);
        }
      } else {
        utility.genericErrorAlert(context);
      }
    }
    setState(() {
      _loginButtonPressed = false;
    });
  }

  void _submitChange() {
    if (_formKey.currentState.validate()) {
      Fingerprint().setFingerprintAccess(user, context);
    }
    setState(() {
      _loginButtonPressed = false;
    });
  }

  void _submitDelete() async {
    if (_formKey.currentState.validate()) {
      final storage = FlutterSecureStorage();
      user.accessType = null;
      user.pinCode = null;
      dynamic response = (user is EmployeeDTO)
          ? await EmpServices.modEmpProfile(user, context)
          : await MrcServices.modMrcProfile(user, context);
      print("USER (pin) --- " + response.usrId.toString());
      storage.delete(key: "usrId");
      storage.delete(key: "profile");
      return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            title: Text(VouchainLocalizations.of(context).pinRemoved,
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
                                builder: (context) => (user is EmployeeDTO)
                                    ? EmpDashboard(emp: response)
                                    : MrcDashboard(mrc: user)))
                      })
            ]),
      );
    }
    setState(() {
      _loginButtonPressed = false;
    });
  }
}
