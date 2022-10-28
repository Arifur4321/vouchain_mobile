import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/TransactionDTO.dart';
import 'package:vouchain_wallet_app/entity/DTOList.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmpTransactionHistory extends StatefulWidget {
  final EmployeeDTO emp;

  EmpTransactionHistory({Key key, @required this.emp}) : super(key: key);

  @override
  _EmpTransactionHistoryState createState() => _EmpTransactionHistoryState();
}

class _EmpTransactionHistoryState extends State<EmpTransactionHistory> {
  Future<DTOList<dynamic>> futureList;
  GlobalKey formKey = GlobalKey();

  DateTimeRange selectedRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
      end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    futureList = _updateList(context, selectedRange);

    return Scaffold(
        drawer: EmpDrawerMenu(selected: 4, emp: widget.emp),
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).transactionHistory,
              style: TextStyle(fontSize: 52.5.sp)),
          actions: <Widget>[
            PopupMenuButton<String>(
              //Nel caso si decidesse di aggiungere più tasti la funzione qui va
              // sostituita con una più adatta che smista le funzioni
              onSelected: (String choice) => _exportHistory(),
              itemBuilder: (BuildContext context) {
                return {VouchainLocalizations.of(context).exportHistory}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _datePickerRow(),
            _tableHeadersRow(),
            Expanded(
              child: ListView(children: [
                FutureBuilder(
                    future: futureList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DTOList<dynamic> listDto = snapshot.data;
                        List<TableRow> _rowList = [];
                        if (listDto.status == "OK") {
                          if (listDto.list.isEmpty) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 80.w, right: 80.w, top: 100.h),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .noTransactionsFound,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.h,
                                    color: colors.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          }

                          for (var i = 0; i < listDto.list.length; i++) {
                            _rowList.add(
                              TableRow(
                                decoration: BoxDecoration(
                                  color: colors.tableRowColor(i),
                                ),
                                //Display timestamp, recipient, and total.
                                children: [
                                  GestureDetector(
                                    onTap: () => _showTrcDetails(
                                        context, listDto.list[i]),
                                    child: Container(
                                      height: (listDto.list[i].trcType == "SPS")
                                          ? 170.h
                                          : 120.h,
                                      decoration: BoxDecoration(),
                                      alignment: Alignment.center,
                                      //padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                                      child: Text(
                                        listDto.list[i].trcDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 40.sp),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () => _showTrcDetails(
                                        context, listDto.list[i]),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      constraints:
                                          BoxConstraints(minHeight: 120.h),
                                      decoration: BoxDecoration(),
                                      //padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: portrait? 100.sp: 60.sp),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35.w, vertical: 28.h),
                                      child: Text(
                                        _getTrcDescription(
                                            listDto.list[i], context),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 40.sp),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () => _showTrcDetails(
                                        context, listDto.list[i]),
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      height: (listDto.list[i].trcType == "SPS")
                                          ? 170.h
                                          : 120.h,
                                      //padding: EdgeInsets.only(right: 15, top: 15, bottom: 15),
                                      padding: EdgeInsets.only(right: 40.w),
                                      alignment: portrait
                                          ? Alignment.centerRight
                                          : Alignment.center,
                                      child: Text(
                                        NumberFormat.currency(
                                                locale: "eu",
                                                symbol: "€",
                                                name: "EUR",
                                                decimalDigits: 2)
                                            .format(double.parse(
                                                listDto.list[i].trcValue)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 40.sp),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            );
                          }
                          return Container(
                            color: colors.lightBlue,
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2.6),
                                1: FlexColumnWidth(4.7),
                                2: FlexColumnWidth(2.7),
                              },
                              children: _rowList,
                            ),
                          );
                        } else {
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
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 280.h),
                          child: CircularProgressIndicator(strokeWidth: 8.h));
                    }),
              ]),
            ),
          ],
        ));
  }

  Future<DTOList<dynamic>> _updateList(
      BuildContext context, DateTimeRange range) {
    String _start = DateFormat('yyyy-MM-dd').format(range.start).toString();
    //range.start.year.toString() + "-" +
    //range.start.month.toString() + "-" + range.start.day.toString();
    String _end = DateFormat('yyyy-MM-dd').format(range.end).toString();
    //range.end.year.toString() + "-" +
    //range.end.month.toString() + "-" + range.end.day.toString();

    return EmpServices.empTransactionList(_start, _end, widget.emp, context);
  }

  Container _datePickerRow() {
    return Container(
      color: colors.lightBlue,
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Flexible(
              flex: 85,
              child: DateRangeField(
                  context: context,
                  dateFormat: DateFormat('dd-MM-yyyy'),
                  saveText: VouchainLocalizations.of(context).save,
                  fieldStartLabelText:
                      VouchainLocalizations.of(context).startDate,
                  fieldEndLabelText: VouchainLocalizations.of(context).endDate,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.date_range),
                    hintText:
                        VouchainLocalizations.of(context).insertStartEndDate,
                    border: OutlineInputBorder(),
                  ),
                  initialValue: selectedRange,
                  //DateTimeRange( start:  DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day ), end: DateTime.now()),
                  firstDate: DateTime(2019),
                  lastDate: DateTime.now(),
                  validator: (value) {
                    if (value.start.isAfter(DateTime.now())) {
                      return VouchainLocalizations.of(context)
                          .insertValidTimeRange;
                    }
                    return null;
                  },
                  helpText: VouchainLocalizations.of(context).periodSelect,
                  onSaved: (value) {
                    setState(() {
                      selectedRange = value;
                    });
                  }),
            ),
            Flexible(
                flex: 15,
                child: RawMaterialButton(
                  elevation: 1.0,
                  constraints: BoxConstraints(),
                  //removes empty spaces around of icon
                  shape: CircleBorder(),
                  //circular button
                  //fillColor: colors.blue, //background color
                  //splashColor: colors.lightGrey,
                  //highlightColor: colors.darkBlue,
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.cached,
                    color: colors.blue,
                    size: 85.h,
                  ),
                  onPressed: _submitDate, //do your action
                )),
          ],
        ),
      ),
    );
  }

  void _submitDate() {
    final FormState form = formKey.currentState;
    form.save();
  }

  Row _tableHeadersRow() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 26,
          child: Container(
            height: 165.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.lightBlue,
                border: Border(
                    bottom: BorderSide(
                        width: 2, color: Theme.of(context).dividerColor))),
            //padding: EdgeInsets.only(top: 15, left: 15),
            child: Text(
              VouchainLocalizations.of(context).date,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 52.5.sp,
                color: colors.blue,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 48,
          child: Container(
            height: 165.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.lightBlue,
                border: Border(
                    bottom: BorderSide(
                        width: 2, color: Theme.of(context).dividerColor))),
            //padding: EdgeInsets.only(top: 15, left: 10),
            child: Text(
              VouchainLocalizations.of(context).description,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 52.5.sp,
                  color: colors.blue),
            ),
          ),
        ),
        Expanded(
          flex: 26,
          child: Container(
            height: 165.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.lightBlue,
                border: Border(
                    bottom: BorderSide(
                        width: 3, color: Theme.of(context).dividerColor))),
            //padding: EdgeInsets.only( top: 15, right: 10 ),
            child: Text(
              VouchainLocalizations.of(context).import,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 52.5.sp,
                  color: colors.blue),
            ),
          ),
        )
      ],
    );
  }

  // Emp = accredito buoni o destinatario
  String _getTrcDescription(TransactionDTO trc, BuildContext context) {
    switch (trc.trcType) {
      case 'ALL':
        {
          return VouchainLocalizations.of(context).voucherAccredit;
        }
      case 'SPS':
        {
          return VouchainLocalizations.of(context).voucherTransferTo +
              trc.usrIdAString.toString();
        }
      default:
        {
          return VouchainLocalizations.of(context).genericTransaction;
        }
    }
  }

  _showTrcDetails(BuildContext context, TransactionDTO trc) async {
    final sessionResponse =
        await UserServices.verifySession(context, widget.emp);
    if (sessionResponse.status == "OK") {
      List<TableRow> _voucherRows = _trcDetailsVoucherRows(trc);

      return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            titlePadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 52.5.sp,
                fontFamily: "Graphik"),
            title: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      child: RawMaterialButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 80.h),
                          onPressed: () => Navigator.pop(context),
                          constraints: BoxConstraints(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            //topRight: Radius.circular(25.0)
                          )),
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 40.h, bottom: 40.h, left: 80.w),
                      alignment: Alignment.center,
                      child: Text(
                          VouchainLocalizations.of(context).transactionNumber +
                              trc.trcId +
                              "\n" +
                              trc.trcDate,
                          textAlign: TextAlign.center),
                    ),
                  ],
                )),
            contentPadding: const EdgeInsets.all(0),
            children: [
              Container(
                //height: 450,
                height: 1450.h,
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trc.trcType == "SPS") _trcDetailsRecipient(trc),
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
                                        width: 3,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                        child: ListView(children: [
                          Container(
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(5),
                              },
                              children: _voucherRows,
                            ),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      );
    } else {
      utility.sortAccessType(context, widget.emp);
    }
  }

  _trcDetailsRecipient(TransactionDTO trc) {
    Future<MerchantDTO> futureMerchant =
        MrcServices.getMrcProfile(trc.usrIdA, context: context);

    return Material(
      elevation: 3,
      child: Container(
        color: colors.lightBlue,
        child: ExpansionTile(
          title: Center(
            child: Text(
              VouchainLocalizations.of(context).recipient,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 52.5.sp,
                color: colors.blue,
              ),
            ),
          ),
          initiallyExpanded: true,
          children: [
            Container(
              color: Colors.white,
              child: FutureBuilder(
                future: futureMerchant,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status == "OK") {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Center(
                                    child: Text(
                                      VouchainLocalizations.of(context).name +
                                          ": ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 40.sp,
                                        color: colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      VouchainLocalizations.of(context)
                                              .surname +
                                          ": ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 40.sp,
                                        color: colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: colors.lightGrey,
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: Text(
                                      snapshot.data.mrcFirstNameReq,
                                      style: TextStyle(
                                          fontSize: 40.sp,
                                          color: colors.darkGrey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        snapshot.data.mrcLastNameReq,
                                        style: TextStyle(
                                            fontSize: 40.sp,
                                            color: colors.darkGrey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                VouchainLocalizations.of(context)
                                        .mrcBusinessName +
                                    ": ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.sp,
                                  color: colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              width: double.maxFinite,
                              decoration:
                                  BoxDecoration(color: colors.lightGrey),
                              child: Center(
                                child: Text(
                                  snapshot.data.mrcRagioneSociale,
                                  style: TextStyle(
                                      fontSize: 40.sp,
                                      color: colors.darkGrey,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                VouchainLocalizations.of(context).email + ": ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.sp,
                                  color: colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              width: double.maxFinite,
                              decoration:
                                  BoxDecoration(color: colors.lightGrey),
                              child: Center(
                                child: Text(
                                  snapshot.data.usrEmail,
                                  style: TextStyle(
                                      fontSize: 40.sp,
                                      color: colors.darkGrey,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                VouchainLocalizations.of(context).causal + ": ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.sp,
                                  color: colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: colors.lightGrey,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: Color.fromRGBO(
                                              148, 192, 224, 1)))),
                              child: Center(
                                child: Text(
                                  (trc.trcQrCausale != null)
                                      ? trc.trcQrCausale
                                      : "-",
                                  style: TextStyle(
                                      fontSize: 40.sp,
                                      color: colors.darkGrey,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                            VouchainLocalizations.of(context).errorNoDetails,
                            style: TextStyle(
                                fontSize: 45.h,
                                color: colors.darkGrey,
                                fontWeight: FontWeight.w500)),
                      );
                    }
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
                      height: 678.h,
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.symmetric(vertical: 290.h, horizontal: 385.w),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colors.blue),
                        strokeWidth: 4,
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TableRow> _trcDetailsVoucherRows(TransactionDTO trc) {
    List<TableRow> _voucherRows = [];
    for (int i = 0; i < trc.voucherList.length; i++) {
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
                  .format(double.parse(trc.voucherList[i].vchValue)),
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
                trc.voucherList[i].vchQuantity,
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
                    .format(double.parse(trc.voucherList[i].vchValue) *
                        double.parse(trc.voucherList[i].vchQuantity)),
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

  void _exportHistory() async {
    //Controlla i permessi di scrittura dell'app, se non ci sono li richiede
    if (await Permission.storage.request().isGranted) {
      //Esempio nome: "Storico_merchant01_dal_01-09-2020_al_05-09-2020.xlsx"
      String fileName = 'Storico_' +
          widget.emp.usrEmail.split('@')[0] +
          '_dal_' +
          DateFormat('dd-MM-yyyy').format(selectedRange.start).toString() +
          '_al_' +
          DateFormat('dd-MM-yyyy').format(selectedRange.end).toString() +
          '.xlsx';

      //Sceglie la directory in base al sistama operativo
      // TODO che directory vogliono?
      String dir;
      if (Platform.isAndroid) {
        dir = (await getApplicationDocumentsDirectory()).path;
      } else {
        dir = (await getApplicationDocumentsDirectory()).path;
      }

      //Richiama il servizio che resitutisce la stringa codificata
      final encodedStr = await UserServices.exportHistory(
          "employee", selectedRange, context, widget.emp);
      if (encodedStr == "empty") {
        return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).error,
                  style: TextStyle(fontSize: 52.5.sp)),
              content: Text(
                  VouchainLocalizations.of(context).noTransactionToExport,
                  style: TextStyle(fontSize: 40.sp)),
              actions: [
                FlatButton(
                    child: Text(VouchainLocalizations.of(context).okButton,
                        style: TextStyle(fontSize: 40.sp)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]),
        );
      } else if (encodedStr != "error") {
        //Decodifica la stringa
        Uint8List bytes = base64.decode(encodedStr);

        //Salva il file sul dispositivo
        File file = File("$dir/$fileName");
        await file.writeAsBytes(bytes);

        //Prepara il payload (informazioni per sapere cosa fare) per la notifica
        //e richiama il metodo per mostrarla
        Map<String, dynamic> payload = {
          'notificationType': "download",
          'filePath': "$dir/$fileName",
        };
        utility.showNotification(payload, 0,
            VouchainLocalizations.of(context).downloadCompleted, fileName);
      }
    } else {
      return utility.genericErrorAlert(context);
    }
  }
}
