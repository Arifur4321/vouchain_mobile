import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/common/Homepage.dart';

//DTO
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';

//Pagina di risposta al link per reimpostare la password dopo averla dimenticata
class PasswordReset extends StatefulWidget {
  final String code;

  PasswordReset({Key key, @required this.code}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PasswordResetState();
  }
}

class PasswordResetState extends State<PasswordReset> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  bool _changeButtonPressed = false;
  bool _obscureText = true;
  bool _obscureTextRe = true;
  final _passwordController = TextEditingController();
  final _focusPassword = FocusNode();
  final _rePasswordController = TextEditingController();
  final _focusRePassword = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusPassword.addListener(() {
      setState(() {});
    });
    _focusRePassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _focusPassword.dispose();
    _rePasswordController.dispose();
    _focusRePassword.dispose();
    super.dispose();
  }

//TODO gli occhietti se ridimensionati escono dal field
  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).resetPassword,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      //resizeToAvoidBottomInset: false,
      body: LoadingOverlay(
        isLoading: _changeButtonPressed,
        color: colors.lightGrey,
        opacity: 0.3,
        child: Stack(fit: StackFit.expand, children: [
          utility.background(),
          utility.backgroundTop(),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.only(top: 1.h),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Password
                        Container(
                          padding: EdgeInsets.all(26.5.w),
                          width: (portrait) ? 0.85.sw : 0.85.sh,
                          child: _passwordField(),
                        ),
                        //Ripeti Password
                        Container(
                          padding: EdgeInsets.all(26.5.w),
                          width: (portrait) ? 0.85.sw : 0.85.sh,
                          child: _rePasswordField(),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 50.w),
                          child: RaisedButton(
                            color: colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 42.w, vertical: 28.h),
                            onPressed: (!_changeButtonPressed)
                                ? () {
                                    setState(() {
                                      _changeButtonPressed = true;
                                    });
                                    _submitForm();
                                  }
                                : null,
                            child: Text(
                              VouchainLocalizations.of(context).confirm,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.5.sp, //14
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ])),
            ),
          ),
        ]),
      ),
    );
  }

  void _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      //widget.user.usrPassword = _passwordController.text;
      SimpleDTO response = await UserServices.passwordReset(
          widget.code, _passwordController.text, context);

      if (response.status == 'OK') {
        final storage = FlutterSecureStorage();
        await storage.write(key: "psw", value: _passwordController.text);
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: Text(VouchainLocalizations.of(context).resetPasswordDone,
                    style: TextStyle(fontSize: 52.5.sp)),
                actions: [
                  RaisedButton(
                      child: Text(VouchainLocalizations.of(context).okButton,
                          style: TextStyle(fontSize: 40.sp)),
                      color: colors.blue,
                      onPressed: () => {
                            Navigator.pop(context),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()))
                          })
                ]),
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: Text(VouchainLocalizations.of(context).error,
                    style: TextStyle(fontSize: 52.5.sp)),
                content: Text(
                    VouchainLocalizations.of(context).passwordResetError,
                    style: TextStyle(fontSize: 40.sp)),
                actions: [
                  FlatButton(
                      child: Text(VouchainLocalizations.of(context).okButton,
                          style: TextStyle(fontSize: 40.sp)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 42.w, vertical: 28.h),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homepage()));
                      })
                ]),
          ),
        );
      }
    }
    setState(() {
      _changeButtonPressed = false;
    });
  }

  _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      focusNode: _focusPassword,
      validator: (value) => utility.validPasswordWithExplanation(_passwordController.text, _rePasswordController.text, context),
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_focusRePassword),
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
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
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.lock, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).newPassword,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _rePasswordField() {
    return TextFormField(
      controller: _rePasswordController,
      obscureText: _obscureTextRe,
      focusNode: _focusRePassword,
      validator: (value) => utility.validReEnterPassword(
          _passwordController.text, _rePasswordController.text, context),
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        suffixIcon: (_focusRePassword.hasFocus)
            ? IconButton(
                icon: (_obscureTextRe)
                    ? Icon(Icons.remove_red_eye)
                    : Image.asset(
                        'assets/images/icon_psw_invisible.png',
                        color: colors.blue,
                        scale: 1.4,
                      ),
                onPressed: () => setState(() {
                  _obscureTextRe = !_obscureTextRe;
                }),
              )
            : null,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.lock, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).repeatPassword,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }
}
