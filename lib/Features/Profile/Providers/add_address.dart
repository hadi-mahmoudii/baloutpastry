import '../../../Core/Config/routes.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/urls.dart';
import '../../../Core/Models/option_model.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/address.dart';

class AddAddressProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  bool regionsIsLoading = false;

  ScrollController scrollController = ScrollController();

  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();

  late String currentCityId;
  List<CityModel> cities = [];
  List<OptionModel> cityDatas = [];
  TextEditingController cityCtrl = TextEditingController();

  List<RegionModel> regions = [];
  List<OptionModel> regionDatas = [];
  TextEditingController regionCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  final String productId = '';
  final BuildContext context;

  // ProductModel? product;

  AddAddressProvider(this.context);

  getCities(BuildContext context) async {
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getCitiesList,
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        result['data'].forEach((element) {
          cities.add(CityModel.fromJson(element));
        });
        cities.forEach((element) {
          if (element.id == '35')
            cityDatas.add(OptionModel(id: element.id, title: element.name));
        });
        // if (product!.priceK! != '') {
        //   finalPrice = product!.priceK!;
        // } else {
        //   finalPrice = product!.priceN!;
        // }
        isLoading = false;
        notifyListeners();
      },
    );
  }

  getRegions(BuildContext context) async {
    currentCityId =
        cityDatas.firstWhere((element) => element.title == cityCtrl.text).id!;
    regionsIsLoading = true;
    notifyListeners();
    regions = [];
    regionDatas = [];
    regionCtrl.text = '';
    // print(Urls.getRegionsList(currentCityId));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getRegionsList(currentCityId),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        regionsIsLoading = false;
        notifyListeners();
      },
      (result) {
        result['data'].forEach((element) {
          regions.add(RegionModel.fromJson(element));
        });
        regions.forEach((element) {
          regionDatas.add(OptionModel(id: element.id, title: element.name));
        });
        // if (product!.priceK! != '') {
        //   finalPrice = product!.priceK!;
        // } else {
        //   finalPrice = product!.priceN!;
        // }
        regionsIsLoading = false;
        notifyListeners();
      },
    );
  }

  addAddress() async {
    if (!formKey.currentState!.validate()) return;
    // print('object');
    // if (cityCtrl.text == '') {
    //   Fluttertoast.showToast(msg: 'شهر را انتخاب کنید');
    //   return;
    // }
    // if (regionCtrl.text.isEmpty) {
    //   Fluttertoast.showToast(msg: 'منطقه را انتخاب کنید');
    //   return;
    // }
    // if (addressCtrl.text.isEmpty) {
    //   Fluttertoast.showToast(msg: 'آدرس را وارد کنید');
    //   return;
    // }
    // if (phoneCtrl.text.isEmpty) {
    //   Fluttertoast.showToast(msg: 'تلفن را وارد کنید');
    //   return;
    // }

    Map<dynamic, dynamic> datas = {
      'city_id':
          cityDatas.firstWhere((element) => element.title == cityCtrl.text).id,
      'address': addressCtrl.text,
      'phone': phoneCtrl.text,
    };
    try {
      datas['region_id'] = regionDatas
          .firstWhere((element) => element.title == regionCtrl.text)
          .id;
    } catch (e) {}
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.addAddress,
      datas: datas,
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) {
        // print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            Fluttertoast.showToast(msg: 'آدرس اضافه شد');
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed(Routes.selectAddress);
            return;
          }
        } catch (e) {}
        try {
          if (result['data'] != {}) {
            Fluttertoast.showToast(msg: 'آدرس اضافه شد');
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed(Routes.selectAddress);
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
        isLoading = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'خطایی رخ داد.');
      },
    );
  }

  @override
  void reassemble() {}
}
