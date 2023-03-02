import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/card_navigator.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../Models/category.dart';
import '../Providers/category.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryProvider>(
      create: (ctx) => CategoryProvider(
          ModalRoute.of(context)!.settings.arguments as String),
      child: CategoryScreenTile(),
    );
  }
}

class CategoryScreenTile extends StatefulWidget {
  const CategoryScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryScreenTileState createState() => _CategoryScreenTileState();
}

class _CategoryScreenTileState extends State<CategoryScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CategoryProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
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
                            asset: provider.asset,
                            persian: provider.pHeader,
                            english: provider.eHeader,
                          ),
                        ),
                        SizedBox(height: 20),
                        provider.categoryId == '19'
                            ? CakeRowWidget()
                            : Container(),
                        SizedBox(height: 10),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, ind) => CategoryRowWidget(
                            category: provider.categories[ind],
                          ),
                          separatorBuilder: (ctx, ind) => SizedBox(height: 10),
                          itemCount: provider.categories.length,
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

class CakeRowWidget extends StatelessWidget {
  // final String? asset;
  // final String? persian;
  // final String? english;
  // final Color? color;

  const CakeRowWidget({
    Key? key,
    // @required this.asset,
    // @required this.persian,
    // @required this.english,
    // @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
            AppSession.token != '' ? Routes.specialCake : Routes.signIn);
      },
      child: Container(
        color: mainFontColor.withOpacity(.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FlutterIcons.plus,
                size: 40,
                color: mainFontColor,
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
                        'کیک های سفارشی و خاص',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Special Cakes',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 16,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 55,
                height: 55,
                // color: Colors.red,
                child: SvgPicture.asset(
                  'assets/Icons/birthday-cake.svg',
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

class CategoryRowWidget extends StatelessWidget {
  final CategoryModel? category;
  // final Color? color;
  // final String? route;

  const CategoryRowWidget({
    Key? key,
    @required this.category,
    // @required this.color,
    // @required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (category!.hasChild!) {
          Navigator.of(context)
              .pushNamed(Routes.category, arguments: category!.id!);
        } else
          Navigator.of(context)
              .pushNamed(Routes.productList, arguments: category);
      },
      child: Container(
        color: mainFontColor.withOpacity(.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FlutterIcons.angle_left,
                size: 40,
                color: mainFontColor,
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
                        category!.name!,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        category!.eName!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: mainFontColor,
                          fontSize: 12,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}
