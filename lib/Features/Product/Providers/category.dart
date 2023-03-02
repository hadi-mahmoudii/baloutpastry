import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/routes.dart';
import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/category.dart';

class CategoryProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  // bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  // int currentPage = 1;

  final String categoryId;

  List<CategoryModel> categories = [];

  CategoryProvider(this.categoryId);

  String pHeader = '';
  String eHeader = '';
  String asset = '';

  getDatas(BuildContext context, {bool resetPage = false}) async {
    // if (resetPage) currentPage = 1;
    // if (currentPage == 1) {
    categories = [];
    isLoading = true;
    // scrollController.jumpTo(0);
    notifyListeners();
    // } else {
    //   isLoadingMore = true;
    //   notifyListeners();
    // }
    // print(Urls.getcategories(selectedBrand.id));
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getCategoryData(categoryId),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        if (result['has_children']) {
          result['children'].forEach((element) {
            categories.add(CategoryModel.fromJson(element, categoryId));
            // print(result['children']);
          });
          if (categoryId == '14') {
            pHeader = 'شیرینی ها';
            eHeader = 'Postries';
            asset = 'cookie';
          }
          if (categoryId == '19') {
            pHeader = 'کیک ها';
            eHeader = 'Cakes';
            asset = 'cake';
          }
          if (categoryId == '23') {
            pHeader = 'لوازم تولد';
            eHeader = 'Birthday';
            asset = 'gift-box';
          }
          if (categoryId == '22') {
            pHeader = 'نان';
            eHeader = 'Bread';
            asset = 'donut (2)';
          } else {
            pHeader = 'کیک ها';
            eHeader = 'Cakes';
            asset = 'cake';
          }
          isLoading = false;
          notifyListeners();
        } else
          Navigator.of(context).pushReplacementNamed(
            Routes.productList,
            arguments: CategoryModel(
              id: categoryId,
              name: result['name'],
              eName: result['name_en'],
              hasChild: result['has_children'],
              parentId: categoryId,
            ),
          );
        // if (currentPage == 1) {
        //   categories = result;
        //   currentPage += 1;
        //   isLoading = false;
        //   notifyListeners();
        // } else {
        //   if (result.length > 0) currentPage += 1;
        //   categories += result;
        //   isLoadingMore = false;
        //   notifyListeners();
        // }
      },
    );
  }

  @override
  void reassemble() {}
}
