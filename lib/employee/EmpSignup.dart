import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmpSignup extends StatefulWidget {
  final EmployeeDTO emp;

  EmpSignup({Key key, @required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmpSignupState();
  }
}

class EmpSignupState extends State<EmpSignup> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  bool _signupButtonPressed = false;
  bool _obscureText = true;
  bool _obscureTextRe = true;
  final _mailController = TextEditingController();
  final _matController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _focusPassword = FocusNode();
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
    // Clean up the controller when the widget is disposed.
    _mailController.dispose();
    _matController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _focusPassword.dispose();
    _focusRePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    _mailController.text = widget.emp.usrEmail;
    _matController.text = widget.emp.empMatricola;
    _firstNameController.text = widget.emp.empFirstName;
    _lastNameController.text = widget.emp.empLastName;

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).vouchain,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      body: LoadingOverlay(
        isLoading: _signupButtonPressed,
        color: colors.lightGrey,
        opacity: 0.3,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: (portrait)
                  ? Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 0.05.sh),
                          //Email
                          Container(
                            width: 915.w,
                            padding: EdgeInsets.all(23.w),
                            child: _mailField(),
                          ),
                          //Matricola
                          Container(
                            padding: EdgeInsets.all(23.w),
                            width: 915.w,
                            child: _matfield(),
                          ),
                          //Nome
                          Container(
                            width: 915.w,
                            padding: EdgeInsets.all(23.w),
                            child: _firstNameField(),
                          ),
                          //Cognome
                          Container(
                            width: 915.w,
                            padding: EdgeInsets.all(23.w),
                            child: _lastNameField(),
                          ),
                          //Password
                          Container(
                            padding: EdgeInsets.all(23.w),
                            width: 915.w,
                            child: _passwordField(),
                          ),
                          //Ripeti Password
                          Container(
                            width: 915.w,
                            padding: EdgeInsets.all(23.w),
                            child: _rePasswordField(),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 95.h),
                            child: _termsAndConditionsTile(),
                          ),
                          RaisedButton(
                            color: colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 28.h),
                            onPressed: (!_signupButtonPressed)
                                ? () {
                                    setState(() {
                                      _signupButtonPressed = true;
                                    });
                                    _submitForm();
                                  }
                                : null,
                            child: Text(
                              VouchainLocalizations.of(context).signup,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36.5.sp),
                            ),
                          ),
                          SizedBox(height: 0.4.sh)
                        ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.03.sw),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 50.h, right: 25.h, top: 46.w),
                                  child: _mailField()),
                            ),
                            Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 30.h, right: 48.h, top: 46.w),
                                  child: _matfield(),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 50.h, right: 25.h, top: 46.w),
                                  child: _firstNameField(),
                                )),
                            Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 30.h, right: 48.h, top: 46.w),
                                  child: _lastNameField(),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 50.h, right: 25.h, top: 46.w),
                                  child: _passwordField(),
                                )),
                            Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 30.h, right: 48.h, top: 46.w),
                                  child: _rePasswordField(),
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 470.h),
                          child: _termsAndConditionsTile(),
                        ),
                        RaisedButton(
                          color: colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 28.h),
                          onPressed: (!_signupButtonPressed)
                              ? () {
                                  setState(() {
                                    _signupButtonPressed = true;
                                  });
                                  _submitForm();
                                }
                              : null,
                          child: Text(
                            VouchainLocalizations.of(context).signup,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 42.sp),
                          ),
                        ),
                        SizedBox(height: 0.2.sw)
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      widget.emp.usrPassword = _passwordController.text;
      EmployeeDTO response = await EmpServices.empSignup(widget.emp, context);
      if (response.status == 'OK') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmpDashboard(emp: response)),
        );
      } else {
        utility.genericErrorAlert(context);
      }
    }
    setState(() {
      _signupButtonPressed = false;
    });
  }

  _mailField() {
    return TextFormField(
      readOnly: true,
      controller: _mailController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Icon(Icons.email, size: 63.w),
          ),
          labelText: VouchainLocalizations.of(context).email,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
          border: OutlineInputBorder()),
    );
  }

  _matfield() {
    return TextFormField(
      readOnly: true,
      controller: _matController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        prefixIcon:Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.confirmation_number, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).matricola,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _firstNameField() {
    return TextFormField(
      readOnly: true,
      controller: _firstNameController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.person, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).name,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _lastNameField() {
    return TextFormField(
      readOnly: true,
      controller: _lastNameController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.person, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).surname,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      focusNode: _focusPassword,
      style: TextStyle(fontSize: 42.sp),
      validator: (value) =>
          utility.validPasswordWithExplanation(_passwordController.text, _rePasswordController.text, context),
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_focusRePassword),
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
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Icon(Icons.lock, size: 63.w),
        ),
        labelText: VouchainLocalizations.of(context).password,
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
      style: TextStyle(fontSize: 42.sp),
      validator: (value) => utility.validReEnterPassword(
          _passwordController.text, _rePasswordController.text, context),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 32.sp),
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

  _termsAndConditionsTile() {
    return CheckboxListTileFormField(
      title: GestureDetector(
        onTap: () async {
          const url = 'https://www.iubenda.com/termini-e-condizioni/69445625';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          child: Text(
            VouchainLocalizations.of(context).signupAccept +
                " " +
                VouchainLocalizations.of(context).termsConditions,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.blue,
                fontSize: 42.sp,
                decoration: TextDecoration.underline),
          ),
        ),
      ),
      onSaved: (bool value) {
        print(value);
      },
      validator: (bool value) {
        if (value) {
          return null;
        } else {
          return VouchainLocalizations.of(context).acceptTerms;
        }
      },
      errorColor: Color.fromRGBO(220, 96, 96, 1),
      activeColor: colors.blue,
      checkColor: Colors.white,
    );
  }
}
