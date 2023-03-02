import '../../../Core/Models/date-convertor.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/global.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';

class ProfileProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController familyCtrl = TextEditingController();
  TextEditingController eNameCtrl = TextEditingController();
  TextEditingController nationCodeCtrl = TextEditingController();
  TextEditingController birthdayCtrl = TextEditingController();
  TextEditingController birthdayLabelCtrl = TextEditingController();

  TextEditingController marrigeCtrl = TextEditingController();
  TextEditingController marrigeLabelCtrl = TextEditingController();

  getDatas(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.userData,
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) async {
        var datas = result['data'];
        String birthDay = '';
        // print(GlobalEntity.dataFilter(datas['birth_date']));
        if (GlobalEntity.dataFilter(datas['birth_date']) != '')
          birthDay = DateConvertor()
              .dateConvert(GlobalEntity.dataFilter(datas['birth_date']));
        String marrigeDay = '';
        if (GlobalEntity.dataFilter(datas['marriage_date']) != '')
          marrigeDay = DateConvertor()
              .dateConvert(GlobalEntity.dataFilter(datas['marriage_date']));
        nameCtrl.text = GlobalEntity.dataFilter(datas['first_name']);
        familyCtrl.text = GlobalEntity.dataFilter(datas['last_name']);
        eNameCtrl.text = GlobalEntity.dataFilter(datas['name_en']);
        nationCodeCtrl.text = GlobalEntity.dataFilter(datas['national_code']);
        birthdayLabelCtrl.text = birthDay;
        marrigeLabelCtrl.text = marrigeDay;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  updateData(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result =
        await ServerRequest().updateData(
      Urls.updateUserData,
      datas: {
        "first_name": nameCtrl.text,
        "last_name": familyCtrl.text,
        "name_en": eNameCtrl.text,
        "national_code": nationCodeCtrl.text,
        "birth_date": birthdayCtrl.text,
        "marriage_date": marrigeCtrl.text,
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
            AppSession.userName = nameCtrl.text + ' ' + familyCtrl.text;
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed(Routes.dashboard);
            return;
          }
        } catch (e) {}
        try {
          if (result['errors']['national_code'][0] ==
              'کد ملی وارد شده صحیح نمیباشد') {
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: 'کدملی نادرست است');
            return;
          }
        } catch (e) {}
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void reassemble() {}
}
