import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/my_special_order.dart';

class SpecialOrderDetailsProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  final MySpecialOrderModel order;

  SpecialOrderDetailsProvider(this.order);

  getDatas(BuildContext context, {bool resetPage = false}) async {}
  @override
  void reassemble() {}
}
