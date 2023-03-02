import 'package:flutter/material.dart';

import '../../../Core/Models/global.dart';

class CategoryModel {
  final String? id, name, eName, parentId;
  final bool? hasChild;

  CategoryModel({
    @required this.id,
    @required this.name,
    @required this.eName,
    @required this.hasChild,
    @required this.parentId,
  });

  factory CategoryModel.fromJson(Map? datas, String parentId) {
    return CategoryModel(
      id: GlobalEntity.dataFilter(datas!['id']),
      name: GlobalEntity.dataFilter(datas['name']),
      eName: GlobalEntity.dataFilter(datas['name_en']),
      hasChild: datas['has_children'],
      parentId: parentId,
    );
  }
}
