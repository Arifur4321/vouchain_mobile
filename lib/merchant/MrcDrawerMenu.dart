import 'package:flutter/material.dart';
import 'package:vouchain_wallet_app/common/AccessSettings.dart';
import 'package:vouchain_wallet_app/common/Faq.dart';
import 'package:vouchain_wallet_app/common/PasswordChange.dart';
import 'package:vouchain_wallet_app/common/Support.dart';
import 'package:vouchain_wallet_app/common/Wallet.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';
import 'package:vouchain_wallet_app/merchant/MrcProfileSettings.dart';
import 'package:vouchain_wallet_app/merchant/MrcQRCodeList.dart';
import 'package:vouchain_wallet_app/merchant/MrcTransactionHistory.dart';

//DTO
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MrcDrawerMenu extends StatelessWidget {
  final MerchantDTO mrc;
  final selected;

  MrcDrawerMenu({Key key, this.selected, this.mrc}) : super(key: key);

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MrcDashboard(mrc: mrc)))
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
                        child: Text(mrc.usrEmail,
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
                                    builder: (context) => Wallet(user: mrc)));
                          }
                        })),
                Container(
                  padding: (_width > 600)
                      ? EdgeInsets.symmetric(vertical: 15)
                      : EdgeInsets.zero,
                  child: ListTile(
                      leading: Icon(Icons.qr_code_sharp,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      //Icon(Icons.share, color: colors.blueOpacity(0.9)),
                      title: Text(VouchainLocalizations.of(context).qrTransfer,
                          style: _style),
                      selected: selected == 2,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MrcQRCodeList(mrc: mrc)));
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
                        if (selected != 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MrcTransactionHistory(mrc: mrc)));
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
                        (selected == 4.1 || selected == 4.2 || selected == 4.3)
                            ? true
                            : false,
                    childrenPadding: EdgeInsets.only(left: 60),
                    title: ListTile(
                      leading: Icon(Icons.settings,
                          color: colors.blueOpacity(0.9), size: 62.w),
                      title: Text(VouchainLocalizations.of(context).settings,
                          style: _style),
                      selected: (selected == 4.1 ||
                          selected == 4.2 ||
                          selected == 4.3),
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
                            selected: (selected == 4.1),
                            onTap: () {
                              Navigator.pop(context);
                              if (selected != 4.1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MrcProfileSettings(mrc: mrc)));
                              }
                            }),
                      ),
                      ListTile(
                          title: Text(
                              VouchainLocalizations.of(context).passwordChange,
                              style: TextStyle(
                                fontSize: 34.sp,
                              )),
                          selected: (selected == 4.2),
                          onTap: () {
                            Navigator.pop(context);
                            if (selected != 4.2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PasswordChange(user: mrc)));
                            }
                          }),
                      ListTile(
                          title: Text(
                              VouchainLocalizations.of(context).accessSecurity,
                              style: TextStyle(
                                fontSize: 34.sp,
                              )),
                          selected: (selected == 4.3),
                          onTap: () {
                            Navigator.pop(context);
                            if (selected != 4.3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccessSettings(user: mrc)));
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
                      selected: selected == 5,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 5) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Faq(user: mrc)));
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
                      selected: selected == 6,
                      onTap: () {
                        Navigator.pop(context);
                        if (selected != 6) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Support(user: mrc)));
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
                      selected: selected == 7,
                      onTap: () {
                        if (mrc.notificationEnabled.toLowerCase() == "true") {
                          timer.cancel();
                          timer = null;
                        }
                        utility.logoutAlert(context, mrc);
                      }),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
