import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';

//DTO
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/ProvinceDTO.dart';
import 'package:vouchain_wallet_app/entity/CityDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';

class MrcProfileSettings extends StatefulWidget {
  final MerchantDTO mrc;

  MrcProfileSettings({Key key, @required this.mrc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MrcProfileSettingsState();
  }
}

class MrcProfileSettingsState extends State<MrcProfileSettings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //Serve a controllare se l'utente sta modificando il profilo o no
  bool _isEditable = false;
  bool _editButtonPressed = false;

  final _mailController = TextEditingController();
  final _officeNameController = TextEditingController();
  final _addressOfficeController = TextEditingController();
  final _phoneNoOfficeController = TextEditingController();
  final _firstNameRefController = TextEditingController();
  final _lastNameRefController = TextEditingController();
  String _provSelezionata;
  String _citySelezionata;
  Future<List<ProvinceDTO>> _provinces;
  Future<List<CityDTO>> _cities;
  String _imgSelezionata = "";

  @override
  void dispose() {
    //Clean up the controller when the widget is disposed.
    _mailController.dispose();
    _officeNameController.dispose();
    _addressOfficeController.dispose();
    _phoneNoOfficeController.dispose();
    _firstNameRefController.dispose();
    _lastNameRefController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _provinces = UserServices.getProvinces(context);
    _resetMrc();
    _citySelezionata = widget.mrc.mrcCityOffice;
    //_imgSelezionata = widget.mrc.mrcImageProfile;
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    _cities = UserServices.getCities(_provSelezionata, context);
    /*print("------");
    print("PROVINCIA MEMORIZZATA --- " + widget.mrc.mrcProvOffice.toString());
    print("CITTA MEMORIZZATA --- " + widget.mrc.mrcCityOffice.toString());
    print("PROVINCIA FORM --- " + _provSelezionata.toString());
    print("CITTA FORM --- " + _citySelezionata.toString());
    print("------");*/
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      drawer: MrcDrawerMenu(selected: 4.1, mrc: widget.mrc),
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
              _resetMrc();
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
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 100.h),
                child: Form(
                  key: _formKey,
                  child: (portrait)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                              //Immagine profilo
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 55.h),
                                  child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 30.w, right: 30.w),
                                            constraints: BoxConstraints(
                                                maxHeight: 450.h),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: colors.blue,
                                                    width: 4),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: (_imgSelezionata != null)
                                                    ? Image.memory(
                                                        base64.decode(
                                                            _imgSelezionata))
                                                    : Image(
                                                        image: AssetImage(
                                                            "assets/images/vouchain_logo_vert_blu.png")))),
                                        if (_isEditable)
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 20.h, right: 45.w),
                                            child: Icon(Icons.mode_edit,
                                                color: colors.blue, size: 80.h),
                                          ),
                                      ]),
                                ),
                                onTap: (_isEditable)
                                    ? () => _chooseImageUploadMode()
                                    : null,
                              ),
                              //Email
                              Container(
                                width: 920.w,
                                padding: EdgeInsets.all(30.h),
                                child: _mailField(),
                              ),
                              //Nome ufficio
                              Container(
                                padding: EdgeInsets.all(30.h),
                                width: 920.w,
                                child: _officeNameField(),
                              ),
                              //Indirizzo Ufficio
                              Container(
                                width: 920.w,
                                padding: EdgeInsets.all(30.h),
                                child: _numberField(),
                              ),
                              //Numero ufficio
                              Container(
                                width: 920.w,
                                padding: EdgeInsets.all(30.h),
                                child: _addressField(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 340.w,
                                    padding: EdgeInsets.all(30.h),
                                    child: _provField(),
                                  ),
                                  Container(
                                    width: 585.w,
                                    padding: EdgeInsets.all(30.h),
                                    child: _cityField(),
                                  ),
                                ],
                              ),
                              //Nome Ref
                              Container(
                                width: 920.w,
                                padding: EdgeInsets.all(30.h),
                                child: _firstNameRefField(),
                              ),
                              //Cognome Ref
                              Container(
                                width: 920.w,
                                padding: (_isEditable)
                                    ? EdgeInsets.all(30.h)
                                    : EdgeInsets.only(
                                        top: 30.h,
                                        left: 30.h,
                                        right: 30.h,
                                        bottom: 150.h),
                                child: _lastNameRefField(),
                              ),
                              if (_isEditable)
                                Container(
                                  padding: EdgeInsets.only(bottom: 800.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        color: colors.darkGrey,
                                        onPressed: () => _cancelEdit(),
                                        child: Text(
                                          VouchainLocalizations.of(context)
                                              .cancel,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 36.5.sp),
                                        ),
                                      ),
                                      RaisedButton(
                                        color: colors.blue,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 36.5.sp),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          left: 60.h,
                                          right: 30.h,
                                          top: 40.w,
                                          bottom: 15.w),
                                      child: Stack(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 30.w, right: 30.w),
                                                  constraints: BoxConstraints(
                                                      maxHeight: 450.w,
                                                      maxWidth: 450.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: colors.blue,
                                                          width: 4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: (_imgSelezionata !=
                                                              null)
                                                          ? Image.memory(
                                                              base64.decode(
                                                                  _imgSelezionata))
                                                          : Image(image: AssetImage("assets/images/vouchain_logo_vert_blu.png")))),
                                              onTap: (_isEditable)
                                                  ? () =>
                                                      _chooseImageUploadMode()
                                                  : null,
                                            ),
                                            if (_isEditable)
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 20.h, right: 45.w),
                                                  child: Icon(
                                                    Icons.mode_edit,
                                                    color: colors.blue,
                                                    size: 80.h,
                                                  )),
                                          ])),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 29.h, right: 50.h, top: 40.w),
                                        child: _mailField(),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 29.h,
                                              right: 50.h,
                                              top: 40.w),
                                          child: _officeNameField())
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 29.h, right: 50.h, top: 40.w),
                                      child: _numberField(),
                                    )),
                                Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 29.h, right: 50.h, top: 40.w),
                                      child: _addressField(),
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 29.h, right: 50.h, top: 40.w),
                                      child: _provField(),
                                    )),
                                Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 29.h, right: 50.h, top: 40.w),
                                      child: _cityField(),
                                    )),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: (_isEditable) ? 30.h : 150.h),
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 5,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 29.h, right: 50.h, top: 40.w),
                                        child: _firstNameRefField(),
                                      )),
                                  Flexible(
                                      flex: 5,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 29.h, right: 50.h, top: 40.w),
                                        child: _lastNameRefField(),
                                      )),
                                ],
                              ),
                            ),
                            if (_isEditable)
                              Container(
                                padding: EdgeInsets.only(bottom: 600.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      color: colors.darkGrey,
                                      onPressed: () => _cancelEdit(),
                                      child: Text(
                                        VouchainLocalizations.of(context)
                                            .cancel,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36.5.sp),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: colors.blue,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36.5.sp),
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
          ),
        ]),
      ),
    );
  }

  _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      MerchantDTO mrcClone = MerchantDTO.fromJson(widget.mrc.toJson());
      mrcClone.mrcOfficeName = _officeNameController.text;
      mrcClone.mrcAddressOffice = _addressOfficeController.text;
      mrcClone.mrcPhoneNoOffice = _phoneNoOfficeController.text;
      mrcClone.mrcFirstNameRef = _firstNameRefController.text;
      mrcClone.mrcLastNameRef = _lastNameRefController.text;
      mrcClone.mrcProvOffice = _provSelezionata;
      mrcClone.mrcCityOffice = _citySelezionata;
      mrcClone.mrcImageProfile = _imgSelezionata;
      MerchantDTO response = await MrcServices.modMrcProfile(mrcClone, context);
      if (response.status == "OK") {
        widget.mrc.mrcOfficeName = mrcClone.mrcOfficeName;
        widget.mrc.mrcAddressOffice = mrcClone.mrcOfficeName;
        widget.mrc.mrcPhoneNoOffice = mrcClone.mrcPhoneNoOffice;
        widget.mrc.mrcFirstNameRef = mrcClone.mrcFirstNameRef;
        widget.mrc.mrcLastNameRef = mrcClone.mrcLastNameRef;
        widget.mrc.mrcProvOffice = mrcClone.mrcProvOffice;
        widget.mrc.mrcCityOffice = mrcClone.mrcCityOffice;
        widget.mrc.mrcImageProfile = mrcClone.mrcImageProfile;
        return showDialog<void>(
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

  _mailField() {
    return TextFormField(
      readOnly: true,
      style: TextStyle(fontSize: 42.sp),
      controller: _mailController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.email),
          labelText: VouchainLocalizations.of(context).email,
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
          border: OutlineInputBorder()),
    );
  }

  _officeNameField() {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      style: TextStyle(fontSize: 42.sp),
      controller: _officeNameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.store),
        labelText: VouchainLocalizations.of(context).officeName,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _addressField() {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      style: TextStyle(fontSize: 42.sp),
      controller: _addressOfficeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.location_on),
        labelText: VouchainLocalizations.of(context).mrcAddress,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _numberField() {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      style: TextStyle(fontSize: 42.sp),
      controller: _phoneNoOfficeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.phone),
        labelText: VouchainLocalizations.of(context).mrcPhone,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _firstNameRefField() {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      style: TextStyle(fontSize: 42.sp),
      controller: _firstNameRefController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.person),
        labelText: VouchainLocalizations.of(context).contactName,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _lastNameRefField() {
    return TextFormField(
      readOnly: _isEditable ? false : true,
      style: TextStyle(fontSize: 42.sp),
      controller: _lastNameRefController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.person),
        labelText: VouchainLocalizations.of(context).contactSurname,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colors.blue)),
        border: OutlineInputBorder(),
      ),
    );
  }

  _provField() {
    return FutureBuilder(
        future: _provinces,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField<String>(
              value: _provSelezionata,
              disabledHint: Text(widget.mrc.mrcProvOffice),
              elevation: 16,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: VouchainLocalizations.of(context).mrcProv,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  contentPadding: EdgeInsets.fromLTRB(25.h, 30.h, 0.h, 30.h),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.blue)),
                  border: OutlineInputBorder()),
              onChanged: (_isEditable)
                  ? (String newValue) {
                      setState(() {
                        _provSelezionata = newValue;
                      });
                    }
                  : null,
              items: snapshot.data
                  .map<DropdownMenuItem<String>>((ProvinceDTO value) {
                return DropdownMenuItem<String>(
                  value: value.cod,
                  child: Text(
                    value.cod,
                    style: TextStyle(fontSize: 42.sp),
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return utility.genericErrorAlert(context);
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        });
  }

  _cityField() {
    return FutureBuilder(
        future: _cities,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CityDTO> citiesReceived = snapshot.data;
            if (_provSelezionata == citiesReceived[0].idProvince) {
              print("0 " + citiesReceived[0].idProvince.toString());
              print(_provSelezionata.toString());
              bool flag = false;
              for (CityDTO city in citiesReceived) {
                if (city.name == _citySelezionata) {
                  flag = true;
                  break;
                }
              }
              if (!flag && _isEditable) {
                _citySelezionata = citiesReceived[0].name;
              }
              return DropdownButtonFormField<String>(
                value: _citySelezionata,
                disabledHint: Text(widget.mrc.mrcCityOffice),
                isExpanded: true,
                elevation: 16,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: VouchainLocalizations.of(context).mrcCity,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  contentPadding: EdgeInsets.fromLTRB(25.h, 30.h, 0.h, 30.h),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.blue)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_isEditable)
                    ? (String newValue) {
                        setState(() {
                          _citySelezionata = newValue;
                        });
                      }
                    : null,
                items: citiesReceived
                    .map<DropdownMenuItem<String>>((CityDTO value) {
                  return DropdownMenuItem<String>(
                    value: value.name,
                    child: Text(
                      value.name,
                      style: TextStyle(fontSize: 42.sp),
                    ),
                  );
                }).toList(),
              );
            }
            return DropdownButtonFormField<String>(
              value: "-",
              disabledHint: Text("-"),
              isExpanded: true,
              elevation: 16,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: VouchainLocalizations.of(context).mrcCity,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                contentPadding: EdgeInsets.fromLTRB(25.h, 30.h, 0.h, 30.h),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.blue)),
                border: OutlineInputBorder(),
              ),
              onChanged: null,
              items: ["-"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: "-",
                  child: Text(
                    "-",
                    style: TextStyle(fontSize: 42.sp),
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return utility.genericErrorAlert(context);
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        });
  }

  _cancelEdit() {
    setState(() {
      _isEditable = false;
    });
    _resetMrc();
  }

  void _resetMrc() {
    _mailController.text = widget.mrc.usrEmail;
    _officeNameController.text = widget.mrc.mrcOfficeName;
    _addressOfficeController.text = widget.mrc.mrcAddressOffice;
    _phoneNoOfficeController.text = widget.mrc.mrcPhoneNoOffice;
    _firstNameRefController.text = widget.mrc.mrcFirstNameRef;
    _lastNameRefController.text = widget.mrc.mrcLastNameRef;
    _provSelezionata = widget.mrc.mrcProvOffice;
    _citySelezionata = widget.mrc.mrcCityOffice;
    _imgSelezionata = widget.mrc.mrcImageProfile;
  }

  _chooseImageUploadMode() {
    final picker = ImagePicker();
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 400.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 225.h,
                    height: 225.h,
                    child: RaisedButton(
                        padding: EdgeInsets.zero,
                        color: colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.elliptical(10.0, 10),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 120.h,
                                )),
                            Text(VouchainLocalizations.of(context).gallery,
                                style: TextStyle(
                                    fontSize: 40.sp, color: Colors.white))
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _getImage(ImageSource.gallery, picker);
                        }),
                  ),
                ],
              ),
              SizedBox(
                width: 60.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 225.h,
                    height: 225.h,
                    child: RaisedButton(
                        padding: EdgeInsets.zero,
                        color: colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.elliptical(10.0, 10),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 120.h,
                                )),
                            Text(VouchainLocalizations.of(context).camera,
                                style: TextStyle(
                                    fontSize: 40.sp, color: Colors.white))
                          ],
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          _getImage(ImageSource.camera, picker);
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getImage(ImageSource source, ImagePicker picker) async {
    final pickedFile = await picker.getImage(source: source);
    final bytes = await File(pickedFile.path).readAsBytes();
    final size = bytes.lengthInBytes / 1024;
    if (size <= utility.MAX_SIZE) {
      setState(() {
        if (pickedFile != null) {
          //_image = File(pickedFile.path);
          _imgSelezionata = base64.encode(bytes);
        } else {
          print('No image selected.');
        }
      });
    } else {
      utility.genericErrorAlert(context,
          msg: VouchainLocalizations.of(context).imageTooLarge +
              (utility.MAX_SIZE / 1000).toString() +
              "MB");
    }
  }
}
