import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/my_orders.dart';

class OrderDetailsProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  final MyOrdersModel order;

  OrderDetailsProvider(this.order);

  getDatas(BuildContext context, {bool resetPage = false}) async {}
  @override
  void reassemble() {}
}
