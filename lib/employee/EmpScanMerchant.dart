import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vouchain_wallet_app/employee/EmpVoucherTransfer.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'EmpDashboard.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';

class EmpScanMerchant extends StatefulWidget {
  final EmployeeDTO emp;

  EmpScanMerchant({Key key, @required this.emp}) : super(key: key);

  @override
  _EmpScanMerchantState createState() => _EmpScanMerchantState(emp);
}

class _EmpScanMerchantState extends State<EmpScanMerchant> {
  final EmployeeDTO emp;

  _EmpScanMerchantState(this.emp);

  var flashState = flashOn;
  bool scanned = false;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Icon flashIcon = Icon(
    Icons.flash_on,
    size: 35,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    Future<dynamic> permission = _checkPermission();
    //controller.resumeCamera();
    return Scaffold(
      //drawer: EmpDrawerMenu(selected: 3, emp: widget.emp),
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).infoQrCode,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      body: WillPopScope(
        onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmpDashboard(emp: emp)),
            );
          return true;
        },
        child: FutureBuilder(
          future: permission,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return Stack(
                  children: <Widget>[
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: colors.blue,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          if (controller != null) {
                            controller.toggleFlash();
                            if (_isFlashOn(flashState)) {
                              setState(() {
                                flashState = flashOff;
                                flashIcon = Icon(
                                  Icons.flash_off,
                                  size: 35,
                                  color: Colors.white,
                                );
                              });
                            } else {
                              setState(() {
                                flashState = flashOn;
                                flashIcon = Icon(
                                  Icons.flash_on,
                                  size: 35,
                                  color: Colors.white,
                                );
                              });
                            }
                          }
                        },
                        //do your action
                        elevation: 1.0,
                        constraints: BoxConstraints(),
                        //removes empty spaces around of icon
                        shape: CircleBorder(),
                        //circular button
                        fillColor: colors.blue,
                        //background color
                        splashColor: colors.darkBlue,
                        highlightColor: colors.darkBlue,
                        child: flashIcon,
                        padding: EdgeInsets.all(12),
                      ),
                    ),
                    /*Positioned(
                      top: 50,
                      left: 30,
                      child: Container(
                        width: 130,
                        child: Text(
                          VouchainLocalizations.of(context).infoQrCode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? 22
                                  : 17),
                        ),
                      ),
                    )*/
                  ],
                );
              } else {
                return Center();
              }
            } else if (snapshot.hasError) {
              return utility.genericErrorAlert(context);
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    if (!scanned) {
      String text = await controller.scannedDataStream.first;
      MerchantDTO response =
          await EmpServices.getMerchantFromQrCode(text, context);
      print("MERCHANT IN TRANSFER --- " + response.usrId.toString());
      if (response.status == 'OK') {
        controller.pauseCamera();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EmpVoucherTransfer(emp: emp, mrc: response, qr: text)),
        );
      } else {
        controller.pauseCamera();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(VouchainLocalizations.of(context).invalidQrCode,
                      style: TextStyle(fontSize: 52.5.sp))),
              content: Text(VouchainLocalizations.of(context).continueScanning,
                  style: TextStyle(fontSize: 40.sp)),
              elevation: 24,
              actions: <Widget>[
                FlatButton(
                  child: Text(VouchainLocalizations.of(context).answerNo, style: TextStyle(fontSize: 40.sp)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmpDashboard(emp: emp)),
                    );
                  },
                ),
                FlatButton(
                  child: Text(VouchainLocalizations.of(context).answerYes),
                  onPressed: () {
                    Navigator.pop(context);
                    controller.resumeCamera();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmpScanMerchant(emp: emp)),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
      setState(() {
        scanned = true;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<dynamic> _checkPermission() async {
    if (await Permission.camera.request().isGranted) {
      return true;
    } else {
      return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            title: Text(
              VouchainLocalizations.of(context).allowPhoneCamera,
              style: TextStyle(fontSize: 52.5.sp),
            ),
            actions: [
              RaisedButton(
                  child: Text(VouchainLocalizations.of(context).okButton, style: TextStyle(fontSize: 40.sp)),
                  color: colors.blue,
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmpDashboard(emp: emp)))
                      })
            ]),
      );
    }
  }
}
