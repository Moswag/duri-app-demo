import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'constants/pref_constants.dart';
import 'ui/home.dart';
import 'ui/login.dart';


Future<Null> main() async {
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DuriHub',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
      },
      theme: new ThemeData(primaryColor: Colors.white),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool(PrefConstants.ISLOGGEDIN) ?? false);
    if (!seen) {
      return new Home(prefs: prefs);
    } else {
      return new LoginPage(
        prefs: prefs,
        title: 'Login',
      );
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
