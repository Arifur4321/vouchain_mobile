import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/common/Homepage.dart';

//DTO
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';

//rest
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev packages
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Pagina in cui inserire la mail per recuperare la password dimenticata
class PasswordRecovery extends StatefulWidget {
  final String profile;

  PasswordRecovery({Key key, @required this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PasswordRecoveryState();
  }
}

class PasswordRecoveryState extends State<PasswordRecovery> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  final _mailController = TextEditingController();
  bool _confirmButtonPressed = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        resizeToAvoidBottomPadding: false,
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
            utility.backgroundTop(),
            Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        VouchainLocalizations.of(context).passwordRecovery,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 52.5.sp,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 57.h,
                      ),
                      Container(
                        width: 660.w,
                        child: TextFormField(
                          controller: _mailController,
                          validator: (value) => _notEmpty(value),
                          decoration: InputDecoration(
                            hintText:
                                VouchainLocalizations.of(context).enterEmail,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      RaisedButton(
                        color: colors.blue,
                        padding: EdgeInsets.symmetric(
                            horizontal: 42.w, vertical: 28.h),
                        onPressed: (!_confirmButtonPressed)
                            ? () {
                                setState(() {
                                  _confirmButtonPressed = true;
                                });
                                _submitForm();
                              }
                            : null,
                        child: Text(
                          VouchainLocalizations.of(context).confirm,
                          style: TextStyle(
                              fontSize: 36.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]))
          ]),
        ));
  }

  _notEmpty(String value) {
    if (value.isEmpty) {
      return VouchainLocalizations.of(context).enterEmail;
    }
  }

  void _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      SimpleDTO response = await UserServices.passwordRecovery(
          _mailController.text, widget.profile, context);
      if (response.status == 'OK') {
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(
                VouchainLocalizations.of(context).passwordRestored,
                style: TextStyle(fontSize: 52.5.sp),
              ),
              content: Text(VouchainLocalizations.of(context).mailSent,
                  style: TextStyle(fontSize: 40.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).homepage, style: TextStyle(fontSize: 40.sp)),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()))
                        })
              ]),
        );
      } else {
        utility.genericErrorAlert(context);
      }

    }
    setState(() {
      _confirmButtonPressed = false;
    });
  }
}
