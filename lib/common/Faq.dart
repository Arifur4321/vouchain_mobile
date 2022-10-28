import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//DTO
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';

//Utility
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;

//Pub.dev Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';

class Faq extends StatefulWidget {
  final dynamic user;

  Faq({Key key, @required this.user}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  Future<DTOList<dynamic>> futureList;

  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    String profile = (widget.user is EmployeeDTO) ? "employee" : "merchant";
    futureList = UserServices.getFaq(profile, widget.user, context);
    return Scaffold(
      drawer: (widget.user is EmployeeDTO)
          ? EmpDrawerMenu(selected: 6, emp: widget.user)
          : MrcDrawerMenu(selected: 5, mrc: widget.user),
      appBar: AppBar(
        toolbarHeight: 157.5.h,
        title: Text(VouchainLocalizations.of(context).faq,
            style: TextStyle(fontSize: 52.5.sp)),
      ),
      body: FutureBuilder(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DTOList<dynamic> listDto = snapshot.data;
            List<Container> _rowList = [];
            if (listDto.status == "OK") {
              for (var i = 0; i < listDto.list.length; i++) {
                _rowList.add(
                  Container(
                    color: faqColor(i),
                    child: ExpansionTile(
                        tilePadding: EdgeInsets.only(right: 15, top: 0),
                        //backgroundColor: Color.fromRGBO(168, 219, 255, 0.3),
                        backgroundColor: faqColor(i),
                        initiallyExpanded: false,
                        childrenPadding: EdgeInsets.only(left: 10),
                        title: ListTile(
                          title: Text(
                            listDto.list[i].question,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: colors.blue,
                            ),
                          ),
                        ),
                        children: [
                          ListTile(
                            title: Text(
                              listDto.list[i].answer,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: colors.darkGrey,
                              ),
                            ),
                          )
                        ]),
                  ),
                );
              }
              return ListView(
                children: _rowList,
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
    );
  }

  faqColor(int i) {
    if (i % 2 == 1) {
      return colors.lightGrey;
    } else {
      return Colors.white;
    }
  }
}
