import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';

//DTO
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';

class NewPin extends StatefulWidget {
  final user;
  final String profile;

  NewPin({Key key, this.user, this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NewPinState(user: user, profile: profile);
  }
}

class NewPinState extends State<NewPin> {
  final user;
  final String profile;
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _focusPin = FocusNode();
  final _rePinController = TextEditingController();
  final _focusRePin = FocusNode();

  bool _obscureTextPin = true;
  bool _obscureTextRePin = true;

  bool _confirmButtonPressed = false;

  NewPinState({this.user, this.profile});

  bool formSubmmitted = false;

  @override
  void initState() {
    super.initState();
    _focusPin.addListener(() {
      setState(() {});
    });
    _focusRePin.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pinController.dispose();
    _focusPin.dispose();
    _rePinController.dispose();
    _focusRePin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    // Build a Form widget using the _formKey created above.
    print("PROFILE (NewPin(1)) ---- $profile");
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).vouchain,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: LoadingOverlay(
          isLoading: _confirmButtonPressed,
          color: colors.lightGrey,
          opacity: 0.3,
          child: Stack(fit: StackFit.expand, children: <Widget>[
            utility.background(),
            SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                top: (portrait) ? 400.h : 170.w),
                            child: Text(
                              "Inserire un PIN di 6 cifre",
                              style: TextStyle(
                                  fontSize: 50.sp, fontWeight: FontWeight.w500),
                            )),
                        SizedBox(height: 55.h),
                        Container(
                          padding:
                              EdgeInsets.only(top: (portrait) ? 28.h : 20.w),
                          //(portrait) ? 200 : 70),
                          color: Colors.white,
                          width: (portrait) ? 0.49.sw : 0.49.sh,
                          child: TextFormField(
                            controller: _pinController,
                            focusNode: _focusPin,
                            obscureText: _obscureTextPin,
                            validator: (value) => _pinValidator(value),
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_focusRePin),
                            style: TextStyle(fontSize: 42.sp),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText:
                                    VouchainLocalizations.of(context).pinAccess,
                                errorStyle: TextStyle(fontSize: 32.4.sp),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colors.blue)),
                                border: OutlineInputBorder(),
                                suffixIcon: (_focusPin.hasFocus)
                                    ? IconButton(
                                        icon: (_obscureTextPin)
                                            ? Icon(Icons.remove_red_eye)
                                            : Image.asset(
                                                'assets/images/icon_psw_invisible.png',
                                                color: colors.blue,
                                                scale: 1.4,
                                              ),
                                        onPressed: () => setState(() {
                                          _obscureTextPin = !_obscureTextPin;
                                        }),
                                      )
                                    : null,
                                prefixIcon: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Icon(
                                    Icons.lock,
                                    size: 63.w,
                                    color: colors.blue,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(height: 55.h),
                        Container(
                          color: Colors.white,
                          width: (portrait) ? 0.49.sw : 0.49.sh,
                          child: TextFormField(
                            controller: _rePinController,
                            focusNode: _focusRePin,
                            obscureText: _obscureTextRePin,
                            style: TextStyle(fontSize: 42.sp),
                            validator: (value) =>
                                _rePinValidator(value, _pinController),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText:
                                    VouchainLocalizations.of(context).repeatPin,
                                errorStyle: TextStyle(fontSize: 32.4.sp),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colors.blue)),
                                border: OutlineInputBorder(),
                                suffixIcon: (_focusRePin.hasFocus)
                                    ? IconButton(
                                        icon: (_obscureTextRePin)
                                            ? Icon(Icons.remove_red_eye)
                                            : Image.asset(
                                                'assets/images/icon_psw_invisible.png',
                                                color: colors.blue,
                                                scale: 1.4,
                                              ),
                                        onPressed: () => setState(() {
                                          _obscureTextRePin =
                                              !_obscureTextRePin;
                                        }),
                                      )
                                    : null,
                                prefixIcon: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Icon(
                                    Icons.lock,
                                    size: 63.w,
                                    color: colors.blue,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(height: 55.h),
                        RaisedButton(
                          color: colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 42.w, vertical: 28.h),
                          onPressed: (!_confirmButtonPressed)
                              ? () {
                                  setState(() {
                                    _confirmButtonPressed = true;
                                  });
                                  _submitForm(_pinController, _rePinController);
                                }
                              : null,
                          child: Text(
                            "Conferma",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.5.sp, //14
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 40),
                      ])),
            ),
          ]),
        ));
  }

  _pinValidator(String value) {
    if (!formSubmmitted) {
      if (value.isEmpty) {
        //formSubmmitted = false;
        return "Inserire il PIN";
      }
      if (value.length != 6) {
        return "Il PIN deve essere di 6 cifre";
      }
    } else {
      return "PIN errato, riprovare";
    }
  }

  _rePinValidator(String value, TextEditingController pinController) {
    if (!formSubmmitted) {
      if (value.isEmpty) {
        return "Confermare il PIN";
      }
      if (value != pinController.text) {
        return "I PIN devono corrispondere";
      }
    } else {
      formSubmmitted = false;
      return "PIN errato, riprovare";
    }
  }

  void _submitForm(TextEditingController pinController,
      TextEditingController rePinController) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      formSubmmitted = true;
      user.accessType = "PIN";
      user.pinCode = pinController.text;
      dynamic response;
      print("PROFILO (NewPin) ---- $profile");
      (profile == "employee")
          ? response = await EmpServices.modEmpProfile(user, context)
          : response = await MrcServices.modMrcProfile(user, context);
      //final storage = FlutterSecureStorage();
      //await storage.write(key: "usrId", value: response.usrId);
      print("SESSIONSTORAGE (NewPIN)--- " +
          (await FlutterSecureStorage().read(key: "usrId")).toString());
      /*await storage.write(
          key: "profile",
          value: (user is EmployeeDTO) ? "employee" : "merchant");*/
      return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            title: Text(
              VouchainLocalizations.of(context).pinSet,
              style: TextStyle(fontSize: 40.sp),
            ),
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
                                builder: (context) => (profile == "employee")
                                    ? EmpDashboard(emp: response)
                                    : MrcDashboard(
                                        mrc: response,
                                      )))
                      })
            ]),
      );
    }
    setState(() {
      _confirmButtonPressed = false;
    });
  }
}
