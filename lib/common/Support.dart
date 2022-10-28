import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:vouchain_wallet_app/employee/EmpDrawerMenu.dart';
import 'package:vouchain_wallet_app/entity/DTOList.dart';
import 'package:vouchain_wallet_app/merchant/MrcDrawerMenu.dart';

//DTO
import 'package:vouchain_wallet_app/entity/EmployeeDTO.dart';
import 'package:vouchain_wallet_app/rest/UserServices.dart';

//Utility
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/utility/colors.dart' as colors;

//Pub.dev Packages
import 'package:vouchain_wallet_app/localization/vouchain_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Support extends StatefulWidget {
  final user;

  Support({Key key, @required this.user}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}


class _SupportState extends State<Support> {
  Future<DTOList<dynamic>> futureList;
  FocusNode focus =FocusNode();
  @override
  void initState() {
    super.initState();
    futureList = UserServices.getSupport(widget.user, context);
  }


  @override
  Widget build(BuildContext context) {
    bool portrait = utility.orientation(context);
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: (widget.user is EmployeeDTO)
            ? EmpDrawerMenu(selected: 7, emp: widget.user)
            : MrcDrawerMenu(selected: 6, mrc: widget.user),
        appBar: AppBar(
          toolbarHeight: 157.5.h,
          title: Text(VouchainLocalizations.of(context).customerService,
              style: TextStyle(fontSize: 52.5.sp)),
        ),
        body: Stack(fit: StackFit.expand, children: [
          utility.background(),
          utility.backgroundTop(),
          GestureDetector(
            onTap: () {
              focus.unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: (portrait) ? 350.h : 100.w),
                child: FutureBuilder(
                  future: futureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DTOList<dynamic> listDto =
                          snapshot.data; //Lista dei SupportDTO (paragrafi)
                      List<Container> _paragraphList = []; //Lista dei paragrafi
                      List<dynamic> contactListDto = []; //Lista dei ContactDTO
                      if (listDto.status == "OK") {
                        for (var i = 0; i < listDto.list.length; i++) {
                          List<Container> _contactsList = []; //Lista dei RichText
                          contactListDto = listDto.list[i].contacts;
                          //print ("LISTA CONTATTI ---- $contactListDto");
                          for (var j = 0; j < contactListDto.length; j++) {
                            _contactsList.add(Container(
                              padding: EdgeInsets.only(bottom: 20.h),
                              alignment: Alignment.centerLeft,
                              child: SelectableText.rich(
                                  TextSpan(
                                      style: TextStyle(
                                          fontFamily: 'Graphik',
                                          color: colors.darkGrey),
                                      children: [
                                        TextSpan(
                                            text: contactListDto[j].type + ": ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 50.sp, //19,
                                              color: colors.darkGrey,
                                            )),
                                        TextSpan(
                                          text: contactListDto[j].value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 50.sp, //19,
                                              color: colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                            print(listDto.list[i].contacts[j].type.toString()+" "+
                                                listDto.list[i].contacts[j].value.toString());
                                            _launchURL(
                                                listDto.list[i].contacts[j].type,
                                                listDto.list[i].contacts[j].value);},
                                        )
                                      ]), focusNode: focus,),
                            ));
                          }
                          _paragraphList.add(
                            Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            bottom: (portrait) ? 42.h : 30.w),
                                        //15),
                                        width: (portrait) ? 0.725.sw : 0.725.sh,
                                        //300
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      right: 40.w),
                                                  //15
                                                  child: Icon(Icons.speaker_notes,
                                                      size: 63.w,
                                                      color: colors
                                                          .blueOpacity(0.9))),
                                              Text(listDto.list[i].title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 55.sp, //21,
                                                    color: colors.blue,
                                                  ))
                                            ])),
                                    Container(
                                        width: (portrait) ? 0.725.sw : 0.725.sh,
                                        padding: EdgeInsets.only(
                                            bottom: (portrait) ? 20.h : 20.w),
                                        //30),
                                        decoration: BoxDecoration(),
                                        child: Text(listDto.list[i].content,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 50.sp, //19,
                                              color: colors.darkGrey,
                                            ))),
                                    Container(
                                      width: (portrait) ? 0.725.sw : 0.725.sh,
                                      padding: EdgeInsets.only(
                                          bottom: (portrait) ? 84.h : 84.w),
                                      //30),
                                      child: Column(
                                        children: _contactsList,
                                      ),
                                    )
                                  ]),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _paragraphList,
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: (portrait) ? 100.h : 0, right: 68.w),
                                //top: 75, right: 25),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: (portrait) ? 523.w : 523.h,
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    (_width > 600) ? 40.h : 0),
                                            child: RaisedButton(
                                                color: colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 28.h),
                                                child: Text(
                                                    "Informativa sulla Privacy",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 39.3.sp)),
                                                //15)),
                                                onPressed: () async {
                                                  const url =
                                                      'https://www.iubenda.com/privacy-policy/69445625';
                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                }))
                                      ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: (portrait) ? 523.w : 523.h,
                                            child: RaisedButton(
                                                color: colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 28.h),
                                                child: Text("Altre informazioni",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 39.3.sp)),
                                                onPressed: () => showAboutDialog(
                                                    context: context,
                                                    applicationName:
                                                        "Vouchain Wallet App",
                                                    applicationVersion: utility.VERSION,
                                                    applicationIcon: Image(
                                                      width: 220.w,
                                                      image: AssetImage(
                                                          "assets/images/vouchain_logo_vert_blugrigio.png"),
                                                    ))))
                                      ])
                                ]))
                          ],
                        );
                      } else {
                        return utility.genericErrorAlert(context);
                      }
                    } else if (snapshot.hasError) {
                      return utility.genericErrorAlert(context);
                    }

                    // By default, show a loading spinner.
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          )
        ]));
  }

  _launchURL(String type, String value) async {
    Uri uri;
    switch (type) {
      case "email":
        {
          uri = Uri(
              scheme: 'mailto',
              path: value,
              queryParameters: {
              'subject': 'Assistenza Vouchain',
                'body' : ''
              } );
          //url = 'mailto:<$value>?subject=Assistenza%20Vouchain&body=%20';
          break;
        }
      case "mail":
        {
          uri = Uri(
              scheme: 'mailto',
              path: value,
              queryParameters: {
                'subject': 'Assistenza Vouchain',
                'body' : ''
              } );
          //url = 'mailto:<$value>?subject=Assistenza%20Vouchain&body=%20';
          break;
        }
      case "telefono":
        {
          uri = Uri(
              scheme: 'tel',
              path: value);
          //url = 'tel:<$value>';
          break;
        }
      default:
        {
          return;
        }
    }
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch '+uri.toString();
    }
  }
}
