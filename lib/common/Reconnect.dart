import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart';
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Reconnect extends StatelessWidget {
  final user;

  Reconnect({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        background(),
        backgroundTop(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 538.w,
                height: 135.h,
                margin: EdgeInsets.only(bottom: 35),
                child: RaisedButton(
                    color: colors.blue,
                    child: Text(VouchainLocalizations.of(context).reconnect,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 44.sp)),
                    onPressed: () async {
                      timer = null;
                      String response =
                          await UserServices.resetSession(context, user);
                      if (response == "OK") {
                        if (user is EmployeeDTO) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmpDashboard(emp: user)),
                          );
                        } else if (user is MerchantDTO) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MrcDashboard(mrc: user)),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        }
                      } else {
                        genericErrorAlert(context);
                      }
                    }),
              ),
              Container(
                width: 538.w,
                height: 155.h,
                child: RaisedButton(
                  color: colors.blue,
                  padding:
                      EdgeInsets.symmetric(horizontal: 145.w, vertical: 28.h),
                  child: Text(
                      VouchainLocalizations.of(context).backTo +
                          VouchainLocalizations.of(context).homepage,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 44.sp)),
                  onPressed: () {
                    //TODO ricontrolla, deve sloggare l'utente o no?
                    //UserServices.logout(context, user);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
