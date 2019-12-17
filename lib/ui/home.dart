import 'package:duri/constants/app_constants.dart';
import 'package:duri/constants/pref_constants.dart';
import 'package:duri/models/user.dart';
import 'package:duri/ui/login.dart';
import 'package:duri/ui/new_user.dart';
import 'package:duri/ui/view_users.dart';
import 'package:duri/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/loading.dart';


class Home extends StatefulWidget {
  Home({Key key, this.title, this.prefs}) : super(key: key);

  final String title;
  final SharedPreferences prefs;

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    final retrieveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01286D),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ViewUsers(
                    prefs: widget.prefs,
                  )));
        },
        child: Text("Retrieve",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final postButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffFAB904),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NewUser(
                    prefs: widget.prefs,
                  )));
        },
        child: Text("Post",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final logoutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF00000),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          widget.prefs.setBool(PrefConstants.ISLOGGEDIN, false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(
                    prefs: widget.prefs,
                  )));
        },
        child: Text("Logout",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );


    Form form = new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Color(0xffF6F6F6),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 200.0,
                      width: 400.0,
                      child: Image.asset(
                        AppConstants.APP_LOGO,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 35.0),
                    retrieveButton,
                    SizedBox(height: 25.0),
                    postButton,
                    SizedBox(height: 25.0),
                    logoutButton,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));

    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
