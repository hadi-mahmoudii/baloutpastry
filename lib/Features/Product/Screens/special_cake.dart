import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../../Core/Widgets/static_bottom_selector.dart';
import '../Providers/special_cake.dart';

class SpecialCakeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpecialCakeProvider>(
      create: (ctx) => SpecialCakeProvider(),
      child: SpecialCakeScreenTile(),
    );
  }
}

class SpecialCakeScreenTile extends StatefulWidget {
  const SpecialCakeScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SpecialCakeScreenTileState createState() => _SpecialCakeScreenTileState();
}

class _SpecialCakeScreenTileState extends State<SpecialCakeScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<SpecialCakeProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialCakeProvider>(
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
                  child: RefreshIndicator(
                    onRefresh: () async => provider.getDatas(context),
                    child: ListView(
                      controller: provider.scrollController,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: SimpleHeader(
                            asset: 'birthday-cake',
                            persian: 'سفارش کیک خاص',
                            english: 'Order a special cake',
                          ),
                        ),
                        StaticBottomSelector(
                          color: mainFontColor,
                          icon: FlutterIcons.align_right,
                          label: 'نوع کیک',
                          controller: provider.typeCtrl,
                          datas: provider.types,
                          // function: () {
                          //   provider.changeSelectedDayId();
                          // },
                        ),
                        // InputBox(
                        //   // color: Colors.black,
                        //   icon: FlutterIcons.align_right,
                        //   label: 'نوع کیک',
                        //   controller: provider.typeCtrl,
                        // ),
                        SizedBox(height: 20),
                        InputBox(
                          // color: Colors.black,
                          icon: FlutterIcons.align_right,
                          label: 'متن روی کیک',
                          controller: provider.textCtrl,
                        ),
                        SizedBox(height: 20),
                        InputBox(
                          // color: Colors.black,
                          icon: FlutterIcons.align_right,
                          label: 'توضیحات کیک',
                          controller: provider.descCtrl,
                          minLines: 3,
                          maxLines: 5,
                        ),
                        SizedBox(height: 20),
                        StaticBottomSelector(
                          color: mainFontColor,
                          icon: FlutterIcons.align_right,
                          label: 'طعم کیک',
                          controller: provider.tasteCtrl,
                          datas: provider.tastes,
                          // function: () {
                          //   provider.changeSelectedDayId();
                          // },
                        ),
                        // InputBox(
                        //   // color: Colors.black,
                        //   icon: FlutterIcons.align_right,
                        //   label: 'طعم کیک',
                        //   controller: provider.tasteCtrl,
                        // ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'KG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mainFontColor,
                                    fontFamily: 'pacifico',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'کیلوگرم',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mainFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputBox(
                                icon: FlutterIcons.number,
                                label: 'چه مقدار',
                                controller: provider.countCtrl,
                                textType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        StaticBottomSelector(
                          color: mainFontColor,
                          icon: FlutterIcons.align_right,
                          label: 'روز تحویل',
                          controller: provider.dayCtrl,
                          datas: provider.days,
                          function: () {
                            provider.changeSelectedDayId();
                          },
                        ),
                        !provider.letSelectHour
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                ),
                                child: StaticBottomSelector(
                                  color: mainFontColor,
                                  icon: FlutterIcons.align_right,
                                  label: 'ساعت تحویل',
                                  controller: provider.hourCtrl,
                                  datas: provider.hours,
                                ),
                              ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: SubmitButton(
                                  label: 'انتخاب عکس',
                                  function: () => provider.pickFile(),
                                  icon: Icons.add,
                                ),
                              ),
                              SizedBox(width: 10),
                              provider.imagePath.isNotEmpty
                                  ? Expanded(
                                      child: Image.file(
                                        File(provider.imagePath),
                                        fit: BoxFit.contain,
                                        height: 100,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: SubmitButton(
                            label: 'ثبت کیک برای بررسی',
                            function: () => provider.sendRequst(context),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Function? function;
  const SubmitButton({
    Key? key,
    @required this.label,
    @required this.function,
    this.icon = FlutterIcons.check_1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function!(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color(0XFF32CAD5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 30,
              color: Color(0XFF32CAD5).withOpacity(.3),
              offset: Offset(0, 15),
              // spreadRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label!,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
