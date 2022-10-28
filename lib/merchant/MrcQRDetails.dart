import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

//DTO
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/QrCodeDTO.dart';
import 'package:vouchain_wallet_app/merchant/MrcQRCodeList.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MrcQrDetails extends StatefulWidget {
  final MerchantDTO mrc;
  final QrCodeDTO qrCode;

  MrcQrDetails({Key key, @required this.mrc, this.qrCode}) : super(key: key);

  @override
  _MrcQrDetailsState createState() => _MrcQrDetailsState();
}

class _MrcQrDetailsState extends State<MrcQrDetails> {
  _MrcQrDetailsState();

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    return Scaffold(
      //drawer: MrcDrawerMenu(selected: 2, mrc: widget.mrc),
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(
            VouchainLocalizations.of(context).cash + widget.qrCode.qrCash,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: (portrait) ? 400.h : 100.h),
                child: (widget.qrCode.qrImage != null) ? Image.memory(base64.decode(widget.qrCode.qrImage)):Container()),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 45,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Icon(
                                Icons.save,
                                size: 86.h,
                                color: Colors.white,
                              )),
                          Flexible(
                            flex: 80,
                            child: Container(
                              //padding: EdgeInsets.only(left: 5),
                              child: Text(
                                VouchainLocalizations.of(context).download,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: (portrait) ? 48.sp : 50.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.elliptical(20.0, 15),
                      )),
                      color: colors.blue,
                      onPressed: () => _downloadQrCode(),
                    ),
                  ),
                  Flexible(flex: 10, child: SizedBox()),
                  Flexible(
                    flex: 45,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              flex: 20,
                              child: Icon(
                                Icons.delete,
                                size: 86.h,
                                color: Colors.white,
                              )),
                          Flexible(
                            flex: 80,
                            child: Container(
                              //padding: EdgeInsets.only(left: 10),
                              child: Text(
                                VouchainLocalizations.of(context).delete,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: (portrait) ? 48.sp : 50.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.elliptical(20.0, 15),
                      )),
                      color: colors.blue,
                      onPressed: () => _deleteQrCode(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteQrCode() async {
    widget.mrc.mrcCash = widget.qrCode.qrCash;
    QrCodeDTO qrCode =
        await MrcServices.manageQrCode(widget.mrc, "can", context);
    if (qrCode.status == "OK") {
      setState(() {});
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              content: Text(
                VouchainLocalizations.of(context).qrCodeDeleted,
                style: TextStyle(fontSize: 52.5.sp),
              ),
              actions: [
                FlatButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 42.w, vertical: 28.h),
                    child: Text(VouchainLocalizations.of(context).okButton,
                        style: TextStyle(fontSize: 40.sp)),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ]),
        ),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MrcQRCodeList(mrc: widget.mrc),
        ),
      );
    } else if (qrCode.errorDescription == "Qr Code non esistente") {
      utility.genericErrorAlert(context, msg: VouchainLocalizations.of(context).nonExistingQrCode);
    } else {
      print("ERRORE ---- " + qrCode.errorDescription.toString());
      utility.genericErrorAlert(context);
    }
  }

  _downloadQrCode() async {
    //Controlla i permessi di scrittura dell'app, se non ci sono li richiede
    if (await Permission.storage.request().isGranted) {
      //Esempio nome: "QRCode_merchant01_cassa_1.jpg"
      String fileName = 'QRCode_' +
          widget.mrc.usrEmail.split('@')[0] +
          "_cassa_" +
          widget.qrCode.qrCash +
          '.jpg';

      //Sceglie la directory in base al sistama operativo
      // TODO che directory vogliono?
      String dir;
      if (Platform.isAndroid) {
        dir = (await getApplicationDocumentsDirectory()).path;
      } else {
        dir = (await getApplicationDocumentsDirectory()).path;
      }

      //Richiama il servizio che resitutisce la stringa codificata
      final encodedStr = widget.qrCode.qrImage;
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
      utility.showNotification(
          payload,
          0,
          VouchainLocalizations.of(context).downloadCompleted,
          VouchainLocalizations.of(context).qrCodeCash + widget.qrCode.qrCash);
    } else {
      return utility.genericErrorAlert(context);
    }
  }
}
