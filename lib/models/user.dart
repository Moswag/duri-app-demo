import 'dart:convert' as convert;

import 'package:duri/constants/pref_constants.dart';
import 'package:duri/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class User {
  String id;
  String name;
  String email;
  String password;

  //Constructor
  User(
      {this.id,
      this.name,
      this.email,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    User newUser = User(
        id: json['id'].toString(),
        name: json['name'],
        email: json['email'],
        password: json['password']);

    return newUser;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password
      };

  //clone a Task or copy constructor

  factory User.fromUser(User anotherUser) {
    return User(
        id: anotherUser.id,
        name: anotherUser.name,
        email: anotherUser.email);
  }
}

//save a user
Future<bool> saveUser(http.Client client, Map<String, dynamic> params,
    SharedPreferences prefs) async {
  print(params.toString());
  final response = await client.post(URL_SAVE_USER, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody['response'];
    if (mapResponse == 'success') {
      print('The response is: '+mapResponse);
      prefs.setString(
          PrefConstants.SERVER_RESPONSE,'User successfully added');
      return true;
    } else {
      print('Response ikuti ' + mapResponse);
      prefs.setString(
          PrefConstants.SERVER_RESPONSE,mapResponse);
      return false;
    }
  } else {
    throw Exception('Failed to add user . Error: ${response.toString()}');
  }
}

//update a task
Future<bool> loginUser(http.Client client, SharedPreferences prefs,
    Map<String, dynamic> params) async {
  print(params.toString());
  final response = await client.post(URL_LOGIN, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody['response'];
    print(' response yangu ikuti: '+mapResponse);
    if (mapResponse == 'success') {
      print('pfeee');
      return true;
    } else {
      print('Response ikuti ' + mapResponse);
      return false;
    }
  } else {
    throw Exception('Failed to login. Error: ${response.toString()}');
  }
}

Future<List<User>> fetchUsers(
    http.Client client, SharedPreferences prefs) async {
  print(URL_LIST_USERS);
  final response = await client.get(URL_LIST_USERS);
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
      final receipts = mapResponse['users'].cast<Map<String, dynamic>>();
      return receipts.map<User>((json) {
        return User.fromJson(json);
      }).toList();

  } else {
    throw Exception('Failed to load users');
  }
}

