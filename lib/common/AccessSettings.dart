import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:vouchain_wallet_app/common/Fingerprint.dart';
import 'package:vouchain_wallet_app/common/NewPin.dart';
import 'package:vouchain_wallet_app/common/Pin.dart';
import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/merchant/MrcDashboard.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Rest
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';

class AccessSettings extends StatefulWidget {
  final dynamic user;

  AccessSettings({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccessSettingsState(
        user: user,
        accessType: user.accessType,
        notification: (user.notificationEnabled?.toLowerCase() == "true"));
  }
}

class AccessSettingsState extends State<AccessSettings> {
  final dynamic user;
  String accessType;
  StatelessWidget _drawer;
  String _profile;
  bool notification;
  bool _switchPressed = false;

  AccessSettingsState({this.user, this.accessType, this.notification});

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    bool tablet = (portrait)
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    _sortUser(context);
    double leftPadding = 0;
    if (portrait) {
      if (tablet) {
        leftPadding = 0.26.sw;
      }
    } else {
      leftPadding = 0.293.sw;
    }
    //print("TRE --- " + user.accessType.toString());
    //print("PROFILE (access settings) --- $profile");
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        drawer: _drawer,
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).accessSecurity,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: LoadingOverlay(
          isLoading: _switchPressed,
          color: colors.lightGrey,
          opacity: 0.3,
          child: Stack(fit: StackFit.expand, children: <Widget>[
            utility.background(),
            ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 20,
                          bottom: (portrait) ? 20 : 0,
                          left: 78.w,
                          right: 78.w),
                      child: Text(
                        VouchainLocalizations.of(context).accessType,
                        style: TextStyle(
                            fontFamily: "Graphik",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: 65.sp), //25
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: leftPadding, top: (tablet) ? 55.h : 0),
                      child: RadioListTile(
                        title: Text(
                          VouchainLocalizations.of(context).normalAccess,
                          style: TextStyle(fontSize: 47.3.sp),
                        ),
                        value: null,
                        groupValue: accessType,
                        onChanged: (newValue) =>
                            setState(() => accessType = newValue),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: leftPadding),
                      child: RadioListTile(
                        title: Text('Fingerprint',
                            style: TextStyle(fontSize: 47.3.sp)),
                        value: "FINGER",
                        groupValue: accessType,
                        onChanged: (newValue) =>
                            setState(() => accessType = newValue),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: leftPadding, bottom: (tablet) ? 75.h : 0),
                      child: RadioListTile(
                        title: Text(VouchainLocalizations.of(context).pinAccess,
                            style: TextStyle(fontSize: 47.3.sp)),
                        value: "PIN",
                        groupValue: accessType,
                        onChanged: (newValue) =>
                            setState(() => accessType = newValue),
                      ),
                    ),
                    RaisedButton(
                      color: colors.blue,
                      padding: EdgeInsets.symmetric(
                          horizontal: 60.w, vertical: 28.h),
                      onPressed: () {
                        _onTypeChosen(accessType);
                      },
                      child: Text(
                        VouchainLocalizations.of(context).confirm,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36.5.sp),
                      ),
                    ),
                    if (user is MerchantDTO) SizedBox(height: 25.h),
                    if (user is MerchantDTO) Divider(thickness: 1),
                    if (user is MerchantDTO)
                      Container(
                        margin: EdgeInsets.only(
                            left: (portrait) ? 70.w : 0.26.sw,
                            bottom: (tablet) ? 75.h : 0,
                            right: (portrait) ? 70.w : 0.26.sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                VouchainLocalizations.of(context)
                                    .transactionsNotification,
                                style: TextStyle(fontSize: 47.3.sp)),
                            Container(
                              child: Switch(
                                  value: notification,
                                  onChanged: (value) {
                                    _onNotificationChanged(value);
                                  }),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ],
            ),
          ]),
        ));
  }

  //Riconosce il tipo di utente e imposta il drawer e il servizio da usare
  void _sortUser(BuildContext context) {
    if (user is EmployeeDTO) {
      _drawer = EmpDrawerMenu(selected: 5.3, emp: user);
      _profile = "employee";
    } else if (user is MerchantDTO) {
      _drawer = MrcDrawerMenu(selected: 4.3, mrc: user);
      _profile = "merchant";
    } else {
      utility.genericErrorAlert(context);
    }
  }

  void _onTypeChosen(String value) async {
    final sessionResponse = await UserServices.verifySession(context, user);
    if (sessionResponse.status == "OK") {
      if (value != user.accessType) {
        switch (value.toString()) {
          case "null":
            {
              if (user.accessType == "PIN") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Pin(
                              user: user,
                              profile: _profile,
                              task: "delete",
                            )));
              } else if (user.accessType == "FINGER") {
                Fingerprint().removeFingerprintAccess(user, context);
              }
              break;
            }
          case "PIN":
            {
              if (user.accessType == null) {
                //print("PROFILE (AccessSettings) $profile");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewPin(user: user, profile: _profile)));
              } else if (user.accessType == "FINGER") {
                Fingerprint().changeToPin(user, context, _profile);
              }
              break;
            }
          case "FINGER":
            {
              if (user.accessType == null) {
                Fingerprint().setFingerprintAccess(user, context);
              } else if (user.accessType == "PIN") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Pin(
                            user: user,
                            profile: _profile,
                            task: "fingerprint")));
              }
              break;
            }
        }
      } else {
        return showDialog<void>(
          barrierDismissible: true,
          context: context,
          builder: (_) => AlertDialog(
              title: Text(VouchainLocalizations.of(context).inUseMode,
                  style: TextStyle(fontSize: 52.5.sp)),
              actions: [
                RaisedButton(
                    child: Text(VouchainLocalizations.of(context).okButton),
                    color: colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    onPressed: () => {Navigator.pop(context)})
              ]),
        );
      }
    } else {
      utility.sortAccessType(context, user);
    }
  }

  _onNotificationChanged(bool value) async {
    setState(() {
      _switchPressed = true;
      notification = value;
    });
    if (notification) {
      print("STO AVVIANDO IL TIMER (Settings)");
      utility.timedNotification(user, context);
    } else {
      print("STO CANCELLANDO IL TIMER (Dashboard)");
      timer.cancel();
    }
    user.notificationEnabled = notification.toString();
    print("NOTIFICHE (AccessSettings) ---- $notification");
    MerchantDTO response = await MrcServices.modMrcProfile(user, context);
    setState(() {
      _switchPressed = false;
    });
  }
}
