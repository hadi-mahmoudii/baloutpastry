import '../../../Core/Config/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/my_special_order.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySpecialOrdersProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  List<MySpecialOrderModel> datas = [];

  bool lockPage = false;
  int currentPage = 1;

  getDatas(BuildContext context, {bool resetPage = false}) async {
    if (lockPage) return;
    if (resetPage) currentPage = 1;
    if (currentPage == 1) {
      datas = [];
      isLoading = true;
      // scrollController.jumpTo(0);
      notifyListeners();
    } else {
      isLoadingMore = true;
      notifyListeners();
    }
    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getMySpecialOrders,
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        // print(result);
        result['data'].forEach((element) {
          datas.add(MySpecialOrderModel.fromJson(element));
          // print(result['children']);
        });
        if (currentPage == 1) {
          currentPage += 1;
          isLoading = false;
          notifyListeners();
        } else {
          if (result.length > 0)
            currentPage += 1;
          else
            lockPage = true;
          isLoadingMore = false;
          notifyListeners();
        }
      },
    );
  }

  deleteOrder(BuildContext context, String id) async {
    // isLoading = true;
    // notifyListeners();
    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result =
        await ServerRequest().deleteData(
      Urls.deleteSpecialOrder(id),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            Fluttertoast.showToast(msg: 'سفارش با موفقیت حذف شد');
            Navigator.of(context).popAndPushNamed(Routes.mySpecialOrders);
          }
        } catch (e) {}
      },
    );
  }

  @override
  void reassemble() {}
}
