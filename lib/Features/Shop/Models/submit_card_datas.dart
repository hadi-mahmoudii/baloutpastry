import 'package:flutter/material.dart';

import '../../../Core/Models/date-convertor.dart';
import '../../../Core/Models/global.dart';

class SubmitCardDatasModel {
  final List<DateRowModel>? dates;
  final List<AddressRowModel>? addresses;
  final String? payment;

  SubmitCardDatasModel({
    @required this.dates,
    @required this.addresses,
    @required this.payment,
  });
  factory SubmitCardDatasModel.fromJson(Map? datas) {
    List<DateRowModel> dates = [];
    try {
      datas!['dates'].forEach((element) {
        dates.add(DateRowModel.fromJson(element));
      });
    } catch (e) {}

    List<AddressRowModel> addresses = [];
    try {
      datas!['addresses'].forEach((element) {
        // print(element);
        addresses.add(AddressRowModel.fromJson(element));
      });
    } catch (e) {}
    return SubmitCardDatasModel(
      dates: dates,
      addresses: addresses,
      payment: GlobalEntity.dataFilter(datas!['deposit']),
    );
  }
}

class DateRowModel {
  final String? date;
  final List<TimeRowModel>? times;

  DateRowModel({
    @required this.date,
    @required this.times,
  });

  factory DateRowModel.fromJson(Map? datas) {
    List<TimeRowModel> times = [];
    try {
      datas!['times'].forEach((element) {
        times.add(TimeRowModel.fromJson(element));
      });
    } catch (e) {}
    return DateRowModel(
      date: DateConvertor.dateToJalali(GlobalEntity.dataFilter(datas!['date'])),
      times: times,
    );
  }
}

class TimeRowModel {
  final String? id, time;
  TimeRowModel({
    @required this.id,
    @required this.time,
  });
  factory TimeRowModel.fromJson(Map? datas) {
    return TimeRowModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      time: GlobalEntity.dataFilter(datas['value']),
    );
  }
}

class AddressRowModel {
  final String? id,
      address,
      cityId,
      cityName,
      regionId,
      regionName,
      shippingCost;
  AddressRowModel({
    @required this.id,
    @required this.address,
    @required this.cityId,
    @required this.cityName,
    @required this.regionId,
    @required this.regionName,
    @required this.shippingCost,
  });
  factory AddressRowModel.fromJson(Map? datas) {
    String cityName = '';
    try {
      cityName = GlobalEntity.dataFilter(datas!['city']['name_fa']);
    } catch (e) {}
    String regionName = '';
    try {
      regionName = GlobalEntity.dataFilter(datas!['region']['name_fa']);
    } catch (e) {}
    String shippingCost = '';
    try {
      shippingCost = GlobalEntity.dataFilter(datas!['region']['shipping_cost']);
    } catch (e) {}
    return AddressRowModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      address: GlobalEntity.dataFilter(datas['address']),
      cityId: GlobalEntity.dataFilter(datas['city_id']),
      cityName: cityName,
      regionId: GlobalEntity.dataFilter(datas['region_id']),
      regionName: regionName,
      shippingCost: shippingCost,
    );
  }
}

class BranchRowModel {
  final String? id, name;
  BranchRowModel({
    @required this.id,
    @required this.name,
  });
  factory BranchRowModel.fromJson(Map? datas) {
    return BranchRowModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name']),
    );
  }
}
