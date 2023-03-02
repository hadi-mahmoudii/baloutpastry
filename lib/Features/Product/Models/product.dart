import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Core/Models/global.dart';
import 'option.dart';

class ProductOverviewModel {
  final String id, categoryId, name, eName, image;
  final bool available, isNumbericType;
  final String priceN, priceK, discount;

  ProductOverviewModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.eName,
    required this.image,
    required this.available,
    required this.isNumbericType,
    required this.priceN,
    required this.priceK,
    required this.discount,
  });

  factory ProductOverviewModel.fromJson(Map datas) {
    // print(datas);
    bool isNumbericType = false;
    final formatter = new NumberFormat("#,###");
    String priceN = '';
    String priceK = '';

    try {
      if (GlobalEntity.dataFilter(datas['price_number']) != '')
        isNumbericType = true;
    } catch (e) {}
    try {
      priceN = formatter.format(int.parse(datas['price_number'].toString()));
    } catch (e) {}
    try {
      priceK = formatter.format(int.parse(datas['price_kilo'].toString()));
    } catch (e) {}
    String imagePath = '';
    try {
      imagePath = 'https://www.shirinibalout.com/' +
          GlobalEntity.dataFilter(datas['thumbnail']);
    } catch (e) {}
    return ProductOverviewModel(
      id: GlobalEntity.dataFilter(datas['id']),
      categoryId: GlobalEntity.dataFilter(datas['category_id']),
      name: GlobalEntity.dataFilter(datas['name']),
      eName: GlobalEntity.dataFilter(datas['name_en']),
      image: imagePath,
      available: datas['available'],
      isNumbericType: isNumbericType,
      priceN: priceN,
      priceK: priceK,
      discount: GlobalEntity.dataFilter(datas['price_discounted']),
    );
  }
}

class ProductModel {
  final String? id, categoryId, name, eName, mainImage, description;
  final List<String>? images;
  final bool? available, isNumbericType, letTextOnItem, letTextAroundItem;
  final String? priceN, priceK, discount;
  final String? amount, count, avarageW, unit;
  final String? minWeight,maxWeight,minNumber,maxNumber;
  final double? rate;

  final List<ProductOptionModel>? options;

  ProductModel({
    @required this.id,
    @required this.categoryId,
    @required this.name,
    @required this.eName,
    @required this.mainImage,
    @required this.description,
    @required this.images,
    @required this.available,
    @required this.letTextOnItem,
    @required this.letTextAroundItem,
    @required this.isNumbericType,
    @required this.priceN,
    @required this.priceK,
    @required this.amount,
    @required this.count,
    @required this.discount,
    @required this.options,
    @required this.rate,
    @required this.avarageW,
    @required this.minWeight,
    @required this.maxWeight,
    @required this.minNumber,
    @required this.maxNumber,
    @required this.unit,
  });

  factory ProductModel.fromJson(Map datas) {
    // for (var ky in datas.keys) {
    //   print(ky);
    //   print(datas[ky]);
    // }
    bool isNumbericType = false;
    final formatter = new NumberFormat("#,###");
    String priceN = '';
    String priceK = '';

    try {
      if (GlobalEntity.dataFilter(datas['price_number']) != '')
        isNumbericType = true;
    } catch (e) {}
    try {
      priceN = formatter.format(int.parse(datas['price_number'].toString()));
    } catch (e) {}
    try {
      priceK = formatter.format(int.parse(datas['price_kilo'].toString()));
    } catch (e) {}
    List<ProductOptionModel> options = [];
    try {
      datas['options'].forEach((element) {
        options.add(ProductOptionModel.fromJson(element));
        // print(result['children']);
      });
    } catch (e) {}
    String mainImagePath = '';
    try {
      mainImagePath = 'https://www.shirinibalout.com/' +
          GlobalEntity.dataFilter(datas['thumbnail']);
    } catch (e) {}
    List<String> images = [];
    try {
      datas['images'].forEach((element) {
        images.add('https://www.shirinibalout.com/' + element['thumbnail']);
        // print(result['children']);
      });
    } catch (e) {}

    double rate = 0;
    try {
      rate = double.parse(GlobalEntity.dataFilter(datas['rate']));
    } catch (e) {}
    return ProductModel(
      id: GlobalEntity.dataFilter(datas['id']),
      categoryId: GlobalEntity.dataFilter(datas['category_id']),
      name: GlobalEntity.dataFilter(datas['name']),
      eName: GlobalEntity.dataFilter(datas['name_en']),
      description: GlobalEntity.dataFilter(datas['description']),
      mainImage: mainImagePath,
      images: images,
      available: datas['available'],
      letTextOnItem: true,
      letTextAroundItem: true,
      isNumbericType: isNumbericType,
      priceN: priceN,
      priceK: priceK,
      amount: GlobalEntity.dataFilter(datas['amount']),
      count: GlobalEntity.dataFilter(datas['count']),
      discount: GlobalEntity.dataFilter(datas['price_discounted']),
      avarageW: GlobalEntity.dataFilter(datas['avg_weight']),
      unit: GlobalEntity.dataFilter(datas['unit']),
      minWeight: GlobalEntity.dataFilter(datas['minimum_weight']),
      maxWeight: GlobalEntity.dataFilter(datas['maximum_weight']),
      minNumber: GlobalEntity.dataFilter(datas['minimum_number']),
      maxNumber: GlobalEntity.dataFilter(datas['maximum_number']),
      rate: rate,
      options: options,
    );
  }
}
