import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/entity/SimpleDTO.dart';
import 'package:vouchain_wallet_app/entity/VoucherDTO.dart';
import 'package:vouchain_wallet_app/employee/EmpMrcDetails.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:numberpicker/numberpicker.dart';

class EmpVoucherTransfer extends StatefulWidget {
  final EmployeeDTO emp;
  final MerchantDTO mrc;
  final String qr;

  EmpVoucherTransfer({Key key, this.qr, @required this.emp, @required this.mrc})
      : super(key: key);

  @override
  _EmpVoucherTransferState createState() =>
      _EmpVoucherTransferState(emp, mrc, qr: qr);
}

class _EmpVoucherTransferState extends State<EmpVoucherTransfer> {
  final EmployeeDTO emp;
  final MerchantDTO mrc;
  final String qr;
  static const int numItems = 100;
  List<bool> selected = List<bool>.generate(numItems, (index) => false);
  List<VoucherDTO> selectedVouchers = List.filled(100, null);
  Future<DTOList<dynamic>> futureList;
  bool _sendButtonPressed = false;

  _EmpVoucherTransferState(this.emp, this.mrc, {this.qr});

  @override
  void initState() {
    super.initState();
    print("MERCHANT --- " + mrc.usrId.toString());
    futureList = EmpServices.empVoucherList(emp, context);
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    return WillPopScope(
      onWillPop: () async {
        if (qr != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmpDashboard(emp: emp)),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
          //drawer: EmpDrawerMenu(selected: 3, emp: emp),
          appBar: AppBar(
            toolbarHeight: 157.5.h,
            title: Text(VouchainLocalizations.of(context).allocateVouchers,
                style: TextStyle(fontSize: 52.5.sp)),
          ),
          body: LoadingOverlay(
            isLoading: _sendButtonPressed,
            color: colors.lightGrey,
            opacity: 0.3,
            child: Column(children: <Widget>[
              Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(color: colors.lightBlue),
                  padding: EdgeInsets.only(
                      top: (portrait) ? 55.h : 40.h, bottom: 28.h),
                  child: Column(
                    children: [
                      if (portrait)
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 28.h, left: 45.w, right: 45.w),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.elliptical(20.0, 15),
                            )),
                            color: colors.blue,
                            padding: EdgeInsets.all(42.h),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MrcDetails(emp: emp, mrc: mrc)),
                              )
                            },
                            child: Text(
                              mrc.mrcRagioneSociale,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 57.8.sp),
                            ),
                          ),
                        ),
                      ListTile(
                        title: Text(
                            VouchainLocalizations.of(context).availableVouchers,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.darkBlue,
                              fontSize: 57.8.sp,
                            )),
                        leading: Padding(
                          padding: EdgeInsets.only(left: 27.w),
                          child: Image(
                            width: 184.w,
                            image: AssetImage("assets/images/voucher_icon.png"),
                            color: colors.darkBlue,
                          ),
                        ),
                        trailing: (!portrait)
                            ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.elliptical(20.0, 15),
                                )),
                                color: colors.blue,
                                padding: EdgeInsets.all(42.h),
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MrcDetails(emp: emp, mrc: mrc)),
                                  )
                                },
                                child: Text(
                                  mrc.mrcRagioneSociale,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 48.sp),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                  future: futureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DTOList<dynamic> listDto = snapshot.data;
                      List<DataRow> rowList = [];
                      if (listDto.status == "OK") {
                        for (var i = 0; i < listDto.list.length; i++) {
                          rowList.add(
                            DataRow(
                              color: _tableRowColor(i),
                              selected: selected[i],
                              onSelectChanged: (bool value) {
                                VoucherDTO voucher;
                                if (value) {
                                  voucher = VoucherDTO.fromJson(
                                      listDto.list[i].toJson());
                                 voucher.vchQuantity = "1";
                                }
                                setState(() {
                                  selected[i] = value;
                                  selectedVouchers[i] = voucher;
                                });
                              },
                              cells: [
                                DataCell(
                                  Container(
                                     width:165.w,
                                     
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(left: 0),
                                    margin: EdgeInsets.only(left: 0),
                                    transform: Matrix4.translationValues(
                                        (portrait) ? -40.w : 0.w, 0, 0),
                                    child: Text(
                                      NumberFormat.currency(
                                              locale: "eu",
                                              symbol: "€",
                                              name: "EUR",
                                              decimalDigits: 2)
                                          .format(double.parse(
                                              listDto.list[i].vchValue)),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: colors.darkGrey,
                                          fontSize: 30.sp),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    listDto.list[i].vchEndDate,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: colors.darkGrey,
                                        fontSize: 30.sp),
                                  ),
                                ),

                                DataCell(
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 4, bottom: 4, left: 4),
                                    transform: Matrix4.translationValues(
                                        (portrait) ? -10.w : -230.w, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (selectedVouchers[i] != null)
                                              ? selectedVouchers[i].vchQuantity
                                              : "0",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colors.darkGrey,
                                              fontSize: 30.sp),
                                        ),
                                         
                                        Text(
                                          "/ " +
                                              formatVoucherQuantity(listDto.list[i].vchQuantity)  +
                                              "  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colors.darkGrey,
                                              fontSize: 30.sp),
                                        ),
                                        Icon(Icons.edit,
                                            color: colors.darkGrey, size: 39.5.h)
                                        //19)
                                      ],
                                    ),
                                  ),
                                  onTap: (selectedVouchers[i] != null)
                                      ? () => _showInfIntDialog(
                                          listDto.list[i], selectedVouchers[i])
                                      : null,
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Expanded(
                        child: ListView(children: [
                          DataTable(
                            columnSpacing: 74.w,
                            columns: [
                              DataColumn(
                                label: Text(
                                  VouchainLocalizations.of(context).walletValue,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 45.sp, //18,
                                    color: colors.blue,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  VouchainLocalizations.of(context)
                                      .expirationDate,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 45.sp,
                                    color: colors.blue,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  VouchainLocalizations.of(context).quantity,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 45.sp,
                                    color: colors.blue,
                                  ),
                                ),
                              )
                            ],
                            rows: rowList,
                          ),
                        ]),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                            VouchainLocalizations.of(context).generalErrorRetry,
                            style: TextStyle(
                                fontSize: 45.h,
                                color: colors.darkGrey,
                                fontWeight: FontWeight.w500)),
                      );
                    }
                    // By default, show a loading spinner.
                    return Container(
                        height: 210,
                        width: 60,
                        padding: EdgeInsets.only(top: 150),
                        child: CircularProgressIndicator());
                  }),
              Container(
                height: (portrait) ? null : 40,
                child: ListTile(
                  contentPadding: EdgeInsets.only(right: 30, left: 30),
                  dense: true,
                  title: Text(
                    VouchainLocalizations.of(context).totalSelected + ": ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blueGrey),
                  ),
                  trailing: Text(
                    _totaleSelezionato(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blueGrey),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: (portrait) ? 20 : 12),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.elliptical(20.0, 15),
                  )),
                  color: colors.blue,
                  padding: EdgeInsets.all(15),
                  onPressed: () => _submit(),
                  child: Text(
                    VouchainLocalizations.of(context).transferVouchers,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 19),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  _tableRowColor(int i) {
    if (i % 2 == 1) {
      return MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        return Color.fromRGBO(237, 237, 237, 1);
      });
    } else {
      return MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        return Colors.white;
      });
    }
  }

  String _totaleSelezionato() {
    double sum = 0;
    //itero lista
    for (var i = 0; i < selectedVouchers.length; i++) {
      //condizione che nn sia null
      if (selectedVouchers[i] != null) {
        sum = sum +
            double.parse(selectedVouchers[i].vchValue) *
                double.parse(selectedVouchers[i].vchQuantity);
      }
    }
    return NumberFormat.currency(
            locale: "eu", symbol: "€", name: "EUR", decimalDigits: 2)
        .format(sum);
  }

  Future _showInfIntDialog(
      VoucherDTO voucher, VoucherDTO selectedVoucher) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          minValue: 1,
          maxValue: int.parse(voucher.vchQuantity),
          step: 1,
          initialIntegerValue: int.parse(selectedVoucher.vchQuantity),
          infiniteLoop: true,
          cancelWidget: RaisedButton(
              onPressed: null,
              disabledColor: colors.darkGrey,
              child: Text(VouchainLocalizations.of(context).cancel,
                  style: TextStyle(fontSize: 40.sp, color: Colors.white))),
          confirmWidget: RaisedButton(
              onPressed: null,
              disabledColor: colors.blue,
              child: Text(VouchainLocalizations.of(context).okButton,
                  style: TextStyle(fontSize: 40.sp, color: Colors.white))),
          title: Text(
            VouchainLocalizations.of(context).selectQuantity,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.darkBlue, fontSize: 40.sp),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.blue, width: 2),
          ),
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => selectedVoucher.vchQuantity = value.toString());
        //integerInfiniteNumberPicker.animateInt(value);
      }
    });
  }

  _submit() async {
    List<VoucherDTO> vouchers = [];
    for (var item in selectedVouchers) {
      if (item != null) {
        vouchers.add(item);
      }
    }
    print("VOUCHERS ---" + vouchers.toString());
    if (vouchers.isNotEmpty) {
      List<TableRow> _voucherRows = _orderRows(vouchers);
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            titlePadding: const EdgeInsets.all(0),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 52.5.sp,
                fontFamily: "Graphik"),
            title: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                child: Text(VouchainLocalizations.of(context).orderSummary,
                    textAlign: TextAlign.center)),
            contentPadding: const EdgeInsets.all(0),
            children: [
              Container(
                //height: 450,
                height: 850.h,
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 1,
                      child: Container(
                        color: colors.lightBlue,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Center(
                          child: Text(
                            VouchainLocalizations.of(context).selectedVoucher,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 52.5.sp,
                              color: colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 33,
                          child: Container(
                            height: 112.h,
                            decoration: BoxDecoration(
                                color: colors.lightBlue,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color:
                                            Theme.of(context).dividerColor))),
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              VouchainLocalizations.of(context).walletValue,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 52.5.sp,
                                color: colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 33,
                          child: Container(
                            height: 112.h,
                            decoration: BoxDecoration(
                                color: colors.lightBlue,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color:
                                            Theme.of(context).dividerColor))),
                            child: Center(
                              child: Text(
                                VouchainLocalizations.of(context).quantity,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 52.5.sp,
                                    color: colors.blue),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 34,
                          child: Container(
                            height: 112.h,
                            decoration: BoxDecoration(
                                color: colors.lightBlue,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color:
                                            Theme.of(context).dividerColor))),
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.centerRight,
                            child: Text(
                              VouchainLocalizations.of(context).import,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 52.5.sp,
                                  color: colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView(children: [
                        Container(
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(3.4),
                              1: FlexColumnWidth(3.1),
                              2: FlexColumnWidth(3.5),
                            },
                            children: _voucherRows,
                          ),
                        )
                      ]),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0)),
                      child: Container(
                        margin: EdgeInsets.only(top: 40.h, bottom: 60.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                child: Text(
                                    VouchainLocalizations.of(context).cancel,
                                    style: TextStyle(
                                        fontSize: 40.sp, color: Colors.white)),
                                color: colors.darkGrey,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 42.w, vertical: 28.h),
                                onPressed: () => {Navigator.pop(context)}),
                            RaisedButton(
                                child: Text(
                                    VouchainLocalizations.of(context).confirm,
                                    style: TextStyle(
                                        fontSize: 40.sp, color: Colors.white)),
                                color: colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 42.w, vertical: 28.h),
                                onPressed: () => _allocateVouchers(vouchers))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
      );
    } else {
      showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
            title: Text(
              VouchainLocalizations.of(context).error,
              style: TextStyle(fontSize: 52.5.sp),
            ),
            content: Text(
                VouchainLocalizations.of(context).selectAtLeastOneVoucher,
                style: TextStyle(fontSize: 40.sp)),
            actions: [
              RaisedButton(
                  child: Text(VouchainLocalizations.of(context).okButton,
                      style: TextStyle(fontSize: 40.sp)),
                  color: colors.blue,
                  padding:
                      EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                  onPressed: () => {Navigator.pop(context)})
            ]),
      );
    }
    setState(() {
      _sendButtonPressed = false;
    });
  }

  _allocateVouchers(List<VoucherDTO> vouchers) async {
    Navigator.pop(context);
    setState(() {
      _sendButtonPressed = true;
    });
    Map<String, dynamic> payload = {
      'notificationType': "confirmTransaction",
      'empId': emp.usrId
    };
    SimpleDTO response =
        await EmpServices.allocateVoucher(emp, mrc, vouchers, context, qr: qr);

    //print("NOTIFICATION (VoucherTransfer) ----" +emp.notificationEnabled);
    //if (emp.notificationEnabled.toLowerCase() == "true") {
    if (response.status == "OK") {
      utility.showNotification(payload, 0,
          VouchainLocalizations.of(context).voucherTransferComplete, null);
    } else {
      utility.showNotification(payload, 0,
          VouchainLocalizations.of(context).voucherTransferError, null);
    }
    //}
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmpDashboard(emp: emp)),
    );
  }

  List<TableRow> _orderRows(List<VoucherDTO> vouchers) {
    List<TableRow> _voucherRows = [];
    for (int i = 0; i < vouchers.length; i++) {
      _voucherRows.add(TableRow(
        decoration: BoxDecoration(
          color: colors.tableRowColor(i),
        ),
        children: [
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(top: 45.w, bottom: 45.w, left: 20),
            child: Text(
              NumberFormat.currency(
                      locale: "eu", symbol: "€", name: "EUR", decimalDigits: 2)
                  .format(double.parse(vouchers[i].vchValue)),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colors.darkGrey,
                  fontSize: 40.sp),
            ),
          )),
          TableCell(
              child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 45.w, bottom: 45.w),
              child: Text(
                vouchers[i].vchQuantity,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.darkGrey,
                    fontSize: 40.sp),
              ),
            ),
          )),
          TableCell(
              child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 45.w, bottom: 45.w, left: 10),
              child: Text(
                NumberFormat.currency(
                        locale: "eu",
                        symbol: "€",
                        name: "EUR",
                        decimalDigits: 2)
                    .format(double.parse(vouchers[i].vchValue) *
                        double.parse(vouchers[i].vchQuantity)),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.darkGrey,
                    fontSize: 40.sp),
              ),
            ),
          )),
        ],
      ));
    }
    return _voucherRows;
  }

  String formatVoucherQuantity(String voucherQuantity){
    String formatQuantity;
    if(voucherQuantity.length>3){
      String firstformatQuantity = voucherQuantity.substring(0,voucherQuantity.length-3);
      formatQuantity = firstformatQuantity + "." + voucherQuantity.substring(voucherQuantity.length-3, voucherQuantity.length);
    }else{
      formatQuantity=voucherQuantity;
    }
    return formatQuantity;
  }
}