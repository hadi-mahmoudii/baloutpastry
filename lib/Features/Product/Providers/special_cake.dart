import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/option_model.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../../Shop/Models/submit_card_datas.dart';

class SpecialCakeProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();
  TextEditingController textCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController countCtrl = TextEditingController();
  TextEditingController dayCtrl = TextEditingController();
  TextEditingController hourCtrl = TextEditingController();

  List<DateRowModel> dates = [];
  List<OptionModel> days = [];
  List<OptionModel> hours = [];

  TextEditingController tasteCtrl = TextEditingController();
  List<OptionModel> tastes = [
    OptionModel(id: 'وانیلی با موز و گردو', title: 'وانیلی با موز و گردو'),
    OptionModel(id: 'وانیلی ساده', title: 'وانیلی ساده'),
    OptionModel(id: 'نسکافه ای', title: 'نسکافه ای'),
    OptionModel(id: 'توت فرنگی و رد ولوت', title: 'توت فرنگی و رد ولوت'),
    OptionModel(id: 'کاراملی', title: 'کاراملی'),
    OptionModel(id: 'شکلاتی ساده', title: 'شکلاتی ساده'),
    OptionModel(id: 'شکلاتی مافینی', title: 'شکلاتی مافینی'),
  ];

  TextEditingController typeCtrl = TextEditingController();
  List<OptionModel> types = [
    OptionModel(id: 'تمام فندانت', title: 'تمام فندانت'),
    OptionModel(id: 'فیگورخاص', title: 'فیگورخاص'),
    OptionModel(id: 'نیمه فندانت', title: 'نیمه فندانت'),
    OptionModel(id: 'خاص', title: 'خاص'),
    OptionModel(id: 'خامه ای ساده', title: 'خامه ای ساده'),
  ];

  late String selectedDayId;
  bool letSelectHour = false;
  changeSelectedDayId() {
    letSelectHour = true;
    // try {
    String selectedId =
        dates.firstWhere((element) => element.date == dayCtrl.text).date!;
    // print(selectedId);
    // datas.dates!.forEach((element) {
    //   print(element.times);
    // });
    dates
        .firstWhere((element) => element.date == selectedId)
        .times!
        .forEach((element) {
      hours.add(OptionModel(id: element.id, title: element.time));
    });
    // } catch (e) {}

    notifyListeners();
  }

  getDatas(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    // scrollController.jumpTo(0);
    notifyListeners();

    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getSpecialOrderDates,
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        result!['dates'].forEach((element) {
          dates.add(DateRowModel.fromJson(element));
        });
        try {
          dates.forEach((element) {
            days.add(OptionModel(id: element.date, title: element.date));
          });
        } catch (e) {}

        isLoading = false;
        notifyListeners();
      },
    );
  }

  String imagePath = '';
  late PlatformFile image;
  pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    try {
      if (result!.count > 0) {
        image = result.files.first;
        imagePath = image.path!;
        notifyListeners();
      }
    } catch (e) {}
  }

  sendRequst(BuildContext context) async {
    if (typeCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: 'نوع کیک را وارد کنید');
      return;
    }
    if (countCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: 'مقدار کیک را وارد کنید');
      return;
    }
    if (dayCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: 'روزارسال کیک را وارد کنید');
      return;
    }
    if (hourCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: 'ساعت ارسال کیک را وارد کنید');
      return;
    }
    if (imagePath == '') {
      Fluttertoast.showToast(msg: 'تصویرموردنظر را انتخاب کنید');
      return;
    }
    isLoading = true;
    notifyListeners();
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(Urls.addSpecialOrder),
    );
    var pic = await http.MultipartFile.fromPath(
      'image',
      image.path!,
      filename: image.name,
    );
    request.files.add(pic);
    request.fields['type'] = typeCtrl.text;
    request.fields['text_around_item'] = textCtrl.text;
    request.fields['description'] = descCtrl.text;
    request.fields['taste'] = tasteCtrl.text;
    request.fields['amount'] = countCtrl.text;
    request.fields['send_date'] = dayCtrl.text;
    request.fields['send_hour'] =
        hours.firstWhere((element) => element.title == hourCtrl.text).id!;

    request.headers['X-Requested-With'] = 'XMLHttpRequest';
    request.headers['Authorization'] = AppSession.token;
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var result = json.decode(responseString);
    try {
      if (result['message']['title'] == 'موفقیت') {
        Fluttertoast.showToast(msg: 'درخواست شما ثبت شد');
        Navigator.of(context).pop();
        return;
      }
    } catch (e) {}
    Fluttertoast.showToast(msg: 'مشکلی در ثبت درخواست رخ داده است.');
    // print(responseString);
    isLoading = false;
    notifyListeners();
  }

  @override
  void reassemble() {}
}
