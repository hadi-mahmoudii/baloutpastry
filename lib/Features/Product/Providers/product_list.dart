import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/category.dart';
import '../Models/product.dart';

class ProductListProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  int currentPage = 1;

  final CategoryModel category;

  List<ProductOverviewModel> products = [];

  ProductListProvider(this.category);

  bool lockPage = false;

  String asset = '';

  getDatas(BuildContext context, {bool resetPage = false}) async {
    if (lockPage) return;
    if (resetPage) currentPage = 1;
    if (currentPage == 1) {
      products = [];
      isLoading = true;
      // scrollController.jumpTo(0);
      notifyListeners();
    } else {
      isLoadingMore = true;
      notifyListeners();
    }
    String url;
    if (category.id! != '0') {
      url = Urls.getProducts(category.id!, currentPage.toString());
    } else {
      //for ready send products in home
      url = Urls.getReadySendProducts(currentPage.toString());
    }
    final Either<ErrorResult, dynamic> result =
        await ServerRequest().fetchData(url);
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        if (category.parentId == '14') {
          asset = 'cookie';
        }
        if (category.parentId == '19') {
          asset = 'cake';
        }
        if (category.parentId == '23') {
          asset = 'gift-box';
        }
        if (category.parentId == '22') {
          asset = 'donut (2)';
        } else
          asset = 'cake';
        result['data'].forEach((element) {
          products.add(ProductOverviewModel.fromJson(element));
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

  @override
  void reassemble() {}
}
