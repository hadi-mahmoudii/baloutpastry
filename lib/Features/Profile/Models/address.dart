import 'package:flutter/material.dart';

import '../../../Core/Models/global.dart';

class CityModel {
  final String? id, name, nameE;
  CityModel({
    @required this.id,
    @required this.name,
    @required this.nameE,
  });
  factory CityModel.fromJson(Map? datas) {
    return CityModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name_fa']),
      nameE: GlobalEntity.dataFilter(datas['name_en']),
    );
  }
}

class RegionModel {
  final String? id, name, cityId;
  RegionModel({
    @required this.id,
    @required this.name,
    @required this.cityId,
  });
  factory RegionModel.fromJson(Map? datas) {
    return RegionModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name_fa']),
      cityId: GlobalEntity.dataFilter(datas['city_id']),
    );
  }
}
