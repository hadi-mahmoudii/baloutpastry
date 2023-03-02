import '../../../Core/Config/urls.dart';
import '../../Product/Screens/special_cake.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../Models/my_special_order.dart';
import '../Providers/special_order_details.dart';

class SpecialOrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpecialOrderDetailsProvider>(
      create: (ctx) => SpecialOrderDetailsProvider(
          (ModalRoute.of(context)!.settings.arguments as MySpecialOrderModel)),
      child: SpecialOrderDetailsScreenTile(),
    );
  }
}

class SpecialOrderDetailsScreenTile extends StatefulWidget {
  const SpecialOrderDetailsScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SpecialOrderDetailsScreenTileState createState() =>
      _SpecialOrderDetailsScreenTileState();
}

class _SpecialOrderDetailsScreenTileState
    extends State<SpecialOrderDetailsScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialOrderDetailsProvider>(
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
                    SizedBox(height: 20),
                    ElementBox(
                      title: 'نوع کیک',
                      label: provider.order.type,
                      icon: FlutterIcons.align_right,
                    ),
                    SizedBox(height: 20),
                    ElementBox(
                      title: 'متن روی کیک',
                      label: provider.order.textAroundItem,
                      icon: FlutterIcons.align_right,
                    ),
                    SizedBox(height: 20),
                    ElementBox(
                      title: 'توضیحات کیک',
                      label: provider.order.description,
                      icon: FlutterIcons.align_right,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElementBox(
                            title: 'مقدار',
                            label: provider.order.amount,
                            icon: FlutterIcons.weight_kilogram,
                          ),
                        ),
                        Expanded(
                          child: ElementBox(
                            title: 'طعم کیک',
                            label: provider.order.taste,
                            icon: FlutterIcons.align_right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElementBox(
                            title: 'ساعت تحویل',
                            label: provider.order.sendHour,
                            icon: FlutterIcons.calendar_alt,
                          ),
                        ),
                        Expanded(
                          child: ElementBox(
                            title: 'روز تحویل',
                            label: provider.order.sendDate,
                            icon: FlutterIcons.calendar_alt,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Image.network(
                        provider.order.image!,
                        height: 200,
                        fit: BoxFit.fill,
                        errorBuilder: (ctx, _, __) => Image.asset(
                          'assets/Images/placeholder.png',
                          fit: BoxFit.fill,
                          height: 200,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              provider.order.price!,
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
                    provider.order.statutPayment == '1'
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            child: SubmitButton(
                              label: 'پرداخت',
                              function: () => launch(
                                Urls.specialOrderPayment(provider.order.id!),
                              ),
                            ),
                          )
                        : SizedBox(height: 30),
                    SizedBox(height: 70),
                  ],
                ),
        ),
      ),
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
                        fontSize: 11,
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
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 7),
            Container(
              child: Icon(
                icon,
                color: mainFontColor,
                size: 25,
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
