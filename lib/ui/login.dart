import 'package:duri/constants/app_constants.dart';
import 'package:duri/constants/pref_constants.dart';
import 'package:duri/models/user.dart';
import 'package:duri/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'widgets/loading.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.prefs}) : super(key: key);

  final String title;
  final SharedPreferences prefs;

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future _loginUser({String email, String password}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        Map<String, dynamic> params = Map<String, dynamic>();
        params["email"] = email;
        params["password"] = password;

        await loginUser(http.Client(), widget.prefs, params).then((onValue) {
          if (onValue) {
            widget.prefs.setBool(PrefConstants.ISLOGGEDIN, true);
            widget.prefs.setString(PrefConstants.LOGGED_EMAIL, email);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      prefs: widget.prefs,
                    )));
          } else {
            final snackBar = SnackBar(
                content: Text("Wrong sign in credentials, please try again"));

            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
      } catch (e) {
        print("Sign In Error: $e");
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      autofocus: false,
      controller: passwordController,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01286D),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            _loginUser(
                email: emailController.text,
                password: passwordController.text);
          });
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffFAB904),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (BuildContext context) => RegisterPage(
//                    prefs: widget.prefs,
//                  )));
        },
        child: Text("Register",
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
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButton,

//                    SizedBox(height: 25.0),
//                    setIPAddress,
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
