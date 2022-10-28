import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/entity/MerchantDTO.dart';

//REST Services
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Wallet extends StatefulWidget {
  final user;

  Wallet({Key key, @required this.user}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Future<DTOList<dynamic>> futureList;

  StatelessWidget drawer;

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    _sortUser(context);

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).walletManagement,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: colors.blue,
          onRefresh: () async {
            setState(() {});
            return await Future.delayed(Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              
                 Container(
                  decoration: BoxDecoration(color: colors.lightBlue),
                  child: Padding(
                    padding: (portrait)
                        ? EdgeInsets.only(top: 75.h, bottom: 55.h)
                        : EdgeInsets.only(top: 60.h, bottom: 15.h),
                    child: Container(
                      child: ListTile(
                        title:
                            Text(VouchainLocalizations.of(context).yourWallet,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.darkBlue,
                                  fontSize: 57.8.sp,
                                )),
                        trailing: _availableBalance(),
                        leading: Padding(
                          padding: EdgeInsets.only(left: 26.w),
                          child: Image(
                            image: AssetImage("assets/images/wallet_icon.png"),
                            //TODO need immagine più grande
                            width: 165.w,
                            color: colors.darkBlue,
                          ),
                        
                        ),
                      ),
                    ),
                  ),
                ),
                
                  
                 


               Row(
                 
                children: <Widget>[
                   Expanded(
                     flex : 40,
                 child:  Container(
                 height: 110.h,
                  decoration: BoxDecoration(color: colors.lightBlue),
                  child:  Container(
                      child: ListTile(
                        title:
                            Text(VouchainLocalizations.of(context).okicon,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.darkBlue,
                                  fontSize: 34.8.sp,
                                )),
                       
                        leading: Padding(
                          padding: EdgeInsets.only(left: 66.w),
                          child: Image(
                            image: AssetImage("assets/images/ok_icon.png"),
                            //TODO need immagine più grande
                            width: 50.w,
                             
                          ),
                          
                        ),
                      ),
                    ),
                  
                ),

                   ),
                   Expanded(
                     flex : 40,
                    child:  Container(
                      height: 110.h,
                  decoration: BoxDecoration(color: colors.lightBlue),
                  child:   Container(
                      child: ListTile(
                        title:
                            Text(VouchainLocalizations.of(context).redicon,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.darkBlue,
                                  fontSize: 34.8.sp,
                                )),
                       
                        leading: Padding(
                          padding: EdgeInsets.only(left: 66.w),
                          child: Image(
                            image: AssetImage("assets/images/red_icon2.jpg"),
                            //TODO need immagine più grande
                            width: 50.w,
                         
                          ),
                          
                        ),
                      ),
                    ),
                  
                ),
                   ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 25,
                    child: Container(
                      height: 168.5.h,
                      decoration: BoxDecoration(
                          color: colors.lightBlue,
                          border: Border(
                            bottom: BorderSide(
                                width: 5.h,
                                color: Theme.of(context).dividerColor),
                            //right: BorderSide(width: 2,color: Theme.of(context).dividerColor)
                          )),
                      padding: EdgeInsets.only(top: 55.h),
                      child: Text(
                        VouchainLocalizations.of(context).walletValue,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 52.5.sp,
                          color: colors.blue,
                        ),
                      ),
                    ),
                  ),

                
                 Expanded(
                    flex: 25,
                    child: Container(
                      height: 168.5.h,
                      decoration: BoxDecoration(
                          color: colors.lightBlue,
                          border: Border(
                            bottom: BorderSide(
                                width: 3.w,
                                color: Theme.of(context).dividerColor),
                            //right: BorderSide(width: 2,color: Theme.of(context).dividerColor)
                          )),
                      padding: EdgeInsets.only(top: 55.h),
                      child: Text(
                        VouchainLocalizations.of(context).Status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 52.5.sp,
                          color: colors.blue,
                        ),
                      ),
                    ),
                  ),   
                  
                  Expanded(
                    flex: 25,
                    child: Container(
                      height: 168.5.h,
                      decoration: BoxDecoration(
                          color: colors.lightBlue,
                          border: Border(
                              bottom: BorderSide(
                                  width: 5.h,
                                  color: Theme.of(context).dividerColor))),
                      padding: EdgeInsets.only(top: 55.h), //, left: 10),

                      child: Text(
                        VouchainLocalizations.of(context).expirationDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 52.5.sp,
                            color: colors.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 25,
                    child: Container(
                      height: 168.5.h,
                      decoration: BoxDecoration(
                          color: colors.lightBlue,
                          border: Border(
                            bottom: BorderSide(
                                width: 5.h,
                                color: Theme.of(context).dividerColor),
                            //left: BorderSide( width: 2, color: Theme.of(context).dividerColor)
                          )),
                      padding: EdgeInsets.only(top: 55.h),
                      child: Text(
                        VouchainLocalizations.of(context).quantity,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 52.5.sp,
                            color: colors.blue),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 0.7.sh,
                child: FutureBuilder(
                    future: futureList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DTOList<dynamic> listDto = snapshot.data;
                        List<TableRow> rowList = [];

                        if (listDto.status == "OK") {
                          final time = DateTime.now();
                           String t = "$time";


                          for (var i = 0; i < listDto.list.length; i++) {
                            print ( "first condition " + listDto.list[i].vchEndDate + "t value" + t );
                            if ( listDto.list[i].vchEndDate.compareTo(t) > 0 )  {

                            rowList.add(
                              TableRow(
                                decoration: BoxDecoration(
                                  color: colors.tableRowColor(i),
                                ),
                                children: [
                                  TableCell(
                                    child: Container(
                                      
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(
                                          top: 42.5.h,
                                          bottom: 42.5.h,
                                          right: (portrait) ? 120.w : 230.w
                                          ),
                                      child: Text(
                                        NumberFormat.currency(
                                                locale: "eu",
                                                symbol: "€",
                                                name: "EUR",
                                                decimalDigits: 2)
                                            .format(double.parse(
                                                listDto.list[i].vchValue)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 33.5.sp),
                                      ),
                                    ),
                                  ),
                                  
                          

                                 

                                  TableCell(
                                    child: Container(
                                      width : 120.w ,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(
                                          top: 42.5.h,
                                          bottom: 42.5.h,
                                          right: (portrait)? 81.w : 160.w
                                          ),
                                      child: Image(
                                      image: AssetImage("assets/images/ok_icon.png"),
                                      //TODO need immagine più grande
                                      width: 60.w,
                                      alignment: Alignment.centerRight,
                                    ),
                                    ),
                                  ),

                         
                                

                                  TableCell(
                                      child: Container(
                                        width : 110 ,
                                    alignment: Alignment(1.0 , 0.0) ,
                                    padding: EdgeInsets.only(
                                        top: 42.5.h,
                                        bottom: 42.5.h,
                                        right: (portrait) ? 85.w : 270.w),
                                    child: Text(
                                      listDto.list[i].vchEndDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: colors.darkGrey,
                                          fontSize: 33.5.sp),
                                    ),
                                  )),
                                  TableCell(
                                      child: Container(
                                          width: 180.w,
                                          alignment:  Alignment.centerRight,
                                    padding: EdgeInsets.only(
                                        top: 42.5.h,
                                        bottom: 42.5.h,
                                        right: (portrait) ? 100.w : 200.h),
                                    child: Text(listDto.list[i].vchQuantity,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 33.5.sp)),
                                  )),
                                ],
                              ),
                            );
                           }
                          
                           else {

                               rowList.add(
                              TableRow(
                                decoration: BoxDecoration(
                                  color: colors.tableRowColor(i),
                                ),
                                children: [
                                  TableCell(
                                    child: Container(
                                       
                                       alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(
                                          top: 42.5.h,
                                          bottom: 42.5.h,
                                          right: (portrait) ? 120.w : 230.w
                                          ),
                                      child: Text(
                                        NumberFormat.currency(
                                                locale: "eu",
                                                symbol: "€",
                                                name: "EUR",
                                                decimalDigits: 2)
                                            .format(double.parse(
                                                listDto.list[i].vchValue)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colors.darkGrey,
                                            fontSize: 33.5.sp),
                                      ),
                                    ),
                                  ),
                                  
                          

                                 

                                  TableCell(
                                    child: Container(
                                      width:120,
                                      alignment: Alignment(0.0,0.0),
                                      padding: EdgeInsets.only(
                                          top: 42.5.h,
                                          bottom: 42.5.h,
                                          right: (portrait) ? 81.w : 160.w

                                          ),
                                      child: Image(
                                      image: AssetImage("assets/images/red_icon2.jpg"),
                                      //TODO need immagine più grande
                                      width: 60.w,
                                      
                                    ),
                                    ),
                                  ),




                                  TableCell(
                                      child: Container(
                                        width : 200 ,
                                        alignment: Alignment(1.0 , 0.0) ,
                                        padding: EdgeInsets.only(
                                            top: 42.5.h,
                                            bottom: 42.5.h,
                                            right: (portrait) ? 85.w : 270.w),
                                        child: Text(
                                          listDto.list[i].vchEndDate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colors.darkGrey,
                                              fontSize: 33.5.sp),
                                        ),
                                      )),
                                  TableCell(
                                      child: Container(
                                        width: 180.w,
                                        alignment:  Alignment.centerRight,
                                        padding: EdgeInsets.only(
                                            top: 42.5.h,
                                            bottom: 42.5.h,
                                            right: (portrait) ? 100.w : 200.h),
                                        child: Text(listDto.list[i].vchQuantity,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colors.darkGrey,
                                                fontSize: 33.5.sp)),
                                      )),
                                ],
                              ),
                            );

                           }



                         }
                      }

                        return ListView(
                          children: [
                            Container(
                              color: colors.lightBlue,
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(3.2),
                                  1: FlexColumnWidth(1.1),
                                  2: FlexColumnWidth(3.3),
                                  3: FlexColumnWidth(2.4),
                                  
                                },
                                children: rowList,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return utility.genericErrorAlert(context);
                      }
                      // By default, show a loading spinner.
                      return Container(
                          width: 130.h,
                          //height: 130.h,
                          margin: EdgeInsets.only(top: 250.h, bottom: 0.5.sh),
                          child: CircularProgressIndicator(strokeWidth: 13.h));
                    }),
              ),
            ]),
          ),
        ));
  }

  void _sortUser(BuildContext context) {
    if (widget.user is EmployeeDTO) {
      drawer = EmpDrawerMenu(selected: 1, emp: widget.user);
      futureList = EmpServices.empVoucherListAll(widget.user, context);
    } else if (widget.user is MerchantDTO) {
      drawer = MrcDrawerMenu(selected: 1, mrc: widget.user);
      futureList = MrcServices.mrcVoucherList(widget.user, context);
    } else {
      utility.genericErrorAlert(context);
    }
  }

  _availableBalance() {
    return Container(
      //width: 100,
      child: FutureBuilder(
          future: futureList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final DTOList<dynamic> listDTO = snapshot.data;
              if (listDTO.status == "OK") {
                double sum = 0;
                for (var i = 0; i < listDTO.list.length; i++) {
                  sum = sum +
                      double.parse(listDTO.list[i].vchValue) *
                          double.parse(snapshot.data.list[i].vchQuantity);
                }
                return Text(
                  NumberFormat.currency(
                          locale: "eu",
                          symbol: "€",
                          name: "EUR",
                          decimalDigits: 2)
                      .format(sum),
                  style: TextStyle(
                      fontSize: 57.3.sp,
                      color: colors.darkBlue,
                      fontWeight: FontWeight.bold),
                );
              }
            } else if (snapshot.hasError) {
              return utility.genericErrorAlert(context);
            }
            // By default, show a loading spinner.
            return Container(
                height: 85.h,
                width: 85.h,
                margin: EdgeInsets.only(right: 60.w),
                child: CircularProgressIndicator(
                  strokeWidth: 10.h,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.darkBlue),
                ));
          }),
    );
  }
}
