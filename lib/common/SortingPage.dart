import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vouchain_wallet_app/common/PasswordReset.dart';
import 'package:vouchain_wallet_app/employee/EmpInvitationCode.dart';

import 'package:vouchain_wallet_app/utility/colors.dart' as colors;
import 'package:vouchain_wallet_app/utility/Utility.dart' as utility;
import 'package:vouchain_wallet_app/common/Fingerprint.dart';
import 'package:vouchain_wallet_app/common/Homepage.dart';
import 'package:vouchain_wallet_app/common/Pin.dart';
import 'package:vouchain_wallet_app/rest/EmpServices.dart';
import 'package:vouchain_wallet_app/rest/MrcServices.dart';
import 'package:uni_links/uni_links.dart';

class SortingPage extends StatefulWidget {
  SortingPage({Key key}) : super(key: key);

  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    utility.orientation(context);

    return Scaffold(
      backgroundColor: colors.blue,
      body: FutureBuilder<dynamic>(
        future: _sort(),
        builder: (BuildContext context, snapshot) {
          // By default, show a loading spinner.
          return Center(
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  _sort() async {
    final storage = new FlutterSecureStorage();

    print(
        "SESSIONSTORAGE --- " + (await storage.read(key: "usrId")).toString());
    final usrId = await storage.read(key: "usrId");
    if (usrId != null) {
      final profile = await storage.read(key: "profile");
      String prefs;
      var user;
      print("PROFILE --- " + (await storage.read(key: "profile")).toString());
      (profile == "employee")
          ? user = await EmpServices.getEmpProfile(usrId)
          : user = await MrcServices.getMrcProfile(usrId);
      if (user.status == "OK") prefs = user.accessType;
      switch (prefs) {
        case 'FINGER':
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Fingerprint(
                        user: user, context: context, profile: profile)));

            break;
          }
        case 'PIN':
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Pin(profile: profile, user: user, task: "auth")));
            break;
          }
        default:
          {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          }
      }
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  Future<void> initPlatformState() async {
    final storage = new FlutterSecureStorage();
    final usrId = await storage.read(key: "usrId");
    if (usrId == null) {
      Uri _initialUri;
      //Uri _latestUri;

      // Attach a listener to the Uri links stream
      sub = getUriLinksStream().listen((Uri uri) => _sortLink(uri, context),
          onError: (Object err) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
        utility.genericErrorAlert(context);
      });

      // Get the latest Uri
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        _initialUri = await getInitialUri();
        _sortLink(_initialUri, context);
      } on Exception {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
        utility.genericErrorAlert(context);
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      /*if (!mounted) return;
    setState(() {
      _latestUri = _initialUri;
    });*/
    }
  }

  _sortLink(Uri uri, BuildContext context) {
    String _code;
    if (uri != null) {
      switch (uri.path) {
        case "/VouChain/usrResetPass":
          {
            _code = uri.queryParameters.values.first;
            print("CODICE RESET --- $_code");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PasswordReset(code: _code)));
            break;
          }
        case "/VouChain/employee/empInvitationCode":
          {
            _code = uri.queryParameters.values.first;
            print("CODICE INVITO --- $_code");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EmpInvitationCode(code: _code)));
            break;
          }
        default:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }
}
