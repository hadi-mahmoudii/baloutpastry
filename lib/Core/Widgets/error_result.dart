import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


enum ErrorType {
  Network,
  Server,
  ExpireToken,
  FillDatas,
  BadData,
  BadCode,
  UnRegister,
  UnVerify,
}

class ErrorResult {
  final ErrorType? type;

  ErrorResult({
    @required this.type,
  });
  factory ErrorResult.fromException(e) {
    ErrorType error;
    print(e);
    switch (e) {
      case SocketException:
        error = ErrorType.Network;
        break;
      case HttpException:
        error = ErrorType.Server;
        break;
      case RedirectException:
        error = ErrorType.ExpireToken;
        break;
      default:
        error = ErrorType.Server;
    }
    return ErrorResult(type: error);
  }

  static showDlg(ErrorType type, BuildContext context) async {
    switch (type) {
      case ErrorType.Network:
        Fluttertoast.showToast(
          msg: 'مشکل در اتصال به اینترنت',
        );
        break;
      case ErrorType.Server:
        Fluttertoast.showToast(
          msg: 'مشکل در اتصال به سرور',
        );
        break;
      case ErrorType.FillDatas:
        Fluttertoast.showToast(
          msg: 'لطفا تمامی فیلد ها را پر نمایید',
        );
        break;
      case ErrorType.BadData:
        Fluttertoast.showToast(
          msg: 'نام کاربری و یا رمز عبور نادرست است',
        );
        break;
      case ErrorType.BadCode:
        Fluttertoast.showToast(
          msg: 'کد وارد شده نادرست است',
        );
        break;
      case ErrorType.UnRegister:
        Fluttertoast.showToast(
          msg: 'این شماره قبلا ثبت نام نکرده است',
        );
        break;
      case ErrorType.UnVerify:
        Fluttertoast.showToast(
          msg:
              'تایید شماره تلفن انجام نشده است.از بخش فراموشی رمز شماره ی خودرا تایید کنید.',
        );
        break;
      default:
    }
  }
}
