import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vouchain_wallet_app/employee/EmpLogin.dart';

//import 'package:vouchain_wallet_app/merchant/MrcLogin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vouchain_wallet_app/merchant/MrcLogin.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          utility.background(),
          utility.backgroundTop(),
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: (portrait) ? 370.h : 120.w,
                  bottom: (portrait) ? 120.h : 120.w,
                  //left: 200.w,
                  //right: 200.w,
                ),
                child: Image(
                  width: (portrait) ? 0.62.sw : 0.292.sw,
                  image: AssetImage("assets/images/vouchain_logo_vert_blugrigio.png"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(20.0, 15),
                        )),
                    child: MaterialButton(
                      height: (portrait) ? 0.365.sw : 0.365.sh,
                      minWidth: (portrait) ? 0.365.sw : 0.365.sh,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/images/emp_icon_bianco.png"),
                            width: 215.w,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 40.h, bottom: 0),
                            child: Text(
                              VouchainLocalizations.of(context).employee,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 46.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmpLogin()),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(20.0, 15),
                        )),
                    child: MaterialButton(
                      height: (portrait) ? 0.365.sw : 0.365.sh,
                      minWidth: (portrait) ? 0.365.sw : 0.365.sh,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/images/mrc_icon_bianco.png"),
                            width: 216.w,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 42.h, bottom: 0),
                            child: Text(
                              VouchainLocalizations.of(context).merchant(1),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 46.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MrcLogin()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ))
        ]),
      ),
    );
  }
}
