import '../../../Core/Config/app_session.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/urls.dart';
import '../../../Core/Models/server_request.dart';
import '../../../Core/Widgets/error_result.dart';
import '../Models/comment.dart';
import '../Models/product.dart';

class ProductDetailsProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = true;
  bool isSendingReview = false;
  ScrollController scrollController = ScrollController();

  // int currentPage = 1;

  final String productId;

  ProductModel? product;

  ProductDetailsProvider(this.productId);
  List<CommentModel> comments = [];

  TextEditingController reviewCtrl = TextEditingController();
  double rate = 3;

  bool showComments = true;

  getDatas(BuildContext context) async {
    comments = [];
    isLoading = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getProduct(productId),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) async {
        product = ProductModel.fromJson(result);
        if (AppSession.token == '')
          showComments = false;
        else
          await getComments(context);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  sendComment(BuildContext context) async {
    isSendingReview = true;
    notifyListeners();
    final Either<ErrorResult, dynamic> result = await ServerRequest().sendData(
      Urls.sendComment,
      datas: {
        'comment': reviewCtrl.text,
        'product_id': productId,
        'rate': rate.toString(),
      },
    );
    result.fold(
      (error) async {
        isLoading = false;
        notifyListeners();
      },
      (result) {
        // print(result);
        try {
          if (result['message']['title'] == 'موفق') {
            rate = 3;
            reviewCtrl.text = '';
            Fluttertoast.showToast(msg: 'نظرشما ثبت شد');
            Navigator.of(context).pop();
            return;
          }
        } catch (e) {}
        Fluttertoast.showToast(msg: 'مشکلی درارسال نظر رخ داده است');
        isLoading = false;
        notifyListeners();
      },
    );
  }

  getComments(BuildContext context) async {
    final Either<ErrorResult, dynamic> result = await ServerRequest().fetchData(
      Urls.getComments(productId),
    );
    result.fold(
      (error) async {
        // await ErrorResult.showDlg(error.type, context);
        isLoading = false;
        notifyListeners();
      },
      (result) {
        result.forEach((element) {
          comments.add(CommentModel.fromJson(element));
          // print(result['children']);
        });
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void reassemble() {}
}
