import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../Providers/test.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TestProvider>(
      create: (ctx) => TestProvider(),
      child: TestScreenTile(),
    );
  }
}

class TestScreenTile extends StatefulWidget {
  const TestScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _TestScreenTileState createState() => _TestScreenTileState();
}

class _TestScreenTileState extends State<TestScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (ctx, provider, _) => SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: GlobalAppbar(
              icon: FlutterIcons.logout,
              function: () async {},
            ),
          ),
          body: provider.isLoading
              ? Center(
                  child: LoadingWidget(),
                )
              : NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      if (provider.scrollController.position.pixels >
                              provider.scrollController.position
                                      .maxScrollExtent -
                                  30 &&
                          provider.isLoadingMore) {}
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async => print('object'),
                    child: ListView(
                      children: [],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
