import 'dart:convert';

import 'urls.dart';
import '../Models/server_request.dart';
import '../Widgets/error_result.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession extends ChangeNotifier {
  static String _token = '';
  static String get token {
    return AppSession._token;
  }

  static set token(String token) {
    AppSession._token = token;
  }

  static String _userId = '';
  static String get userId {
    return _userId;
  }

  static set userId(String userId) {
    AppSession._userId = userId;
  }

  static String _userName = '';
  static String get userName {
    return _userName;
  }

  static set userName(String userName) {
    AppSession._userName = userName;
  }

  static String _userPhone = '';
  static String get userPhone {
    return _userPhone;
  }

  static set userPhone(String userPhone) {
    AppSession._userPhone = userPhone;
  }

  int cardLength = 0;
  changeCardLength(int value) {
    cardLength = value;
    notifyListeners();
  }

  getCardLength(BuildContext context) async {
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getCartCount,
    );
    result.fold(
      (error) async {},
      (result) async {
        cardLength = result['number'];
        notifyListeners();
      },
    );
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    // var sizes = MediaQuery.of(context).size;
    // setSizes(sizes);
    // AppSession.mainFontColor = Theme.of(context).primaryColor;
    // AppSession.backgroundColor = Theme.of(context).canvasColor;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    AppSession.token = userData['token'];
    AppSession.userId = userData['userId'];
    AppSession.userName = userData['userName'];
    AppSession.userPhone = userData['userPhone'];
    notifyListeners();
    await getCardLength(context);
    return true;
  }
}

const Color mainFontColor = Color(0xFF8D411C);
