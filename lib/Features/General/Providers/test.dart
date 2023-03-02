import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestProvider extends ChangeNotifier with ReassembleHandler {
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  getDatas(BuildContext context, {bool resetPage = false}) async {}
  @override
  void reassemble() {}
}
