import '../../../Core/Config/app_session.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/routes.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/shop_card.dart';

class ShopCardProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  // bool isLoadingMore = false;
  // ScrollController scrollController = ScrollController();

  int currentPage = 1;

  late ShopCardModel card;

  late BuildContext ctx;

  getDatas(BuildContext context) async {
    ctx = context;
    isLoading = true;
    // scrollController.jumpTo(0);
    notifyListeners();

    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getCart,
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
          if (result['errors'] ==
              'در حال حاضر سبد خرید فعالی برای شما وجود ندارد') {
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: 'سبدخریدشما خالی است!');
            Navigator.of(context).pop();
            card = ShopCardModel.fromJson({});
            return;
          }
        } catch (e) {}
        // print(result['data']);
        card = ShopCardModel.fromJson(result['data']);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  deleteCardRow(String id, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result =
        await ServerRequest().deleteData(
      Urls.deleteCart(id),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) async {
        // print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            Fluttertoast.showToast(msg: 'محصول از سبدخرید حذف شد');
            await Provider.of<AppSession>(context, listen: false)
                .getCardLength(context);
            Navigator.of(ctx).popAndPushNamed(Routes.shopCard);
            return;
          }
        } catch (e) {}
        Fluttertoast.showToast(msg: 'مشکلی درحذف رخ داده است');
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void reassemble() {}
}
