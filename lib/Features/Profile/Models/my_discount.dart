import 'package:flutter/material.dart';

import '../../../Core/Models/global.dart';
import '../../Product/Models/product.dart';

class MyDiscountModel {
  final String? id, discount, expire, name, amount, maxAmount, percent;
  MyDiscountModel({
    @required this.id,
    @required this.discount,
    @required this.expire,
    @required this.name,
    @required this.amount,
    @required this.maxAmount,
    @required this.percent,
  });
  factory MyDiscountModel.fromJson(Map? datas) {
    List<ProductModel> products = [];
    try {
      datas!['products'].forEach((element) {
        products.add(ProductModel.fromJson(element));
        // print(result['children']);
      });
    } catch (e) {}

    return MyDiscountModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      discount: GlobalEntity.dataFilter(datas['discount']),
      expire: GlobalEntity.dataFilter(datas['expired_at']),
      name: GlobalEntity.dataFilter(datas['name']),
      amount: GlobalEntity.dataFilter(datas['amount']),
      percent: GlobalEntity.dataFilter(datas['percent']),
      maxAmount: GlobalEntity.dataFilter(datas['max_amount']),
    );
  }
}
