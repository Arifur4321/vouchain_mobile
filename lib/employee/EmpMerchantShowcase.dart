import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/employee/EmpMrcDetails.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmpMerchantShowcase extends StatefulWidget {
  final emp;

  EmpMerchantShowcase({Key key, @required this.emp}) : super(key: key);

  @override
  _EmpMerchantShowcaseState createState() => _EmpMerchantShowcaseState();
}

class _EmpMerchantShowcaseState extends State<EmpMerchantShowcase> {
  Future<DTOList<dynamic>> futureList;
  Position position;
  String range = "100";
  final _formKey = GlobalKey<FormState>();
  final _rangeController = TextEditingController();
  final _focusRange = FocusNode();

  @override
  void initState() {
    super.initState();
    futureList = _getList();
    _focusRange.addListener(() {});
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _focusRange.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rangeController.text =
        range + VouchainLocalizations.of(context).researchRange;
    print("RANGE --- " + range);
    return Scaffold(
        drawer: EmpDrawerMenu(selected: 2, emp: widget.emp),
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).merchantShowcase,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: Column(children: <Widget>[
          Container(
            color: colors.lightBlue,
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Flexible(
                    flex: 80,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 10, right: 20, left: 20),
                      child: TextFormField(
                          style: TextStyle(fontSize: 43.sp),
                          controller: _rangeController,
                          focusNode: _focusRange,
                          //Pulisce il campo quando viene premuto
                          onTap: () => {_rangeController.text = ""},
                          onFieldSubmitted: (String km) {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                range = _rangeController.text;
                                futureList = _getList();
                              });
                            }
                          },
                          validator: (value) {
                            //se il valore del campo è vuoto oppure ha solo la
                            // stringa "raggio di ricerca" segnala l'errore
                            if (value.isEmpty ||
                                value ==
                                    VouchainLocalizations.of(context)
                                        .researchRange) {
                              _rangeController.text = "";
                              return VouchainLocalizations.of(context)
                                  .insertResearchRange;
                            }
                            //se il valore è 0 segnala l'errore (necessario togliere
                            // tutti i caratteri che non sono numeri perché se si
                            // preme la freccia a campo senza focus altrimenti
                            // prenderebbe anche "raggio di ricerca"
                            if (int.parse(
                                    value.replaceAll(RegExp(r'[^0-9]'), '')) <=
                                0) {
                              _rangeController.text = "";
                              return VouchainLocalizations.of(context)
                                  .researchRangeMoreThanZero;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 40.sp),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 52.5.sp),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number),
                    ),
                  ),
                  Flexible(
                      flex: 20,
                      child: RawMaterialButton(
                          elevation: 1.0,
                          constraints: BoxConstraints(),
                          //removes empty spaces around of icon
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_forward,
                            color: colors.blue,
                            size: 80.w,
                          ),
                          onPressed: () {
                            //Toglie il focus al campo, come se si fosse premuto il submit
                            _focusRange.unfocus();
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                //controlla che il campo sia stato effettivamente
                                //modificato (il valore non ha "raggio di ricerca")
                                //altrimenti mantiene il vecchio range
                                if (!_rangeController.text.contains(
                                    VouchainLocalizations.of(context)
                                        .researchRange)) {
                                  range = _rangeController.text;
                                }
                                futureList = _getList();
                              });
                            }
                          })),
                ],
              ),
            ),
          ),
          Container(
            child: FutureBuilder(
                future: futureList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DTOList<dynamic> listDto = snapshot.data;
                    List<Material> rowList = [];
                    print("STATUS LISTA --- " + listDto.status.toString());
                    if (listDto.status == "OK") {
                      for (var i = 0; i < listDto.list.length; i++) {
                        rowList.add(Material(
                          color: colors.tableRowColor(i),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.only(right: 50.w, left: 43.w),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MrcDetails(
                                          emp: widget.emp,
                                          mrc: listDto.list[i])));
                            },
                            title: Text(listDto.list[i].mrcRagioneSociale,
                                style: TextStyle(fontSize: 42.sp)),
                            subtitle: Text(
                                listDto.list[i].mrcAddress +
                                    ", " +
                                    listDto.list[i].mrcCity,
                                style: TextStyle(fontSize: 37.sp)),
                            leading: Container(
                              alignment: Alignment.centerLeft,
                              width: 0.2.sw,
                              child: Container(
                                  constraints: BoxConstraints(maxWidth: 150.w, minWidth: 150.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colors.blue, width: 1.2.w),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      child: (listDto.list[i].mrcImageProfile !=
                                              null)
                                          ? Image.memory(base64.decode(
                                              listDto.list[i].mrcImageProfile))
                                          : Image(
                                              image: AssetImage(
                                                  "assets/images/vouchain_logo_vert_blu.png"),
                                            ))),
                            ),

                            trailing: Container(
                              constraints:
                                  BoxConstraints(maxWidth: 100, minWidth: 50),
                              child: GestureDetector(
                                  onTap: () =>
                                      utility.openMaps(listDto.list[i]),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (listDto.list[i].mrcDistanza != null)
                                          Text(double.parse(listDto
                                                      .list[i].mrcDistanza)
                                                  .toStringAsFixed(1) +
                                              VouchainLocalizations.of(context)
                                                  .kM),
                                        Icon(
                                          Icons.location_on,
                                          size: 80.w,
                                          color: colors.blue,
                                        ),
                                      ])),
                            ),
                          ),
                        ));
                      }
                    } else if (listDto.errorDescription == "no_user_found") {
                      rowList.add(Material(
                        child: ListTile(
                          title: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .noMerchantFound,
                                style: TextStyle(
                                    color: colors.black,
                                    fontSize: 52.5.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ));
                    } else if (listDto.errorDescription ==
                        "no_geolocation_permission") {
                      rowList.add(Material(
                        child: ListTile(
                          title: Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.only(top: 50, left: 15, right: 15),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .allowLocalization,
                                style: TextStyle(
                                    color: colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ));
                    } else if (listDto.errorDescription ==
                        "no_geolocation_active") {
                      rowList.add(Material(
                        child: ListTile(
                          title: Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.only(top: 50, left: 15, right: 15),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .allowLocalization,
                                style: TextStyle(
                                    color: colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ));
                    } else {
                      rowList.add(Material(
                        child: ListTile(
                          title: Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.only(top: 50, left: 15, right: 15),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .generalErrorRetry,
                                style: TextStyle(
                                    color: colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ));
                    }
                    return Expanded(
                      child: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: colors.blue,
                        onRefresh: () async {
                          setState(() {
                            futureList = _getList();
                          });
                          return await Future.delayed(Duration(seconds: 2));
                        },
                        child: ListView(
                          children: rowList,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return utility.genericErrorAlert(context);
                  }
                  // By default, show a loading spinner.
                  return Container(
                      height: 210,
                      width: 60,
                      padding: EdgeInsets.only(top: 150),
                      child: CircularProgressIndicator());
                }),
          ),
        ]));
  }

  //Aggiorna la lista dei merchant prendendo la posizione dell'utente
  //e utilizzandola nella chiamata del servizio
  //inoltre gestisce la situazione del gps comunicando gli eventuali errori
  Future<DTOList> _getList() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return DTOList(status: "KO", errorDescription: "no_geolocation_active");
    }
    if (await Permission.location.request().isGranted) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("POSITION --- " + position.toString());
      return MrcServices.mrcGISList(position.longitude.toString(),
          position.latitude.toString(), range, context);
    }
    return DTOList(status: "KO", errorDescription: "no_geolocation_permission");
  }
}
