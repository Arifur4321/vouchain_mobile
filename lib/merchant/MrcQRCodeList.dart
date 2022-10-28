import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';
import 'package:vouchain_wallet_app/merchant/MrcQRDetails.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';
import 'package:vouchain_wallet_app/entity/QrCodeDTO.dart';

//Rest
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev packages
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MrcQRCodeList extends StatefulWidget {
  final MerchantDTO mrc;

  MrcQRCodeList({Key key, @required this.mrc}) : super(key: key);

  @override
  _MrcQRCodeListState createState() => _MrcQRCodeListState();
}

class _MrcQRCodeListState extends State<MrcQRCodeList> {
  Future<DTOList<dynamic>> futureList;
  bool _confirmPressed = false;

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    futureList = MrcServices.getQrList(widget.mrc, context);
    return Scaffold(
      drawer: MrcDrawerMenu(selected: 2, mrc: widget.mrc),
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).qrList,
            style: TextStyle(fontSize: 52.5.sp)),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width > 600 ) ? 60.w : 0),
              icon: Icon(Icons.add, size: 95.h),
              tooltip: VouchainLocalizations.of(context).addQrCode,
              onPressed: () => _addQrCodeDialog())
        ],
      ),
      body: LoadingOverlay(
        isLoading: _confirmPressed,
        color: colors.lightGrey,
        opacity: 0.3,
        child: FutureBuilder(
            future: futureList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DTOList<dynamic> listDto = snapshot.data;
                List<Material> rowList = [];
                if (listDto.status == "OK") {
                  for (int i = 0; i < listDto.list.length; i++) {
                    rowList.add(Material(
                      color: colors.tableRowColor(i),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 25.h),
                        title: Text(
                          VouchainLocalizations.of(context).cash +
                              listDto.list[i].qrCash,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 46.sp,
                              color: colors.darkGrey),
                        ),
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MrcQrDetails(
                                      mrc: widget.mrc,
                                      qrCode: listDto.list[i])))
                        },
                      ),
                    ));
                  }
                } else if (listDto.errorDescription == "no_qrcode_found") {
                  rowList.add(Material(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                          top: 400.h, left: 100.w, right: 100.w),
                      title: Column(
                        children: [
                          Text(
                            VouchainLocalizations.of(context).noQrCodeYet,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          RaisedButton(
                            color: colors.blue,
                            onPressed: () => _addQrCodeDialog(),
                            child: Container(
                              width: 300.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    VouchainLocalizations.of(context)
                                        .createNewQrCode,
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                } else {
                  return Text(
                      VouchainLocalizations.of(context).generalErrorRetry);
                }
                return RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: colors.blue,
                  displacement: 50,
                  onRefresh: () async {
                    setState(() {});
                    return await Future.delayed(Duration(seconds: 2));
                  },
                  child: ListView(
                    children: rowList,
                  ),
                );
              } else if (snapshot.hasError) {
                return utility.genericErrorAlert(context);
              }
              // By default, show a loading spinner.
              return Container(
                  alignment: Alignment.center,
                  //margin: EdgeInsets.only(top: 500.h),
                  child: CircularProgressIndicator(strokeWidth: 12.h));
            }),
      ),
    );
  }

  _addQrCodeDialog() async {
    //dialog
    //scelta numero cassa
    TextEditingController cashController = TextEditingController();
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                titlePadding: const EdgeInsets.all(0),
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 52.5.sp,
                    fontFamily: "Graphik"),
                title: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0))),
                    child: Text(VouchainLocalizations.of(context).newQrCode,
                        textAlign: TextAlign.center)),
                contentPadding: const EdgeInsets.all(0),
                children: [
                  Container(
                    //height: 450,
                    height: 600.h,
                    width: double.maxFinite,
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 350.w,
                            padding: EdgeInsets.only(top: 100.h, bottom: 60.h),
                            child: TextFormField(
                                controller: cashController,
                                textAlign: TextAlign.center,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return VouchainLocalizations.of(context)
                                        .insertANumber;
                                  }
                                  return null;
                                },
                                style: TextStyle(fontSize: 42.sp),
                                //16
                                decoration: InputDecoration(
                                  labelText: VouchainLocalizations.of(context)
                                      .cashNumber,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colors.blue)),
                                  border: OutlineInputBorder(),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0)),
                            child: Container(
                              margin: EdgeInsets.only(top: 40.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                      child: Text(
                                          VouchainLocalizations.of(context)
                                              .cancel,
                                          style: TextStyle(
                                              fontSize: 40.sp,
                                              color: Colors.white)),
                                      color: colors.darkGrey,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 42.w, vertical: 28.h),
                                      onPressed: () =>
                                          {Navigator.pop(context)}),
                                  RaisedButton(
                                      child: Text(
                                          VouchainLocalizations.of(context)
                                              .confirm,
                                          style: TextStyle(
                                              fontSize: 40.sp,
                                              color: Colors.white)),
                                      color: colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 42.w, vertical: 28.h),
                                      onPressed: () => {
                                            Navigator.pop(context),
                                            _addQrCode(cashController.text)
                                          })
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]));
  }

  _addQrCode(String cash) async {
    //modifica merchant con cassa
    //invia richiesta servizio
    //esamina richiesta servizio
    //errore o reindirizza a nuova pagina
    setState(() {
      _confirmPressed = true;
    });

    widget.mrc.mrcCash = cash;
    QrCodeDTO qrCode =
        await MrcServices.manageQrCode(widget.mrc, "ins", context);
    if (qrCode.status == "OK") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MrcQrDetails(mrc: widget.mrc, qrCode: qrCode)));
    } else if (qrCode.errorDescription == "qr_esistente") {
      setState(() {
        _confirmPressed = false;
      });
      utility.genericErrorAlert(context, msg: VouchainLocalizations.of(context).existingQrCode);
    } /*else {
      utility.genericErrorAlert(context);
    }*/
    setState(() {
      _confirmPressed = false;
    });
  }
}
