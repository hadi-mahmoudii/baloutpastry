import '../../../Core/Widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/circle_submit_button.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Models/shop_card.dart';
import '../Providers/shop_card.dart';
import '../Widgets/prices_row_box.dart';

class ShopCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopCardProvider>(
      create: (ctx) => ShopCardProvider(),
      child: ShopCardScreenTile(),
    );
  }
}

class ShopCardScreenTile extends StatefulWidget {
  const ShopCardScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _ShopCardScreenTileState createState() => _ShopCardScreenTileState();
}

class _ShopCardScreenTileState extends State<ShopCardScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ShopCardProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCardProvider>(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: RefreshIndicator(
                      onRefresh: () async => provider.getDatas(context),
                      child: provider.card.totalPrice == '0'
                          ? EmptyWidget()
                          : ListView(
                              children: [
                                SizedBox(height: 20),
                                Center(
                                  child: SimpleHeader(
                                    asset: 'shopping-bag (1)',
                                    persian: 'آیتم های سفارش',
                                    english: 'Order items',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) => OrderRowBox(
                                      card: provider.card.cards[ind],
                                      deleteFunc: provider.deleteCardRow,
                                      ct: context,
                                    ),
                                    separatorBuilder: (ctx, ind) =>
                                        SizedBox(height: 10),
                                    itemCount: provider.card.cards.length,
                                  ),
                                ),
                                SizedBox(height: 20),
                                PricesRowBox(
                                  label: 'مبلغ تخفیف شما',
                                  price: provider.card.totalDiscount,
                                  color: Color(0XFF32CAD5),
                                ),
                                SizedBox(height: 10),
                                PricesRowBox(
                                  label: 'مبلغ بیعانه',
                                  price: provider.card.totalDeposit,
                                  color: Colors.red[800],
                                ),
                                SizedBox(height: 10),
                                PricesRowBox(
                                  label: 'مبلغ حدودی باقیمانده درهنگام تحویل',
                                  price: provider.card.remainPrice,
                                  color: Colors.pink[800],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      CircleSubmitButton(
                                        func: () {
                                          if (provider.card.totalPrice.length <
                                              6)
                                            Fluttertoast.showToast(
                                                msg:
                                                    'حداقل مبلغ خرید باید 10000 تومان باشد');
                                          else
                                            Navigator.of(context).pushNamed(
                                                Routes.selectAddress);
                                        },
                                        icon: FlutterIcons.angle_left,
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              provider.card.totalPrice,
                                              // textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: mainFontColor,
                                                fontSize: 33,
                                                fontFamily: 'pacifico',
                                                fontWeight: FontWeight.bold,
                                                height: 1.25,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(height: 5),
                                          Container(
                                            child: Text(
                                              'مبلغ کل',
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: mainFontColor,
                                                fontSize: 13,
                                                fontFamily: 'iranyekanlight',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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

class OrderRowBox extends StatelessWidget {
  final ShopCardRowModel? card;
  final Function? deleteFunc;
  final BuildContext? ct;
  const OrderRowBox({
    Key? key,
    @required this.card,
    @required this.deleteFunc,
    @required this.ct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: LayoutBuilder(builder: (ctx, cons) {
        final headerImageCons = cons.maxWidth * 3 / 10;
        // final littleImageCons = headerImageCons / 3 - 5;
        return Container(
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: mainFontColor,
            ),
          ),
          child: Row(
            children: [
              // SizedBox(width: 10),
              InkWell(
                onTap: () => deleteFunc!(card!.id, ct),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0XFFEE3552),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 30,
                        color: Color(0XFFEE3552).withOpacity(.3),
                        offset: Offset(0, 15),
                        // spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    FlutterIcons.minus,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: 15),
              // Container(
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color(0XFF32CAD5),
              //     boxShadow: <BoxShadow>[
              //       BoxShadow(
              //         blurRadius: 30,
              //         color: Color(0XFF32CAD5).withOpacity(.3),
              //         offset: Offset(0, 15),
              //         // spreadRadius: 5,
              //       ),
              //     ],
              //   ),
              //   padding: EdgeInsets.all(10),
              //   child: Icon(
              //     Icons.edit,
              //     color: Colors.white,
              //     size: 22,
              //   ),
              // ),
              // SizedBox(width: 5),
              Expanded(
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 15),
                    Container(
                      child: Text(
                        card!.name,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                              card!.unit == 'kg'
                                  ? card!.amount
                                          .isEmpty // this use in optional cases
                                      ? card!.count
                                      : card!.amount
                                  : card!.amount,
                              style: TextStyle(
                                color: mainFontColor,
                                fontSize: 19,
                                fontFamily: 'pacifico',
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            Text(
                              card!.unit == 'kg'
                                  ? card!.amount
                                          .isEmpty // this use in optional cases
                                      ? 'عدد'
                                      : 'کیلو'
                                  : 'عدد',
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
                        Expanded(
                          child: Container(
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
                                  card!.price,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: headerImageCons,
                  // maxHeight: 90,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    card!.image,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => Image.asset(
                      'assets/Images/placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
