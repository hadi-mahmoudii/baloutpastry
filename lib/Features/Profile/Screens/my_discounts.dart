import '../../../Core/Widgets/empty.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../Models/my_discount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Providers/my_discounts.dart';

class MyDiscountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyDiscountsProvider>(
      create: (ctx) => MyDiscountsProvider(),
      child: MyDiscountsScreenTile(),
    );
  }
}

class MyDiscountsScreenTile extends StatefulWidget {
  const MyDiscountsScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _MyDiscountsScreenTileState createState() => _MyDiscountsScreenTileState();
}

class _MyDiscountsScreenTileState extends State<MyDiscountsScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MyDiscountsProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDiscountsProvider>(
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
                              asset: 'coupon',
                              persian: 'کدهای تخفیف من',
                              english: 'My discounts',
                            ),
                          ),
                          // SizedBox(height: 10),
                          provider.datas.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) => DiscountRowBox(
                                      discount: provider.datas[ind],
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

class DiscountRowBox extends StatelessWidget {
  final MyDiscountModel? discount;
  const DiscountRowBox({
    Key? key,
    @required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0XFF32CAD5)),
          color: Color(0XFF32CAD5).withOpacity(.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: EdgeInsets.all(8),
              child: Icon(
                FlutterIcons.align_right,
                color: Colors.white,
                size: 18,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تاریخ انقضا',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0XFF59413E),
                          fontSize: 7,
                        ),
                      ),
                      Text(
                        discount!.expire!,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0XFF59413E),
                          fontSize: 10,
                          fontFamily: 'iranyelanlight',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  Icon(
                    FlutterIcons.clock,
                    color: Color(0xFF59413E),
                    size: 20,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  discount!.amount! != '0'
                      ? discount!.amount!
                      : discount!.percent!,
                  style: TextStyle(
                    color: Color(0XFF32CAD5),
                    fontSize: 19,
                    fontFamily: 'pacifico',
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                Text(
                  discount!.amount! != '0' ? 'تومان - تخفیف' : 'درصد - تخفیف',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Color(0XFF32CAD5),
                    fontSize: 8,
                    fontFamily: 'iranyelanlight',
                    height: 1.25,
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
