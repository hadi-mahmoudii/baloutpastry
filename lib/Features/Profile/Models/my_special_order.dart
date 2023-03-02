import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Core/Models/global.dart';

class MySpecialOrderModel {
  final String? id,
      type,
      textAroundItem,
      description,
      taste,
      sendDate,
      sendHour,
      image,
      price,
      amount,
      status,
      statutPayment;
  MySpecialOrderModel({
    @required this.id,
    @required this.type,
    @required this.textAroundItem,
    @required this.description,
    @required this.taste,
    @required this.sendDate,
    @required this.sendHour,
    @required this.image,
    @required this.price,
    @required this.amount,
    @required this.status,
    @required this.statutPayment,

  });
  factory MySpecialOrderModel.fromJson(Map datas) {
    // for (var key in datas.keys) {
    //   print(key);
    //   print(datas[key]);
    // }
    final formatter = new NumberFormat("#,###");
    String price = '-';
    try {
      price = formatter.format(int.parse(datas['price'].toString()));
    } catch (e) {}
    return MySpecialOrderModel(
      id: GlobalEntity.dataFilter(datas['id']),
      type: GlobalEntity.dataFilter(datas['type']),
      textAroundItem: GlobalEntity.dataFilter(datas['text_around_item']),
      description: GlobalEntity.dataFilter(datas['description']),
      taste: GlobalEntity.dataFilter(datas['taste']),
      sendDate: GlobalEntity.dataFilter(datas['send_date']),
      sendHour: GlobalEntity.dataFilter(datas['send_hour']),
      image: GlobalEntity.dataFilter(
          'https://www.shirinibalout.com/' + datas['image']['thumbnail']),
      status: GlobalEntity.dataFilter(datas['status']['name']),
      price: price,
      amount: GlobalEntity.dataFilter(datas['amount']),
      statutPayment: GlobalEntity.dataFilter(datas['status_payment']),

    );
  }
}
