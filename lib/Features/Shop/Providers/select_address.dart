import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/date-convertor.dart';
import '../../../Core/Models/option_model.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/submit_card_datas.dart';

class SelectAddressProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  ScrollController scrollController = ScrollController();

  TextEditingController dayCtrl = TextEditingController();
  TextEditingController hourCtrl = TextEditingController();

  bool discountCheck = false;
  String discountError = '';
  TextEditingController discountCtrl = TextEditingController();

  late SubmitCardDatasModel datas;

  List<OptionModel> days = [];
  List<OptionModel> hours = [];
  List<BranchRowModel> branches = [];

  // bool placeDelivery = true;
  int selectedAddress = -1;
  String currentShippingCost = '0';
  int selectedBranch = -1;

  bool letSelectAddress = true;

  late String depositPayment;
  String offValue = '';
  bool isCheckingDiscount = false;

  changeLetSelectAddress(bool value) {
    letSelectAddress = value;
    notifyListeners();
  }

  late String selectedDayId;
  bool letSelectHour = false;
  changeSelectedDayId() {
    letSelectHour = true;
    // try {
    String selectedId = datas.dates!
        .firstWhere((element) => element.date == dayCtrl.text)
        .date!;
    // print(selectedId);
    // datas.dates!.forEach((element) {
    //   print(element.times);
    // });
    datas.dates!
        .firstWhere((element) => element.date == selectedId)
        .times!
        .forEach((element) {
      hours.add(OptionModel(id: element.id, title: element.time));
    });
    // } catch (e) {}

    notifyListeners();
  }

  // changeAvailableHours() {
  //   if (dayCtrl.text == '') {
  //     letSelectHour = false;
  //   } else {
  //     letSelectHour = true;
  //   }
  //   notifyListeners();
  // }

  changeSelectedAddress(int value) {
    selectedAddress = value;
    currentShippingCost = datas.addresses![selectedAddress].shippingCost!;
    // print(datas.addresses![selectedAddress].id);
    notifyListeners();
  }

  changeSelectedBranch(int value) {
    selectedBranch = value;
    // print(datas.addresses![selectedAddress].id);
    notifyListeners();
  }

  deleteAddress(BuildContext context, String id) async {
    isLoading = true;
    notifyListeners();
    // print(Urls.deleteAddress(id));
    final Either<ErrorResult, dynamic> result =
        await ServerRequest().deleteData(
      Urls.deleteAddress(id),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        // print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            Navigator.pop(context);
            Navigator.of(context).popAndPushNamed(Routes.selectAddress);
            return;
          }
        } catch (e) {}
        isLoading = false;
        notifyListeners();
      },
    );
  }

  getDatas(BuildContext context, {bool resetPage = false}) async {
    isLoading = true;
    // scrollController.jumpTo(0);
    notifyListeners();

    // print(Urls.getproducts(selectedBrand.id));
    Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getSubmitCardDatas,
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        datas = SubmitCardDatasModel.fromJson(result);
        try {
          datas.dates!.forEach((element) {
            days.add(OptionModel(id: element.date, title: element.date));
          });
        } catch (e) {}
        try {
          if (datas.addresses!.length > 0) {
            selectedAddress = 0;
            currentShippingCost =
                datas.addresses![selectedAddress].shippingCost!;
          }
        } catch (e) {}
        depositPayment = datas.payment!;
        // isLoading = false;
        // notifyListeners();
      },
    );
    result = await ServerRequest().fetchData(
      Urls.getBranches,
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        // print(result);
        try {
          result['data'].forEach((element) {
            branches.add(BranchRowModel.fromJson(element));
            // print(element);
          });
        } catch (e) {}
        // datas = SubmitCardDatasModel.fromJson(result);
        // try {
        //   datas.dates!.forEach((element) {
        //     days.add(OptionModel(id: element.date, title: element.date));
        //   });
        // } catch (e) {}
        // try {
        //   if (datas.addresses!.length > 0) selectedAddress = 0;
        // } catch (e) {}
        // depositPayment = datas.payment!;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> checkDiscount() async {
    if (discountCtrl.text == '') {
      Fluttertoast.showToast(
        msg: 'کد تخفیف را وارد کنید',
      );
      return false;
    }
    offValue = '';
    depositPayment = datas.payment!;
    bool res = false;
    final Either<ErrorResult, dynamic> result = await ServerRequest()
        .sendData(Urls.checkDiscount, datas: {'discount': discountCtrl.text});
    result.fold(
      (error) async {
        res = false;
      },
      (result) {
        // print(result['data']);
        if (result['data']['result'].toString() == 'true') {
          res = true;
          offValue =
              'مبلغ تخفیف : ${result['data']['discount']['amount'].toString().substring(
                    0,
                  )} ریال';
          depositPayment = result['data']['deposit'].toString();
        }
        // return true;
        else {
          discountError = result['errors'];
          res = false;
        }
      },
    );
    notifyListeners();
    return res;
  }

  checkDiscountInUI() async {
    isCheckingDiscount = true;
    notifyListeners();
    await checkDiscount();
    isCheckingDiscount = false;
    notifyListeners();
  }

  sendGateway(BuildContext context, WidgetsBinding observer) async {
    if (dayCtrl.text == '') {
      Fluttertoast.showToast(
        msg: 'تاریخ موردنظر را انتخاب کنید',
      );
      return;
    }
    if (hourCtrl.text == '') {
      Fluttertoast.showToast(
        msg: 'ساعت موردنظر را انتخاب کنید',
      );
      return;
    }
    isLoading = true;
    notifyListeners();
    Map<String, dynamic>? data = {};
    // String url =
    //     'https://shirinibalout.com/startGateway?authorization=${AppSession.token}&send_date=${dayCtrl.text}&';
    if (discountCtrl.text != '' && !discountCheck) {
      bool checkResult = await checkDiscount();
      // print(checkResult);
      if (checkResult) {
        // url += 'discount=${discountCtrl.text}&';
        data['discount'] = discountCtrl.text;
      } else {
        Fluttertoast.showToast(
          msg: discountError,
        );
        isLoading = false;
        notifyListeners();
        return;
      }
    }

    try {
      final String sendDate = DateConvertor().jalaliToMiladi(dayCtrl.text);
      data['send_date'] = sendDate;
    } catch (e) {}
    final dateId =
        hours.firstWhere((element) => element.title == hourCtrl.text).id;
    // url += 'send_hour=$dateId&';
    data['send_hour'] = dateId;
    if (letSelectAddress) {
      if (selectedAddress == -1) {
        Fluttertoast.showToast(
          msg: 'آدرس موردنظر را انتخاب کنید',
        );
        isLoading = false;
        notifyListeners();
        return;
      }
      final addressId = datas.addresses![selectedAddress].id;
      // url += 'address_id=$addressId&';
      data['address_id'] = addressId;
    } else {
      if (selectedBranch == -1) {
        Fluttertoast.showToast(
          msg: 'محل دریافت را انتخاب کنید',
        );
        isLoading = false;
        notifyListeners();
        return;
      }
      final branchId = branches[selectedBranch].id;
      // url += 'address_id=$addressId&';
      data['branch_id'] = branchId;
    }

    data['authorization'] = AppSession.token;
    Uri uri = Uri(
        scheme: 'https',
        path: 'shirinibalout.com/startGateway',
        queryParameters: data);
    // print(uri.toString());
    // return;
    // print(data['send_date']);
    launch(
      uri.toString(),
      forceSafariVC: false,
      // forceWebView: true,
      // enableJavaScript: true,
    );
    int prevCardLength =
        Provider.of<AppSession>(context, listen: false).cardLength;

    /// Wait until the browser closes
    await Future.delayed(Duration(milliseconds: 100));
    while (observer.lifecycleState != AppLifecycleState.resumed) {
      // print('obs');
      await Future.delayed(Duration(milliseconds: 500));
    }
    await Future.delayed(Duration(seconds: 3));
    await Provider.of<AppSession>(context, listen: false).getCardLength(
      context,
    );
    // print(prevCardLength);
    // print(Provider.of<AppSession>(context, listen: false).cardLength);

    if (prevCardLength !=
        Provider.of<AppSession>(context, listen: false).cardLength) {
      Fluttertoast.showToast(msg: 'پرداخت شما با موفقیت انجام شد.');
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed(Routes.home);
      return;
    } else {
      Fluttertoast.showToast(msg: 'پرداخت انجام نشد!');
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void reassemble() {}
}
