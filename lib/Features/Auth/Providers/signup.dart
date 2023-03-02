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

class SignUpProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool codeSended = false;
  ScrollController scrollController = ScrollController();

  TextEditingController fNameCtrl = new TextEditingController();
  TextEditingController lNameCtrl = new TextEditingController();
  TextEditingController phoneCtrl = new TextEditingController();

  TextEditingController codeCtrl = new TextEditingController();
  // TextEditingController rePassCtrl = new TextEditingController();

  final String previesPhoneNumber;

  SignUpProvider(this.previesPhoneNumber) {
    phoneCtrl.text = previesPhoneNumber;
  }

  signUp(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.register,
      datas: {
        'first_name': fNameCtrl.text,
        'last_name': lNameCtrl.text,
        'tel': phoneCtrl.text,
      },
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) {
        // print(result);
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
              'این شماره تلفن قبلا در سیستم ثبت شده است.') {
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: 'این شماره قبلا ثبت شده است');
            return;
          }
        } catch (e) {}
        // print(result);
      },
    );
  }

  submitRegister(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.submitRegister,
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
        // print(result['message']['title']);
        try {
          if (result['message']['title'] == 'موفق') {
            AppSession.token = 'Bearer ' + result['data']['token'];
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
            Fluttertoast.showToast(msg: 'ثبت نام کامل شد');
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
        // print(result);
      },
    );
  }

  @override
  void reassemble() {}
}
