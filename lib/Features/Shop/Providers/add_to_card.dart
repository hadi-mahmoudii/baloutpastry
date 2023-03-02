import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../../Product/Models/product.dart';

class AddToCardProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  ScrollController scrollController = ScrollController();

  TextEditingController valueCtrl = TextEditingController();
  TextEditingController textOnItemCtrl = TextEditingController();
  TextEditingController textAroundItemCtrl = TextEditingController();

  List<TextEditingController> optionCtrls = [];

  var formKey = GlobalKey<FormState>();

  final String productId;
  final BuildContext context;

  ProductModel? product;

  AddToCardProvider(this.productId, this.context);

  //in some products user can select between two options
  bool numericSelected = false;
  // TextEditingController kgValueCtrl = TextEditingController();
  TextEditingController numValueCtrl = TextEditingController();

  changeNumericSelected(bool value) {
    numericSelected = value;
    notifyListeners();
  }

  getDatas(BuildContext context) async {
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getProduct(productId),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        product = ProductModel.fromJson(result);
        product!.options!.forEach((element) {
          optionCtrls.add(TextEditingController());
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

  addToCart() async {
    if (!formKey.currentState!.validate()) return;
    bool checkAll = true;
    optionCtrls.forEach((element) {
      if (element.text.isEmpty) {
        checkAll = false;
        return;
      }
    });
    if (!checkAll) {
      Fluttertoast.showToast(msg: 'لطفاهمه ی موارد را انتخاب کنید');
      return;
    }
    isLoading = true;
    notifyListeners();
    Map<dynamic, dynamic> datas = {
      'product_id': productId,
      'amount': valueCtrl.text,
    };
    if (numericSelected) {
      datas['count'] = numValueCtrl.text;
    }
    List<Map<String?, int?>> options = [];
    for (var i = 0; i < optionCtrls.length; i++) {
      options.add({
        'id': int.parse(product!.options![i].id!),
        'option_detail': int.parse(product!.options![i].options!
            .firstWhere((element) =>
                '${element.name} - ${element.price} تومان' ==
                optionCtrls[i].text)
            .id!),
      });
    }
    if (options.isNotEmpty) {
      datas['options'] = options;
    }
    if (textOnItemCtrl.text != '') datas['text_on_item'] = textOnItemCtrl.text;
    if (textAroundItemCtrl.text != '')
      datas['text_around_item'] = textAroundItemCtrl.text;

    // print(datas);
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.addToCart,
      datas: datas,
    );
    result.fold(
      (error) async {
        await ErrorResult.showDlg(error.type!, context);
      },
      (result) async {
        // print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            Fluttertoast.showToast(msg: 'به سبدخرید شما اضافه شد');
            await Provider.of<AppSession>(context, listen: false)
                .getCardLength(context);
            Navigator.of(context).pop();

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
