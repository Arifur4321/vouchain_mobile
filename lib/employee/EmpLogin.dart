import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/common/PasswordRecovery.dart';
import 'package:vouchain_wallet_app/common/Reconnect.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';
import 'package:vouchain_wallet_app/employee/EmpInvitationCode.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EmpLogin extends StatefulWidget {
  final bool expired;

  const EmpLogin({Key key, this.expired}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmpLoginState();
  }
}

class EmpLoginState extends State<EmpLogin> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusPassword = FocusNode();
  bool _loginButtonPressed = false;
  bool _obscureText = true;
  bool _formSubmmitted = false;

  @override
  void initState() {
    super.initState();
    _focusPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    // Build a Form widget using the _formKey created above.
    return WillPopScope(
      onWillPop: () async {
        print("BOOLEAN LOGIN --- " + widget.expired.toString());
        if (widget.expired != null) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 157.5.h,
            title: Text(VouchainLocalizations.of(context).vouchain,
                style: TextStyle(fontSize: 52.5.sp)),
          ),
          body: LoadingOverlay(
            isLoading: _loginButtonPressed,
            color: colors.lightGrey,
            opacity: 0.3,
            child: Stack(fit: StackFit.expand, children: <Widget>[
              utility.background(),
              utility.backgroundTop(),
              SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    //autovalidate: true,//(!formSubmmitted),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                //padding: EdgeInsets.only(top: (portrait) ? 365.h:180.h), //130
                                child: new Image(
                              image: AssetImage("assets/images/emp_icon.png"),
                              width: 220.w, //80
                            )),
                            Container(
                              color: Colors.white,
                              width: (portrait) ? 0.725.sw : 0.725.sh, //300
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) => _notEmpty(value),
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_focusPassword),
                                style: TextStyle(fontSize: 42.sp),
                                //16
                                decoration: InputDecoration(
                                    labelText:
                                        VouchainLocalizations.of(context).email,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colors.blue)),
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.w),
                                      child: Icon(
                                        Icons.email,
                                        size: 64.w, //24
                                        color: colors.blue,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 55.h, //20
                            ),
                            Container(
                              color: Colors.white,
                              width: (portrait) ? 0.725.sw : 0.725.sh,
                              child: TextFormField(
                                obscureText: _obscureText,
                                controller: _passwordController,
                                validator: (value) => _passwordValidator(
                                    _passwordController.text, context),
                                onFieldSubmitted: (_) =>
                                    _formKey.currentState.validate(),
                                focusNode: _focusPassword,
                                style: TextStyle(fontSize: 42.sp),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 32.sp),
                                  suffixIcon: (_focusPassword.hasFocus)
                                      ? IconButton(
                                          icon: (_obscureText)
                                              ? Icon(Icons.remove_red_eye)
                                              : Image.asset(
                                                  'assets/images/icon_psw_invisible.png',
                                                  color: colors.blue,
                                                  scale: 1.4,
                                                ),
                                          onPressed: () => setState(() {
                                            _obscureText = !_obscureText;
                                          }),
                                        )
                                      : null,
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25.w),
                                    child: Icon(
                                      Icons.lock,
                                      size: 64.w,
                                      color: colors.blue,
                                    ),
                                  ),
                                  labelText: VouchainLocalizations.of(context)
                                      .password,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colors.blue)),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 55.h),
                            RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60.w, vertical: 28.h),
                                color: colors.blue,
                                disabledColor: colors.blue,
                                onPressed: (!_loginButtonPressed)
                                    ? () {
                                        setState(() {
                                          _loginButtonPressed = true;
                                        });
                                        _submitForm(_emailController,
                                            _passwordController);
                                      }
                                    : null,
                                child: Text(
                                  VouchainLocalizations.of(context).login,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36.5.sp, //14
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 43.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  VouchainLocalizations.of(context)
                                          .invitationText +
                                      ' ',
                                  style: TextStyle(
                                      fontSize: 36.5.sp,
                                      color: Colors.blueGrey),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmpInvitationCode()),
                                  ),
                                  child: Text(
                                    VouchainLocalizations.of(context).signup,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.blue,
                                        fontSize: 36.5.sp,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 28.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  VouchainLocalizations.of(context).forgotThe,
                                  style: TextStyle(
                                      fontSize: 36.5.sp,
                                      color: Colors.blueGrey),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PasswordRecovery(
                                            profile: "employee")),
                                  ),
                                  child: Text(
                                    VouchainLocalizations.of(context).password +
                                        "?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36.5.sp,
                                        color: colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 200.h),
                          ]),
                    )),
              ),
            ]),
          )),
    );
  }

  _notEmpty(String value) {
    if (!_formSubmmitted) {
      if (value.isEmpty) {
        //formSubmmitted = false;
        return VouchainLocalizations.of(context).invalidEmail;
      }
    } else {
      return "";
    }
  }

  _passwordValidator(String password, BuildContext context) {
    if (!_formSubmmitted) {
      //formSubmmitted = false;
      return utility.validPassword(password, context);
    } else {
      _formSubmmitted = false;
      return VouchainLocalizations.of(context).invalidEmailOrPassword;
    }
  }

  void _submitForm(TextEditingController emailController,
      TextEditingController passwordController) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      _formSubmmitted = true;
      EmployeeDTO response = await EmpServices.authEmployee(
          emailController.text, passwordController.text, context);

      if (response.status == 'OK') {
        //formSubmmitted = false,
        final storage = FlutterSecureStorage();
        await storage.write(key: "psw", value: passwordController.text);
        await storage.write(key: "usrId", value: response.usrId);
        await storage.write(key: "profile", value: "employee");
        final SimpleDTO sessionResponse =
            await UserServices.verifySession(context, response);
        if (sessionResponse.status == "OK" ||
            sessionResponse.errorDescription == "session_expired") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EmpDashboard(emp: response)),
          );
        } else if (sessionResponse.errorDescription ==
            "not_corresponding_session") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Reconnect(user: response)),
          );
        }
      } else if (response.errorDescription == 'no_user_found') {
        //Password o email non corretta
        _formKey.currentState.validate();
      } else if (response.errorDescription == 'user_not_active') {
        utility.genericErrorAlert(context,
            msg: VouchainLocalizations.of(context).userNotActive);
      } else {
        _formSubmmitted = false;
        utility.genericErrorAlert(context);
      }
    }
    setState(() {
      _loginButtonPressed = false;
    });
  }
}
