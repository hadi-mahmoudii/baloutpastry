import '../../../Core/Widgets/empty.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Models/category.dart';
import '../Providers/product_list.dart';
import '../Widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductListProvider>(
      create: (ctx) => ProductListProvider(
          ModalRoute.of(context)!.settings.arguments as CategoryModel),
      child: ProductListScreenTile(),
    );
  }
}

class ProductListScreenTile extends StatefulWidget {
  const ProductListScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _ProductListScreenTileState createState() => _ProductListScreenTileState();
}

class _ProductListScreenTileState extends State<ProductListScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProductListProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListProvider>(
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
          body: provider.isLoading
              ? Center(
                  child: LoadingWidget(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        if (provider.scrollController.position.pixels >
                                provider.scrollController.position
                                        .maxScrollExtent -
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
                              asset: provider.asset,
                              persian: provider.category.name,
                              english: provider.category.eName,
                            ),
                          ),
                          SizedBox(height: 20),
                          provider.products.length > 0
                              ? GridView.builder(
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
