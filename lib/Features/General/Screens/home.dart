import 'package:baloutpastry/Features/Product/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Providers/home.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (ctx) => HomeProvider(),
      child: HomeScreenTile(),
    );
  }
}

class HomeScreenTile extends StatefulWidget {
  const HomeScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenTileState createState() => _HomeScreenTileState();
}

class _HomeScreenTileState extends State<HomeScreenTile> {
  bool isInit = true;
  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<AppSession>(context, listen: false)
          .tryAutoLogin(context);
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
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
          body: isInit
              ? Center(
                  child: LoadingWidget(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: SimpleHeader(
                          asset: 'chocolate',
                          persian: 'نظرتون درباره ی یه حس خوشمزه؟',
                          english: 'how about a good taste?',
                        ),
                      ),
                      InputBox(
                        // color: Colors.black,
                        icon: FlutterIcons.search,
                        label: 'جست و جو تویه دنیای خوشمزه',
                        controller: provider.searchCtrl,
                        function: () {
                          if (provider.searchCtrl.text.length < 2) {
                            Fluttertoast.showToast(
                                msg: 'حداقل 2 کاراکتر نیاز است');
                          } else {
                            Navigator.of(context).pushNamed(Routes.search,
                                arguments: provider.searchCtrl.text);
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      HomeRowWidget(
                        asset: 'clock (1)',
                        persian: 'محصولات آماده ی ارسال',
                        english: 'Instant delivery',
                        color: Color(0XFFEE3552),
                        categoryId: '0',
                      ),
                      SizedBox(height: 10),
                      HomeRowWidget(
                        asset: 'cake',
                        persian: 'کیک ها',
                        english: 'Cakes',
                        color: mainFontColor,
                        categoryId: '19',
                      ),
                      SizedBox(height: 10),
                      HomeRowWidget(
                        asset: 'cookie',
                        persian: 'شیرینی ها',
                        english: 'Pastries',
                        color: Color(0XFFD5A150),
                        categoryId: '14',
                      ),
                      // SizedBox(height: 10),
                      // HomeRowWidget(
                      //   asset: 'chocolate',
                      //   persian: 'کافه',
                      //   english: 'Cafe',
                      //   color: Color(0XFFE8594A),
                      //   categoryId: '',
                      // ),
                      SizedBox(height: 10),
                      HomeRowWidget(
                        asset: 'gift-box',
                        persian: 'لوازم تولد',
                        english: 'Birthday',
                        color: Color(0XFF32CAD5),
                        categoryId: '23',
                      ),
                      SizedBox(height: 10),
                      HomeRowWidget(
                        asset: 'donut (2)',
                        persian: 'نان',
                        english: 'Bread',
                        color: Color(0XFF59413E),
                        categoryId: '22',
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class HomeRowWidget extends StatelessWidget {
  final String? asset;
  final String? persian;
  final String? english;
  final Color? color;
  final String? categoryId;

  const HomeRowWidget({
    Key? key,
    @required this.asset,
    @required this.persian,
    @required this.english,
    @required this.color,
    @required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (categoryId! != '0')
          Navigator.of(context).pushNamed(
            Routes.category,
            arguments: categoryId,
          );
        else
          Navigator.of(context).pushNamed(
            Routes.productList,
            arguments: CategoryModel(
              id: '0',
              name: 'محصولات آماده ی ارسال',
              eName: 'Instant delivery',
              hasChild: false,
              parentId: '',
            ),
          );
      },
      child: Container(
        color: color!.withOpacity(.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FlutterIcons.angle_left,
                size: 40,
                color: color,
              ),
              Spacer(),
              Container(
                // color: Colors.red,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        persian!,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        english!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Container(
                width: 55,
                height: 55,
                // color: Colors.red,
                child: SvgPicture.asset(
                  'assets/Icons/$asset.svg',
                  // width: 77,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
