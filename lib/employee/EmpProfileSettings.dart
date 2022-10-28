import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';

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

class EmpProfileSettings extends StatefulWidget {
  final EmployeeDTO emp;

  EmpProfileSettings({Key key, @required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmpProfileSettingsState();
  }
}

class EmpProfileSettingsState extends State<EmpProfileSettings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //Serve a controllare se l'utente sta modificando il profilo o no
  bool _isEditable = false;
  //Serve a controllare se il modulo è stato inviato (se il tasto conferma è stato premuto)
  bool _editButtonPressed = false;

  final _mailController = TextEditingController();
  final _matController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    //Clean up the controller when the widget is disposed.
    _mailController.dispose();
    _matController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _resetEmp();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);



    // Build a Form widget using the _formKey created above.
    return Scaffold(
      drawer: EmpDrawerMenu(selected: 5.1, emp: widget.emp),
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).profileSettings,
            style: TextStyle(fontSize: 52.5.sp)),
        actions: [
          IconButton(
            icon: (_isEditable) ? Icon(Icons.edit_off) : Icon(Icons.edit),
            tooltip: VouchainLocalizations.of(context).modify,
            onPressed: () {
              setState(() {
                _isEditable = !_isEditable;
              });
              _resetEmp();
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _editButtonPressed,
        color: colors.lightGrey,
        opacity: 0.3,
        child: Stack(fit: StackFit.expand, children: [
          utility.background(),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: (portrait)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            //Email
                            Container(
                              width: 0.85.sw,
                              padding: EdgeInsets.all(26.5.w),
                              child: _mailField(_mailController),
                            ),
                            //Matricola
                            Container(
                              padding: EdgeInsets.all(26.5.w),
                              width: 0.85.sw,
                              child: _matField(_matController),
                            ),
                            //Nome
                            Container(
                              width: 0.85.sw,
                              padding: EdgeInsets.all(26.5.w),
                              child: _firstNameField(_firstNameController),
                            ),
                            //Cognome
                            Container(
                              width: 0.85.sw,
                              padding: EdgeInsets.all(26.5.w),
                              child: _lastNameField(_lastNameController),
                            ),
                            //Password
                            if (_isEditable)
                              Container(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      color: colors.darkGrey,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w, vertical: 28.h),
                                      onPressed: () => _cancelEdit(),
                                      child: Text(
                                        VouchainLocalizations.of(context)
                                            .cancel,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36.5.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w, vertical: 28.h),
                                      onPressed: (!_editButtonPressed)
                                          ? () {
                                              setState(() {
                                                _editButtonPressed = true;
                                              });
                                              _submitForm();
                                            }
                                          : null,
                                      child: Text(
                                        VouchainLocalizations.of(context)
                                            .confirm,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36.5.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 58.w, right: 28.w, top: 40.h),
                                    child: _mailField(_mailController)),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 28.w, right: 58.w, top: 40.h),
                                    child: _matField(_matController),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 58.w, right: 28.w, top: 40.h),
                                    child:
                                        _firstNameField(_firstNameController),
                                  )),
                              Flexible(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 28.w, right: 58.w, top: 40.h),
                                    child: _lastNameField(_lastNameController),
                                  )),
                            ],
                          ),
                          if (_isEditable)
                            Container(
                              padding: EdgeInsets.only(top: 40.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    color: colors.darkGrey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 28.h),
                                    onPressed: () => _cancelEdit(),
                                    child: Text(
                                      VouchainLocalizations.of(context).cancel,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36.5.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: colors.blue,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 28.h),
                                    onPressed: (!_editButtonPressed)
                                        ? () {
                                            setState(() {
                                              _editButtonPressed = true;
                                            });
                                            _submitForm();
                                          }
                                        : null,
                                    child: Text(
                                      VouchainLocalizations.of(context).confirm,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36.5.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      EmployeeDTO empClone = EmployeeDTO.fromJson(widget.emp.toJson());
      empClone.empMatricola = _matController.text;
      empClone.empFirstName = _firstNameController.text;
      empClone.empLastName = _lastNameController.text;
      EmployeeDTO response = await EmpServices.modEmpProfile(empClone, context);
      if (response.status == "OK") {
        widget.emp.empMatricola = empClone.empMatricola;
        widget.emp.empFirstName = empClone.empFirstName;
        widget.emp.empLastName = empClone.empLastName;
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).modifySuccessful,
                  style: TextStyle(fontSize: 52.5.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).okButton,
                        style: TextStyle(fontSize: 40.sp)),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {
                          Navigator.pop(context),
                          setState(() {
                            _isEditable = false;
                            _editButtonPressed = false;
                          })
                        })
              ]),
        );
      }
    }
    setState(() {
      _editButtonPressed = false;
    });
  }

  _mailField(TextEditingController mailController) {
    return TextFormField(
      readOnly: true,
      controller: mailController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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

  _matField(TextEditingController matController) {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      controller: matController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
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

  _firstNameField(TextEditingController firstNameController) {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      controller: firstNameController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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

  _lastNameField(TextEditingController lastNameController) {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      controller: lastNameController,
      style: TextStyle(fontSize: 42.sp),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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

  _cancelEdit() {
    setState(() {
      _isEditable = false;
    });
    _resetEmp();
  }

  _resetEmp() {
    _mailController.text = widget.emp.usrEmail;
    _matController.text = widget.emp.empMatricola;
    _firstNameController.text = widget.emp.empFirstName;
    _lastNameController.text = widget.emp.empLastName;
  }
}
