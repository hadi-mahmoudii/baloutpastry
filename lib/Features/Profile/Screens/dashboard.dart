import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/balout_header.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Providers/dashboard.dart';
import '../Widgets/more_info.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardProvider>(
      create: (ctx) => DashboardProvider(),
      child: DashboardScreenTile(),
    );
  }
}

class DashboardScreenTile extends StatefulWidget {
  const DashboardScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardScreenTileState createState() => _DashboardScreenTileState();
}

class _DashboardScreenTileState extends State<DashboardScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
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
              : ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: SimpleHeader(
                          asset: 'smiling',
                          persian: 'حساب کاربری شما',
                          english: 'Your personal dashboard',
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppSession.userName,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 20,
                            color: mainFontColor,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppSession.userPhone,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'pacifico',
                            color: mainFontColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                      DashbourdRowBox(
                        label: 'اطلاعات حساب من',
                        icon: FlutterIcons.user,
                        color: Colors.white,
                        fontColor: mainFontColor,
                        route: Routes.profile,
                      ),
                      DashbourdRowBox(
                        label: 'سفارشات من',
                        icon: FlutterIcons.shopping_bag,
                        color: mainFontColor,
                        fontColor: mainFontColor,
                        route: Routes.myOrders,
                      ),
                      DashbourdRowBox(
                        label: 'سفارشات خاص من',
                        icon: FlutterIcons.birthday,
                        color: Colors.white,
                        fontColor: mainFontColor,
                        route: Routes.mySpecialOrders,
                      ),
                      DashbourdRowBox(
                        label: 'کدهای تخفیف من',
                        icon: FlutterIcons.percent,
                        color: Color(0xFF32CAD5),
                        fontColor: Color(0xFF32CAD5),
                        route: Routes.myDiscounts,
                      ),
                      DashbourdRowBox(
                        label: 'حریم خصوصی',
                        icon: FlutterIcons.shield,
                        color: Colors.white,
                        fontColor: mainFontColor,
                        route: Routes.privacy,
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MoreInfoBox(
                            title: 'وبسایت شیرینی بلوط',
                            function: () => launch(
                              'https://www.shirinibalout.com/',
                            ),
                          ),
                          MoreInfoBox(
                            title: 'آدرس ها و اطلاعات تماس',
                            function: () => launch(
                              'https://www.shirinibalout.com/ContactUs',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      BaloutHeader(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class DashbourdRowBox extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? color;
  final Color? fontColor;
  final String route;
  const DashbourdRowBox({
    Key? key,
    @required this.label,
    @required this.icon,
    @required this.color,
    @required this.fontColor,
    this.route = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: color!.withOpacity(.1),
        ),
        child: Row(
          children: [
            Icon(
              FlutterIcons.angle_left,
              size: 20,
              color: fontColor,
            ),
            Spacer(),
            Text(
              label!,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: fontColor,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              icon,
              size: 20,
              color: fontColor,
            ),
          ],
        ),
      ),
    );
  }
}
