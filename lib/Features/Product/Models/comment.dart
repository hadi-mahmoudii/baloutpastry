import 'package:flutter/material.dart';

import '../../../Core/Models/global.dart';

class CommentModel {
  final String? user, rate, comment;

  CommentModel({
    @required this.user,
    @required this.rate,
    @required this.comment,
  });
  factory CommentModel.fromJson(Map? datas) {
    String user = GlobalEntity.dataFilter(datas!['user']['first_name']) +
        ' ' +
        GlobalEntity.dataFilter(datas['user']['last_name']);
    return CommentModel(
      user: user,
      rate: GlobalEntity.dataFilter(datas['rate']),
      comment: GlobalEntity.dataFilter(datas['comment']),
    );
  }
}
