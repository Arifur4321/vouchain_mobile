import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/common/Wallet.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';
import 'package:vouchain_wallet_app/merchant/MrcQRCodeList.dart';
import 'package:vouchain_wallet_app/merchant/MrcTransactionHistory.dart';

//DTO
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Timer timer;

class MrcDashboard extends StatefulWidget {
  final MerchantDTO mrc;

  MrcDashboard({Key key, @required this.mrc}) : super(key: key);

  @override
  _MrcDashboardState createState() => _MrcDashboardState();
}

class _MrcDashboardState extends State<MrcDashboard> {
  @override
  void initState() {
    super.initState();
    if (widget.mrc.notificationEnabled?.toLowerCase() == "true" && timer == null) {
      print("STO AVVIANDO IL TIMER (Dashboard)");
      utility.timedNotification(widget.mrc, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    _verifySession(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: MrcDrawerMenu(selected: 0, mrc: widget.mrc), // New Line
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(widget.mrc.usrEmail, style: TextStyle(fontSize: 52.5.sp)),
        ),

        body: Stack(
          children: [
            utility.background(),
            OrientationBuilder(builder: (context, orientation) {
              return Container(
                padding: EdgeInsets.only(top: 55.h),
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 25, bottom: 15),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  //crossAxisCount: 2,
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
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
                                        Wallet(user: widget.mrc)),
                              )
                            },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: portrait ? 42.h : 0),
                              child: Text(
                                VouchainLocalizations.of(context).wallet,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 58.sp), //22
                              ),
                            ),
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 198.h, //70
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
                                builder: (context) => MrcQRCodeList(
                                      mrc: widget.mrc,
                                    )),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              VouchainLocalizations.of(context).qrTransfer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 58.sp),
                            ),
                            Icon(Icons.qr_code,
                                color: Colors.white, size: 198.h)
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
                                    MrcTransactionHistory(mrc: widget.mrc)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: portrait ? 42.h : 0),
                              child: Text(
                                VouchainLocalizations.of(context)
                                    .transaction(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 58.sp),
                              ),
                            ),
                            Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 198.h,
                            )
                          ],
                        )),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  void _verifySession(BuildContext context) async {
    final sessionResponse =
        await UserServices.verifySession(context, widget.mrc);
    if (sessionResponse.status != "OK") {
      utility.sortAccessType(context, widget.mrc);
    }
  }
}
