import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/employee/EmpVoucherTransfer.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MrcDetails extends StatelessWidget {
  final EmployeeDTO emp;
  final MerchantDTO mrc;

  MrcDetails({Key key, @required this.emp, @required this.mrc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).mrcDetails,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 50.w, right: 50.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: 55.h, bottom: 60.h, left: 25.w, right: 25.w),
                  constraints: BoxConstraints(maxHeight: 450.h), //160
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.blue, width: 4),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: (mrc.mrcImageProfile != null ) ? Image.memory(base64.decode(mrc.mrcImageProfile)) : Image(image: AssetImage("assets/images/vouchain_logo_vert_blugrigio.png"),))),
              Container(
                color: colors.lightGrey,
                child: ListTile(
                  title: Text(
                    VouchainLocalizations.of(context).mrcName + " :",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.blue,
                        fontSize: 42.sp),
                  ),
                  trailing: Text(
                    mrc.mrcFirstNameRef + " " + mrc.mrcLastNameRef,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.darkGrey,
                        fontSize: 42.sp),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  VouchainLocalizations.of(context).mrcBusinessName + " :",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.blue,
                      fontSize: 42.sp),
                ),
                trailing: Text(
                  mrc.mrcRagioneSociale ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.darkGrey,
                      fontSize: 42.sp),
                ),
              ),
              Container(
                color: colors.lightGrey,
                child: ListTile(
                  title: Text(
                    VouchainLocalizations.of(context).mrcAddress + " :",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.blue,
                        fontSize: 42.sp),
                  ),
                  trailing: Text(
                    mrc.mrcAddress ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.darkGrey,
                        fontSize: 42.sp),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  VouchainLocalizations.of(context).mrcCity + " :",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.blue,
                      fontSize: 42.sp),
                ),
                trailing: Text(
                  mrc.mrcCity ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.darkGrey,
                      fontSize: 42.sp),
                ),
              ),
              Container(
                color: colors.lightGrey,
                child: ListTile(
                    title: Text(
                      VouchainLocalizations.of(context).mrcProv + " :",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.blue,
                          fontSize: 42.sp),
                    ),
                    trailing: Text(
                      mrc.mrcProv ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.darkGrey,
                          fontSize: 42.sp),
                    )),
              ),
              ListTile(
                title: Text(
                  VouchainLocalizations.of(context).mrcZipCode + " :",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.blue,
                      fontSize: 42.sp),
                ),
                trailing: Text(
                  mrc.mrcZip ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.darkGrey,
                      fontSize: 42.sp),
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 45,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 28.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Icon(
                                Icons.euro_symbol,
                                size: 80.h, //30,
                                color: Colors.white,
                              )),
                          Flexible(
                            flex: 80,
                            child: Container(
                              //padding: EdgeInsets.only(left: 5),
                              child: Text(
                                VouchainLocalizations.of(context).pay,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 46.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.elliptical(20.0, 15),
                      )),
                      color: colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EmpVoucherTransfer(emp: emp, mrc: mrc)),
                        );
                      },
                    ),
                  ),
                  Flexible(flex: 10, child: SizedBox()),
                  Flexible(
                    flex: 45,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 28.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Icon(
                                Icons.location_on,
                                size: 80.h,
                                color: Colors.white,
                              )),
                          Flexible(
                            flex: 80,
                            child: Container(
                              //padding: EdgeInsets.only(left: 10),
                              child: Text(
                                VouchainLocalizations.of(context).openMap,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 46.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.elliptical(20.0, 15),
                      )),
                      color: colors.blue,
                      onPressed: () => utility.openMaps(mrc),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80.h)
            ],
          ),
        ),
      ),
    );
  }
}
