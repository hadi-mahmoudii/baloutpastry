import '../../../Core/Widgets/empty.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../Product/Widgets/product_card.dart';
import '../Providers/search.dart';
import '../Widgets/search-box.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
      create: (ctx) =>
          SearchProvider(ModalRoute.of(context)!.settings.arguments as String),
      child: SearchScreenTile(),
    );
  }
}

class SearchScreenTile extends StatefulWidget {
  const SearchScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenTileState createState() => _SearchScreenTileState();
}

class _SearchScreenTileState extends State<SearchScreenTile> {
  @override
  initState() {
    // print('objects');
    super.initState();
    Future.microtask(
      () =>
          Provider.of<SearchProvider>(context, listen: false).getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (ctx, provider, _) => SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
          floatingActionButton:
              AppSession.token != '' ? GlobalCardNavigator() : null,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: GlobalAppbar(
              icon: FlutterIcons.logout,
              function: () async {},
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  if (provider.scrollController.position.pixels >
                          provider.scrollController.position.maxScrollExtent -
                              30 &&
                      !provider.isLoadingMore) {
                    provider.getDatas(context);
                  }
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async =>
                    provider.getDatas(context, resetPage: true),
                child: ListView(
                  controller: provider.scrollController,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: SimpleHeader(
                        asset: 'loupe',
                        persian: 'جستجو تو یه دنیای خوشمزه',
                        english: 'Search in a delicious world',
                      ),
                    ),
                    SearchBox(),
                    provider.isLoading
                        ? Center(
                            child: LoadingWidget(),
                          )
                        : provider.products.length > 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (ctx, ind) => ProductCard(
                                    product: provider.products[ind],
                                  ),
                                  itemCount: provider.products.length,
                                ),
                              )
                            : EmptyWidget(),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
