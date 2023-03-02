import 'package:intl/intl.dart';

import '../../../Core/Models/date-convertor.dart';
import '../../../Core/Models/global.dart';
import '../../Product/Models/product.dart';

class MyOrdersModel {
  final String? id,
      totalPrice,
      totalDeposit,
      totalDiscount,
      shippingCost,
      remainPrice,
      address,
      dayDate,
      hourDate,
      status,
      branch;
  final List<ProductModel>? products;
  MyOrdersModel({
    required this.id,
    required this.totalPrice,
    required this.totalDeposit,
    required this.totalDiscount,
    required this.shippingCost,
    required this.remainPrice,
    required this.address,
    required this.dayDate,
    required this.hourDate,
    required this.products,
    required this.status,
    required this.branch,
  });
  factory MyOrdersModel.fromJson(Map datas) {
    // for (var key in datas.keys) {
    //   print(key);
    //   print(datas[key]);
    // }
    final formatter = new NumberFormat("#,###");
    String priceT = '';
    String priceS = '';
    String priceD = '';
    String priceO = '';

    try {
      priceD = formatter.format(int.parse(datas['deposit_payment'].toString()));
    } catch (e) {}
    try {
      priceT = formatter.format(int.parse(datas['total'].toString()));
    } catch (e) {}
    try {
      priceS = formatter.format(int.parse(datas['shipping_cost'].toString()));
    } catch (e) {}
    try {
      priceO = formatter.format(int.parse(datas['discount'].toString()));
    } catch (e) {}
    List<ProductModel> products = [];
    try {
      datas['products'].forEach((element) {
        products.add(ProductModel.fromJson(element));
        // print(result['children']);
      });
    } catch (e) {}

    String address = '';
    try {
      address = GlobalEntity.dataFilter(datas['address']['address']);
    } catch (e) {}
    String branch = '';
    try {
      branch = GlobalEntity.dataFilter(datas['branch']['name']);
    } catch (e) {}
    return MyOrdersModel(
      id: GlobalEntity.dataFilter(datas['id']),
      totalPrice: priceT,
      shippingCost: priceS,
      totalDeposit: priceD,
      address: address,
      totalDiscount: priceO,
      remainPrice: '0',
      dayDate: DateConvertor.dateToJalali(
          GlobalEntity.dataFilter(datas['send_date'])),
      hourDate: GlobalEntity.dataFilter(datas['send_hour']),
      status: GlobalEntity.dataFilter(datas['status']['name']),
      branch: branch,
      products: products,
    );
  }
}
