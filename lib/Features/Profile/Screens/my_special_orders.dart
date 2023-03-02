import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/empty.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Models/my_special_order.dart';
import '../Providers/my_special_orders.dart';

class MySpecialOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MySpecialOrdersProvider>(
      create: (ctx) => MySpecialOrdersProvider(),
      child: MySpecialOrdersScreenTile(),
    );
  }
}

class MySpecialOrdersScreenTile extends StatefulWidget {
  const MySpecialOrdersScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _MySpecialOrdersScreenTileState createState() =>
      _MySpecialOrdersScreenTileState();
}

class _MySpecialOrdersScreenTileState extends State<MySpecialOrdersScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MySpecialOrdersProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MySpecialOrdersProvider>(
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
                              asset: 'birthday-cake',
                              persian: 'سفارشات خاص من',
                              english: 'My special orders',
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
                                        SpecialOrderRowNavigator(
                                      order: provider.datas[ind],
                                      deleteFunction: () =>
                                          provider.deleteOrder(
                                              context, provider.datas[ind].id!),
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

class SpecialOrderRowNavigator extends StatelessWidget {
  final MySpecialOrderModel order;
  final Function deleteFunction;
  const SpecialOrderRowNavigator({
    Key? key,
    required this.order,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.mySpecialOrder, arguments: order),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: mainFontColor,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: Text(
                          'آیا برای حذف این درخواست اطمینان دارید؟',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: mainFontColor),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              deleteFunction();
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              'بله',
                              style: TextStyle(color: mainFontColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              'خیر',
                              style: TextStyle(color: mainFontColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[700],
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 30,
                          color: Colors.red[700]!.withOpacity(.3),
                          offset: Offset(0, 15),
                          // spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        order.type!,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Container(
                      child: Text(
                        '${order.sendDate} - ${order.sendHour}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 10,
                          fontFamily: 'iranyekanlight',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: mainFontColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      order.amount!,
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration: BoxDecoration(
                    color: mainFontColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    order.status!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      // fontFamily: 'iranyekanlight',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   '2000',
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     color: mainFontColor,
                      //     fontSize: 12,
                      //     fontFamily: 'pacifico',
                      //     height: 1,
                      //     decoration: TextDecoration.lineThrough,
                      //   ),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      Text(
                        order.price!,
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
      ),
    );
  }
}
