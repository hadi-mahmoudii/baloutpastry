import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/circle_submit_button.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../Product/Screens/special_cake.dart';
import '../Providers/payment.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentProvider>(
      create: (ctx) => PaymentProvider(),
      child: PaymentScreenTile(),
    );
  }
}

class PaymentScreenTile extends StatefulWidget {
  const PaymentScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentScreenTileState createState() => _PaymentScreenTileState();
}

class _PaymentScreenTileState extends State<PaymentScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
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
              : ListView(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: SimpleHeader(
                        asset: 'coupon',
                        persian: 'کد تخفیف',
                        english: 'Discount code',
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleSubmitButton(
                            func: () {
                              // Navigator.of(context).pushNamed(Routes.payment);
                            },
                            icon: FlutterIcons.check_1,
                            color: Color(0Xff32CAD5),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InputBox(
                              icon: FlutterIcons.number,
                              label: 'کد تخفیف را وارد کنید',
                              controller: provider.discountCtrl,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    // PricesRowBox(
                    //   label: 'مبلغ تخفیف شما',
                    //   price: provider.card.totalDeposit,
                    //   color: Color(0XFF32CAD5),
                    // ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '245000',
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
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '3',
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
                                  'آیتم',
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
                    SizedBox(height: 15),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 25),
                      child: SubmitButton(
                        label: 'تاییدنهایی سفارش و پرداخت مبلغ',
                        function: () {},
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
