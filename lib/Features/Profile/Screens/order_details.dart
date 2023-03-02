import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../Product/Models/product.dart';
import '../../Shop/Widgets/prices_row_box.dart';
import '../Models/my_orders.dart';
import '../Providers/order_details.dart';

class OrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderDetailsProvider>(
      create: (ctx) => OrderDetailsProvider(
          (ModalRoute.of(context)!.settings.arguments as MyOrdersModel)),
      child: OrderDetailsScreenTile(),
    );
  }
}

class OrderDetailsScreenTile extends StatefulWidget {
  const OrderDetailsScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _OrderDetailsScreenTileState createState() => _OrderDetailsScreenTileState();
}

class _OrderDetailsScreenTileState extends State<OrderDetailsScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(
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
              : ListView(
                  controller: provider.scrollController,
                  children: [
                    SizedBox(height: 30),
                    OrderStatusBox(
                      status: provider.order.status,
                    ),
                    provider.order.address!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElementBox(
                              title: 'محل ارسال',
                              label: provider.order.address,
                              icon: FlutterIcons.location,
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElementBox(
                            title: 'ساعت تحویل',
                            label: provider.order.hourDate,
                            icon: FlutterIcons.clock,
                          ),
                        ),
                        Expanded(
                          child: ElementBox(
                            title: 'تاریخ تحویل',
                            label: provider.order.dayDate,
                            icon: FlutterIcons.calendar,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
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
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, ind) => OrderRowBox(
                          product: provider.order.products![ind],
                        ),
                        separatorBuilder: (ctx, ind) => SizedBox(height: 10),
                        itemCount: provider.order.products!.length,
                      ),
                    ),
                    provider.order.branch!.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    provider.order.branch!,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: mainFontColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 5),
                                Container(
                                  child: Text(
                                    'شعبه',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: mainFontColor,
                                      fontSize: 12,
                                      fontFamily: 'iranyekanlight',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    provider.order.totalDiscount != ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: PricesRowBox(
                              label: 'مبلغ تخفیف شما',
                              price: provider.order.totalDiscount,
                              color: Color(0XFF32CAD5),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              provider.order.totalDeposit!,
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
                              'مبلغ بیعانه',
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              provider.order.totalPrice!,
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              provider.order.shippingCost!,
                              // textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: mainFontColor,
                                fontSize: 22,
                                fontFamily: 'pacifico',
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                          ),
                          // SizedBox(height: 5),
                          Container(
                            child: Text(
                              'هزینه ی ارسال',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: mainFontColor,
                                fontSize: 12,
                                fontFamily: 'iranyekanlight',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
        ),
      ),
    );
  }
}

class OrderRowBox extends StatelessWidget {
  final ProductModel? product;
  const OrderRowBox({
    Key? key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: LayoutBuilder(builder: (ctx, cons) {
        final headerImageCons = cons.maxWidth / 3;
        // final littleImageCons = headerImageCons / 3 - 5;
        return Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: mainFontColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 15),
                    Container(
                      child: Text(
                        product!.name!,
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
                              product!.unit! == 'kg'
                                  ? product!.amount! == ''
                                      ? product!.count!
                                      : product!.amount!
                                  : product!.amount!,
                              style: TextStyle(
                                color: mainFontColor,
                                fontSize: 19,
                                fontFamily: 'pacifico',
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            Text(
                              product!.unit == 'kg'
                                  ? product!.amount == ''
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
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              product!.discount! != '' &&
                                      product!.discount! != '0'
                                  ? Text(
                                      product!.discount!,
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
                                product!.isNumbericType!
                                    ? product!.priceN!
                                    : product!.priceK!,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: mainFontColor,
                                  fontFamily: 'pacifico',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product!.isNumbericType!
                                    ? "تومان - هر ${product!.unit == 'kg' ? product!.amount == '' ? 'عدد' : 'کیلو' : 'عدد'}"
                                    : 'تومان - ${product!.unit == 'kg' ? product!.amount == '' ? 'عدد' : 'کیلو' : 'عدد'}',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: mainFontColor,
                                  fontSize: 8,
                                  fontFamily: 'iranyekanlight',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: headerImageCons,
                  // maxHeight: 90,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    product!.mainImage!,
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

class ElementBox extends StatelessWidget {
  final String? title;
  final String? label;
  final IconData? icon;
  const ElementBox({
    Key? key,
    @required this.title,
    @required this.label,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: mainFontColor,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(builder: (ctx, cons) {
        // print(cons.maxWidth);
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      title!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 12,
                        fontFamily: 'iranyekanlight',
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      label!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              child: Icon(
                icon,
                color: mainFontColor,
                size: 29,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class OrderStatusBox extends StatelessWidget {
  final String? status;
  const OrderStatusBox({
    Key? key,
    @required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        border: Border(
          top: BorderSide(color: Color(0XFF3398DB)),
          bottom: BorderSide(color: Color(0XFF3398DB)),
        ),
        color: Color(0XFF3398DB).withOpacity(.15),
      ),
      child: Row(
        children: [
          Icon(
            FlutterIcons.clock_1,
            color: Color(0XFF3398DB),
            size: 40,
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              Container(
                child: Text(
                  'وضعیت سفارش',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Color(0XFF32CAD5),
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Text(
                  status!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Color(0XFF32CAD5),
                    fontSize: 18,
                  ),
                ),
              ),
              // Container(
              //   child: Text(
              //     'Processing',
              //     textDirection: TextDirection.rtl,
              //     style: TextStyle(
              //       color: Color(0XFF32CAD5),
              //       fontSize: 16,
              //       fontFamily: 'pacifico',
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
