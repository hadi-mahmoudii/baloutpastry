import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();
  TextEditingController searchCtrl = TextEditingController();

  getDatas(BuildContext context, {bool resetPage = false}) async {}
  @override
  void reassemble() {}
}
