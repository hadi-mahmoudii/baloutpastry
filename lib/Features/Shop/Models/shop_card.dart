// import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../Core/Models/global.dart';
import '../../Product/Models/option.dart';

class ShopCardModel {
  final String id,
      totalPrice,
      totalDeposit,
      totalDiscount,
      remainPrice,
      code,
      status;
  final List<ShopCardRowModel> cards;
  ShopCardModel({
    required this.id,
    required this.totalPrice,
    required this.totalDeposit,
    required this.totalDiscount,
    required this.remainPrice,
    required this.code,
    required this.status,
    required this.cards,
  });
  factory ShopCardModel.fromJson(Map datas) {
    final formatter = new NumberFormat("#,###");
    String priceT = '';
    String priceR = '';
    String priceDep = '';
    String priceDis = '';

    try {
      priceT = formatter.format(datas['total']);
    } catch (e) {}
    try {
      priceR = formatter.format(datas['remain']);
    } catch (e) {}
    try {
      priceDep = formatter.format(datas['deposit']);
    } catch (e) {}

    List<ShopCardRowModel> cards = [];
    int totalDiscount = 0;
    try {
      datas['products'].forEach((element) {
        cards.add(ShopCardRowModel.fromJson(element));
        totalDiscount += int.parse(element['discount'].toString());
        // print(element);
      });
    } catch (e) {}
    try {
      priceDis = formatter.format(totalDiscount);
    } catch (e) {}

    return ShopCardModel(
      id: GlobalEntity.dataFilter(datas['id']),
      totalPrice: priceT,
      totalDeposit: priceDep,
      code: GlobalEntity.dataFilter(datas['code']),
      totalDiscount: priceDis,
      remainPrice: priceR,
      status: GlobalEntity.dataFilter(datas['status']),
      cards: cards,
    );
  }
}

class ShopCardRowModel {
  final String id, amount, name, count, image;
  final String price, deposit, depositPercent, unit;
  final List<ProductOptionModel> options;

  ShopCardRowModel({
    required this.id,
    required this.amount,
    required this.name,
    required this.count,
    required this.image,
    required this.price,
    required this.deposit,
    required this.depositPercent,
    required this.unit,
    required this.options,
  });
// 'oxtun':'elham',
//            'lcseu':'goli',
  factory ShopCardRowModel.fromJson(Map datas) {
    // log(datas.toString());
    // for (var key in datas.keys) {
    //   print(key);
    //   print(datas[key]);
    // }
    // print('---------------------------');
    final formatter = new NumberFormat("#,###");
    String price = '';
    try {
      price = formatter.format(datas['price']);
    } catch (e) {}
    String imagePath = '';
    try {
      imagePath = 'https://www.shirinibalout.com/' +
          GlobalEntity.dataFilter(datas['thumbnail']);
    } catch (e) {}
    List<ProductOptionModel> options = [];
    try {
      datas['options'].forEach((element) {
        options.add(ProductOptionModel.fromJson(element));
        // print(result['children']);
      });
    } catch (e) {}
    return ShopCardRowModel(
      id: GlobalEntity.dataFilter(datas['id']),
      amount: GlobalEntity.dataFilter(datas['amount']),
      name: GlobalEntity.dataFilter(datas['name']),
      count: GlobalEntity.dataFilter(datas['count']),
      image: imagePath,
      price: price,
      deposit: GlobalEntity.dataFilter(datas['deposit_payment']),
      depositPercent: GlobalEntity.dataFilter(datas['deposit_percent']),
      unit: GlobalEntity.dataFilter(datas['unit']),
      options: options,
    );
  }
}
