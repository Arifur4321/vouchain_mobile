import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/common/Faq.dart';
import 'package:vouchain_wallet_app/common/PasswordChange.dart';
import 'package:vouchain_wallet_app/common/Support.dart';
import 'package:vouchain_wallet_app/common/Wallet.dart';
import 'package:vouchain_wallet_app/common/AccessSettings.dart';
import 'package:vouchain_wallet_app/employee/EmpDashboard.dart';
import 'package:vouchain_wallet_app/employee/EmpMerchantShowcase.dart';
import 'package:vouchain_wallet_app/employee/EmpScanMerchant.dart';
import 'package:vouchain_wallet_app/employee/EmpProfileSettings.dart';
import 'package:vouchain_wallet_app/employee/EmpTransactionHistory.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmpDrawerMenu extends StatelessWidget {
  final EmployeeDTO emp;
  final selected;

  EmpDrawerMenu({Key key, this.selected, this.emp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    TextStyle _style = TextStyle(fontSize: 36.8.sp);
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: 798.w, //304,
      child: Drawer(
          child: Column(
        children: [
          Container(
            height: 475.h, //169,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: InkWell(
                      onTap: () => {
                        Navigator.pop(context),
                        if (selected != 0)
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmpDashboard(emp: emp)))
                          }
                      }, // handle your onTap here
                      child: Container(
                        //padding: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(right: 20.w),
                        child: Image.asset(
                            'assets/images/vouchain_logo_orizz_bianco.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 21.w, bottom: 15.h),
                        child: Text(emp.usrEmail,
                            style: TextStyle(
                                color: Colors.white, fontSize: 44.5.sp)),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: colors.blue),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.account_balance_wallet,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(
                          VouchainLocalizations.of(context).walletManagement,
                          style: _style),
                      selected: selected == 1,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wallet(user: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.place,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(
                          VouchainLocalizations.of(context).merchantShowcase,
                          style: _style),
                      selected: selected == 2,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmpMerchantShowcase(emp: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Image(
                          width: 70.w, //25+,
                          image:
                              AssetImage("assets/images/voucher_icon_white.png"),
                          color: colors.blueOpacity(0.9),
                        ),
                      ),
                      // Icon(Icons.apps, color: colors.blueOpacity(0.9)),
                      title: Text(VouchainLocalizations.of(context).payment,
                          style: _style),
                      selected: selected == 3,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmpScanMerchant(emp: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.history,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(
                          VouchainLocalizations.of(context).transactionHistory,
                          style: _style),
                      selected: selected == 4,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmpTransactionHistory(emp: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.only(right: 15, top: 0),
                    backgroundColor: Color.fromRGBO(168, 219, 255, 0.3),
                    initiallyExpanded:
                        (selected == 5.1 || selected == 5.2 || selected == 5.3)
                            ? true
                            : false,
                    childrenPadding: EdgeInsets.only(left: 60),
                    title: ListTile(
                      leading: Icon(Icons.settings,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(VouchainLocalizations.of(context).settings, style: _style),
                      selected: (selected == 5.1 ||
                          selected == 5.2 ||
                          selected == 5.3),
                    ),
                    children: [
                      Container(
                        child: ListTile(
                            title: Text(
                              VouchainLocalizations.of(context).showProfile,
                              style: TextStyle(
                                fontSize: 34.sp,
                              ),
                            ),
                            selected: (selected == 5.1),
                            onTap: () {
                              Navigator.pop(context);
                              if (selected != 5.1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmpProfileSettings(emp: emp)));
                              }
                            }),
                      ),
                      ListTile(
                          title: Text(VouchainLocalizations.of(context).passwordChange,
                              style: TextStyle(
                                fontSize: 34.sp,
                              )),
                          selected: (selected == 5.2),
                          onTap: () {
                            Navigator.pop(context);
                            if (selected != 5.2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PasswordChange(user: emp)));
                            }
                          }),
                      ListTile(
                          title: Text(VouchainLocalizations.of(context).accessSecurity,
                              style: TextStyle(
                                fontSize: 34.sp,
                              )),
                          selected: (selected == 5.3),
                          onTap: () {
                            Navigator.pop(context);
                            if (selected != 5.3) {
                              //print("UNO --- " + emp.toString());
                              //print("DUE ---- " + emp.accessType.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccessSettings(user: emp)));
                            }
                          })
                    ],
                  ),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.help_outline,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(VouchainLocalizations.of(context).faq,
                          style: _style),
                      selected: selected == 6,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 6) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Faq(user: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.info_outline,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(
                          VouchainLocalizations.of(context).customerService,
                          style: _style),
                      selected: selected == 7,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 7) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Support(user: emp)));
                        }
                      }),
                ),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.exit_to_app,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(VouchainLocalizations.of(context).logout,
                          style: _style),
                      selected: selected == 8,
                      onTap: () => utility.logoutAlert(context, emp)),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
