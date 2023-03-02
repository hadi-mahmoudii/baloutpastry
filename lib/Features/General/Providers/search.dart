import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../../Product/Models/product.dart';

class SearchProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  final TextEditingController searchCtrl = TextEditingController();

  int currentPage = 1;

  final String productName;

  List<ProductOverviewModel> products = [];

  SearchProvider(this.productName) {
    searchCtrl.text = this.productName;
  }

  bool lockPage = false;

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
    // print(Urls.getproducts(selectedBrand.id));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getProductsByName(searchCtrl.text, currentPage.toString()),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        // print(currentPage);
        // if (result['has_children']) {
        //   result['children'].forEach((element) {
        //     products.add(ProductOverviewModel.fromJson(element));
        //     // print(result['children']);
        //   });
        // isLoading = false;
        // notifyListeners();
        // } else
        //   Navigator.of(context)
        //       .pushReplacementNamed(Routes.productList, arguments: categoryId);
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
