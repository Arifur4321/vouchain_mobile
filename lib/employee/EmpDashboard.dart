import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/common/Wallet.dart';
import 'package:vouchain_wallet_app/employee/EmpMerchantShowcase.dart';
import 'package:vouchain_wallet_app/employee/EmpScanMerchant.dart';
import 'package:vouchain_wallet_app/employee/EmpTransactionHistory.dart';
import 'dart:async';
//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class EmpDashboard extends StatefulWidget {
  final EmployeeDTO emp;

  EmpDashboard({Key key, @required this.emp}) : super(key: key);

  @override
  _EmpDashboardState createState() => _EmpDashboardState();
}

class _EmpDashboardState extends State<EmpDashboard> {


  

 Timer timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => addValue());
  }

  void addValue() {
    setState(() {
       counter++; 
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  Future<DTOList<dynamic>> futureList;

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    //bool _errorCalled = false;
    //Richiamo il servizio dei voucher per poter mostrare i valori del riepilogo
    futureList = EmpServices.empVoucherList(widget.emp, context);
    /*futureList.timeout(Duration(seconds: 15), onTimeout: () {
      return DTOList(status: "KO");
    }).then((value) => {
          if (value.status != 'OK' && !_errorCalled)
            {
              _errorCalled = true,
              alert.genericErrorAlert(context),
            }
        });*/

//{return alert.genericErrorAlert(context, EmpDashboard(emp: emp));}

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: EmpDrawerMenu(selected: 0, emp: widget.emp), // New Line
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(widget.emp.usrEmail, style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: Stack(
          children: [
            utility.background(),
            RefreshIndicator(
              color: Colors.white,
              backgroundColor: colors.blue,
              onRefresh: () async {
                setState(() {});
                return await Future.delayed(Duration(seconds: 2));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    (portrait)
                        ? Card(
                            child: Container(
                                decoration:
                                    BoxDecoration(color: colors.lightBlue),
                                padding: EdgeInsets.only(top: 0.8.h, bottom: 0.8.h),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                          VouchainLocalizations.of(context)
                                              .avaibleBalance,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: colors.darkBlue,
                                            fontSize: 45.sp,
                                          )),
                                      trailing: _availableBalance(),
                                      leading: Icon(
                                        Icons.euro_symbol,
                                        size: 60.h,
                                        color: colors.darkBlue,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                          VouchainLocalizations.of(context)
                                              .remainVouchers,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: colors.darkBlue,
                                            fontSize: 45.sp,
                                          )),
                                      trailing: _voucherQuantity(),
                                      leading: Icon(
                                        Icons.card_giftcard,
                                        size: 60.h,
                                        color: colors.darkBlue,
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: colors.lightBlue),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                                VouchainLocalizations.of(
                                                        context)
                                                    .avaibleBalance,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.darkBlue,
                                                  fontSize: 45.sp,
                                                )),
                                            trailing: _availableBalance(),
                                            leading: Icon(
                                              Icons.euro_symbol,
                                              size: 45.h,
                                              color: colors.darkBlue,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Container(
                                      width: 280.w,
                                      decoration: BoxDecoration(
                                          color: colors.lightBlue),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                                VouchainLocalizations.of(
                                                        context)
                                                    .remainVouchers,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.darkBlue,
                                                  fontSize: 45.sp,
                                                )),
                                            trailing: _voucherQuantity(),
                                            leading: Icon(
                                              Icons.card_giftcard,
                                              size: 45.h,
                                              color: colors.darkBlue,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                    Container(
                      height: 0.85.sh,
                      child:
                          OrientationBuilder(builder: (context, orientation) {
                        return GridView.count(
                          primary: false,
                          //TODO rendere relative
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 25, bottom: 15),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          //crossAxisCount: 2,
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          children: <Widget>[
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.elliptical(20.0, 15),
                                )),
                                color: colors.blue,
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Wallet(user: widget.emp)),
                                      )
                                    },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      VouchainLocalizations.of(context).wallet,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: (portrait) ? 57.sp : 50.sp),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 20.h),
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          color: Colors.white,
                                          size: 198.h,
                                        ))
                                  ],
                                )),
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.elliptical(20.0, 15),
                                )),
                                color: colors.blue,
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmpMerchantShowcase(
                                                    emp: widget.emp)),
                                      )
                                    },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      VouchainLocalizations.of(context)
                                          .merchant(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: (portrait) ? 57.sp : 50.sp),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 20.h),
                                        child: Icon(
                                          Icons.place,
                                          color: Colors.white,
                                          size: 198.h,
                                        ))
                                  ],
                                )),
                            RaisedButton(
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
                                            EmpScanMerchant(emp: widget.emp)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      VouchainLocalizations.of(context).payment,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: (portrait) ? 57.sp : 50.sp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 60.h),
                                      child: Image(
                                        width: 250.h,
                                        image: AssetImage(
                                            "assets/images/voucher_icon_white.png"),
                                      ),
                                    )
                                  ],
                                )),
                            RaisedButton(
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
                                            EmpTransactionHistory(
                                                emp: widget.emp)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      VouchainLocalizations.of(context)
                                          .transaction(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: (portrait) ? 57.sp : 50.sp),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 20.h),
                                        child: Icon(
                                          Icons.history,
                                          color: Colors.white,
                                          size: 200.h,
                                        ))
                                  ],
                                )),
                          ],
                        );
                      }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _availableBalance() {
    return Container(
      width: 280.w,
      // Utilizzo il future restituito dal servizio per calcolare
      // il valore che mi serve e mostrarlo quando si caricano i dati
      child: FutureBuilder<DTOList<dynamic>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double sum = 0;
            if (snapshot.data.status == "OK") {
              for (var i = 0; i < snapshot.data.list.length; i++) {
                sum = sum +
                    (double.parse(snapshot.data.list[i].vchValue) *
                        double.parse(snapshot.data.list[i].vchQuantity));
              }
              //TODO
              return Text(
                  //sum.toStringAsFixed(2) + VouchainLocalizations.of(context).valueSign,
                  NumberFormat.currency(
                          locale: "eu",
                          symbol: "€",
                          name: "EUR",
                          decimalDigits: 2)
                      .format(sum),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.darkBlue,
                    fontSize: 45.sp,
                  ));
            } else {
              //utility.genericErrorAlert(context);
              return Text(" - ",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.darkBlue,
                    fontSize: 44.sp,
                  ));
            }
          } else if (snapshot.hasError) {
            //utility.genericErrorAlert(context);
            return Text(" - ",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colors.darkBlue,
                  fontSize: 44.sp,
                ));
          }
          // By default, show a loading spinner.
          return Container(
              height: 60.h,
              margin: EdgeInsets.only(right: 45.w, left: 140.w),
              child: CircularProgressIndicator());
        },
      ),
    );
  }
_voucherQuantity() {
    return Container(
      width: 270.w,
      // Utilizzo il future restituito dal servizio per calcolare
      // il valore che mi serve e mostrarlo quando si caricano i dati
      child: FutureBuilder<DTOList<dynamic>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int sum = 0;
            if (snapshot.data.status == "OK") {

           
              
              for (var i = 0; i < snapshot.data.list.length; i++) {
        
                sum = sum + int.parse( snapshot.data.list[i].vchQuantity );

                
              }
              
              return Text(
              NumberFormat.decimalPattern().format(sum) ,
                  
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.darkBlue,
                    fontSize: 45.sp,
                  ));


            } else {
              return Text(" - ",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.darkBlue,
                    fontSize: 45.sp,
                  ));
            }
          } else if (snapshot.hasError) {
            return Text(" - ",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colors.darkBlue,
                  fontSize: 45.sp,
                ));
          }
          // By default, show a loading spinner.
          return Container(
            height: 60.h,
            margin: EdgeInsets.only(right: 45.w, left: 140.w),
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}