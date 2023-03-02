import '../../../Core/Widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Models/my_orders.dart';
import '../Providers/my_orders.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyOrdersProvider>(
      create: (ctx) => MyOrdersProvider(),
      child: MyOrdersScreenTile(),
    );
  }
}

class MyOrdersScreenTile extends StatefulWidget {
  const MyOrdersScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _MyOrdersScreenTileState createState() => _MyOrdersScreenTileState();
}

class _MyOrdersScreenTileState extends State<MyOrdersScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MyOrdersProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyOrdersProvider>(
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
                            provider.isLoadingMore) {}
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          provider.getDatas(context, resetPage: true),
                      child: ListView(
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: SimpleHeader(
                              asset: 'shopping-bag (1)',
                              persian: 'سفارشات من',
                              english: 'My orders',
                            ),
                          ),
                          // SizedBox(height: 10),
                          provider.datas.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) =>
                                        OrderRowNavigator(
                                      order: provider.datas[ind],
                                    ),
                                    separatorBuilder: (ctx, ind) =>
                                        SizedBox(height: 10),
                                    itemCount: provider.datas.length,
                                  ),
                                )
                              : EmptyWidget(),
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

class OrderRowNavigator extends StatelessWidget {
  final MyOrdersModel? order;
  const OrderRowNavigator({
    Key? key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.orderDetails, arguments: order);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: mainFontColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0XFF32CAD5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 30,
                    color: Color(0XFF32CAD5).withOpacity(.3),
                    offset: Offset(0, 15),
                    // spreadRadius: 5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                FlutterIcons.align_right,
                color: Colors.white,
                size: 22,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              // color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      '${order!.dayDate} - ${order!.hourDate}',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Divider(
                    color: mainFontColor,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            order!.products!.length.toString(),
                            style: TextStyle(
                              color: mainFontColor,
                              fontSize: 19,
                              fontFamily: 'pacifico',
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            'آیتم',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: mainFontColor,
                              fontSize: 8,
                              fontFamily: 'iranyelanlight',
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            order!.totalDiscount! != ""
                                ? Text(
                                    order!.totalDiscount!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: mainFontColor,
                                      fontSize: 12,
                                      fontFamily: 'pacifico',
                                      height: 1,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Container(),
                            Text(
                              order!.totalPrice!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: mainFontColor,
                                fontFamily: 'pacifico',
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'تومان - مبلغ کل',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: mainFontColor,
                                fontSize: 8,
                                fontFamily: 'iranyekanlight',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
