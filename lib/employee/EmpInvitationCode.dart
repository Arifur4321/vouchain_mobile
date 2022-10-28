import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/employee/EmpSignup.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EmpInvitationCode extends StatefulWidget {
  final code;

  const EmpInvitationCode({Key key, this.code}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmpInvitationCodeState();
  }
}

class EmpInvitationCodeState extends State<EmpInvitationCode> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  bool _sendButtonPressed = false;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    if (widget.code != null) {
      _codeController.text = widget.code;
    }
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).vouchain,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: LoadingOverlay(
          isLoading: _sendButtonPressed,
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
                        VouchainLocalizations.of(context).invitationCodeText,
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
                          controller: _codeController,
                          validator: (value) => _notEmpty(value),
                          style: TextStyle(fontSize: 45.sp),
                          decoration: InputDecoration(
                            hintText: VouchainLocalizations.of(context)
                                .invitationCodeText,
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
                        onPressed: (!_sendButtonPressed)
                            ? () {
                                setState(() {
                                  _sendButtonPressed = true;
                                });
                                _submitForm(_codeController);
                              }
                            : null,
                        child: Text(
                          VouchainLocalizations.of(context).applyText,
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
      return VouchainLocalizations.of(context).insertInvitationCode;
    }
  }

  void _submitForm(TextEditingController codeController) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      print('INVITATION CODE ----- ' + codeController.text);
      EmployeeDTO response =
          await EmpServices.checkInvitationCode(codeController.text, context);
      if (response.status == 'OK') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmpSignup(emp: response)),
        );
      } else if (response.errorDescription == "no_user_found") {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).error,
                  style: TextStyle(fontSize: 52.5.sp)),
              content: Text(VouchainLocalizations.of(context).invalidCode,
                  style: TextStyle(fontSize: 40.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).okButton,style: TextStyle(fontSize: 36.5.sp)),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {Navigator.pop(context)})
              ]),
        );
      } else {
        utility.genericErrorAlert(context);
      }
    }
    setState(() {
      _sendButtonPressed = false;
    });
  }
}
