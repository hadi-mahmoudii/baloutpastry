import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';

class SignInProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool codeSended = false;
  ScrollController scrollController = ScrollController();

  TextEditingController phoneCtrl = new TextEditingController();
  TextEditingController codeCtrl = new TextEditingController();

  signIn(BuildContext context, {bool resetPage = false}) async {
    if (phoneCtrl.text == '') {
      Fluttertoast.showToast(msg: 'شماره را وارد کنید');
      return;
    }
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.login,
      datas: {'tel': phoneCtrl.text},
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) async {
        try {
          // test account
          if (result['data']['test_account'] == true) {
            Fluttertoast.showToast(msg: 'وارد شدید');
            final prefs = await SharedPreferences.getInstance();
            AppSession.token = 'Bearer ' + result['data']['token'];
            AppSession.userId = result['data']['user']['id'].toString();
            AppSession.userName = result['data']['user']['first_name'] +
                ' ' +
                result['data']['user']['last_name'];
            AppSession.userPhone = result['data']['user']['tel'];
            final userData = json.encode({
              'token': AppSession.token,
              'userId': AppSession.userId,
              'userName': AppSession.userName,
              'userPhone': AppSession.userPhone,
            });
            prefs.setString('userData', userData);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(Routes.home);
            isLoading = false;
            codeSended = true;
            notifyListeners();
          }
        } catch (e) {}
        try {
          if (result['message']['title'] == 'موفق') {
            isLoading = false;
            codeSended = true;
            notifyListeners();
            return;
          }
        } catch (e) {}
        try {
          if (result['errors']['tel'][0] ==
              'کاربری با این شماره تلفن یافت نشد') {
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: 'این شماره یافت نشد');
            return;
          }
        } catch (e) {}
      },
    );
  }

  submitLogin(BuildContext context, {bool resetPage = false}) async {
    if (codeCtrl.text == '') {
      Fluttertoast.showToast(msg: 'کد را وارد کنید');
      return;
    }
    isLoading = true;
    notifyListeners();
    // print({
    //   'code': codeCtrl.text,
    //   'tel': phoneCtrl.text,
    // });
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.submitLogin,
      datas: {
        'code': codeCtrl.text,
        'tel': phoneCtrl.text,
      },
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) async {
        // print(result);
        try {
          if (result['data']['token'] != '') {
            Fluttertoast.showToast(msg: 'وارد شدید');
            final prefs = await SharedPreferences.getInstance();
            AppSession.token = 'Bearer ' + result['data']['token'];
            AppSession.userId = result['data']['user']['id'].toString();
            AppSession.userName = result['data']['user']['first_name'] +
                ' ' +
                result['data']['user']['last_name'];
            AppSession.userPhone = result['data']['user']['tel'];
            final userData = json.encode({
              'token': AppSession.token,
              'userId': AppSession.userId,
              'userName': AppSession.userName,
              'userPhone': AppSession.userPhone,
            });
            prefs.setString('userData', userData);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(Routes.home);
            isLoading = false;
            codeSended = true;
            notifyListeners();
            return;
          }
        } catch (e) {}
        try {
          if (result['status'] == 'fail') {
            Fluttertoast.showToast(msg: 'کدواردشده صحیح نیست!');
            isLoading = false;
            notifyListeners();
            // Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
            return;
          }
        } catch (e) {}
        try {
          if (result['errors']['credentials'] ==
              'نام کاربری و یا کد وارد شده نادرست می باشد.') {
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: 'کد نادرست است');
            return;
          }
        } catch (e) {}
      },
    );
  }

  @override
  void reassemble() {}
}
