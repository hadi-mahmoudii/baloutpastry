import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Core/Models/global.dart';

class ProductOptionModel {
  final String? id, name, type, effect;
  final List<ProductOptionDetailsModel>? options;

  ProductOptionModel({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.effect,
    @required this.options,
  });

  factory ProductOptionModel.fromJson(Map? datas) {
    List<ProductOptionDetailsModel> options = [];
    try {
      datas!['option_details'].forEach((element) {
        options.add(ProductOptionDetailsModel.fromJson(element));
      });
    } catch (e) {}
    return ProductOptionModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name']),
      type: GlobalEntity.dataFilter(datas['type']),
      effect: GlobalEntity.dataFilter(datas['effect']),
      options: options,
    );
  }
}

class ProductOptionDetailsModel {
  final String? id, name, price;

  ProductOptionDetailsModel({
    @required this.id,
    @required this.name,
    @required this.price,
  });

  factory ProductOptionDetailsModel.fromJson(Map? datas) {
    final formatter = new NumberFormat("#,###");
    String price = '';
    try {
      price = formatter.format(datas!['price']);
    } catch (e) {}
    return ProductOptionDetailsModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name']),
      price: price,
    );
  }
}
