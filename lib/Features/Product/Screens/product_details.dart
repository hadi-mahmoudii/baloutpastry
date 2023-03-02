import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../Shop/Widgets/add_to_card.dart';
import '../Models/comment.dart';
import '../Models/product.dart';
import '../Providers/product_details.dart';
import 'special_cake.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductDetailsProvider>(
      create: (ctx) => ProductDetailsProvider(
          (ModalRoute.of(context)!.settings.arguments as String)),
      child: ProductDetailsScreenTile(),
    );
  }
}

class ProductDetailsScreenTile extends StatefulWidget {
  const ProductDetailsScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailsScreenTileState createState() =>
      _ProductDetailsScreenTileState();
}

class _ProductDetailsScreenTileState extends State<ProductDetailsScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProductDetailsProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
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
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: RefreshIndicator(
                    onRefresh: () async => provider.getDatas(context),
                    child: ListView(
                      controller: provider.scrollController,
                      children: [
                        SizedBox(height: 20),
                        ProductHeaderImagesBox(
                          product: provider.product,
                        ),
                        ProductHeaderTextBox(
                          product: provider.product,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(color: mainFontColor),
                        ),
                        ProductShopBox(
                          product: provider.product,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(color: mainFontColor),
                        ),
                        ProductDetailsBox(
                          details: provider.product!,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: Divider(color: mainFontColor),
                        // ),
                        SizedBox(height: 30),
                        CommentHeaderWidget(),
                        provider.showComments
                            ? Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  height: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) => CommentBoxWidget(
                                        comment: provider.comments[ind]),
                                    separatorBuilder: (ctx, ind) =>
                                        SizedBox(width: 25),
                                    itemCount: provider.comments.length,
                                  ),
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    'برای مشاهده ی نظرات وارد شوید',
                                    style: TextStyle(fontSize: 14),
                                  ),
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

class CommentBoxWidget extends StatelessWidget {
  final CommentModel? comment;
  const CommentBoxWidget({
    Key? key,
    @required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 3 / 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: mainFontColor),
              color: Color(0xFFEEEEEE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: double.parse(comment!.rate!),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemSize: 10,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(height: 5),
                Text(
                  comment!.comment!,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12,
                    color: mainFontColor,
                    height: 1.25,
                    fontFamily: 'iranyekanlight',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            comment!.user!,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 13,
              color: mainFontColor,
            ),
          )
        ],
      ),
    );
  }
}

class CommentHeaderWidget extends StatelessWidget {
  const CommentHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (ctx, provider, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (AppSession.token == '')
                  Fluttertoast.showToast(msg: 'برای ثبت نظر وارد شوید');
                else
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    builder: (context) => Container(
                      padding: EdgeInsets.all(25),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: mainFontColor,
                                ),
                              ),
                            ),
                            SimpleHeader(
                              asset: 'comments',
                              persian: 'نظر شما برای ما مهم است',
                              english: 'Your opinion matter',
                            ),
                            SizedBox(height: 15),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // print(rating);
                                provider.rate = rating;
                              },
                            ),
                            Divider(),
                            InputBox(
                              // color: Colors.black,
                              icon: FlutterIcons.align_right,
                              label: 'نظرخودرا بطور کامل برای ما بنویسید',
                              controller: provider.reviewCtrl,
                              minLines: 3,
                              maxLines: 5,
                            ),
                            SizedBox(height: 25),
                            provider.isSendingReview
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: LoadingWidget(),
                                  )
                                : SubmitButton(
                                    label: 'ثبت نظر شما',
                                    function: () =>
                                        provider.sendComment(context),
                                  ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  );
              },
              child: Icon(
                FlutterIcons.plus,
                color: mainFontColor,
                size: 26,
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'نظرات شما',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: mainFontColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Comments',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: mainFontColor,
                      fontSize: 14,
                      fontFamily: 'pacifico',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 60,
              height: 60,
              // color: Colors.red,
              child: SvgPicture.asset(
                'assets/Icons/comments.svg',
                // width: 77,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsBox extends StatelessWidget {
  final ProductModel? details;
  const ProductDetailsBox({
    Key? key,
    @required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RatingBar.builder(
            initialRating: details!.rate!,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            ignoreGestures: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
            itemSize: 20,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // print(rating);
              // provider.rate = rating;
            },
          ),
          SizedBox(height: 10),
          Text(
            details!.description!,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: mainFontColor,
              fontSize: 12,
              fontFamily: 'iranyekanlight',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductShopBox extends StatelessWidget {
  final ProductModel? product;
  const ProductShopBox({
    Key? key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: product!.available! ? 1.0 : .2,
            child: InkWell(
              onTap: () {
                product!.available!
                    ? AppSession.token != ''
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            builder: (ctx) =>
                                AddToCardWidget(productId: product!.id!),
                          )
                        : Navigator.of(context).pushNamed(Routes.signIn)
                    : Fluttertoast.showToast(msg: 'موجود نمی باشد');
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainFontColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 30,
                      color: mainFontColor.withOpacity(.3),
                      offset: Offset(0, 15),
                      // spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              product!.discount! != '' && product!.discount! != '0'
                  ? Text(
                      product!.discount!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 19,
                        fontFamily: 'pacifico',
                        height: 1,
                        decoration: TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Container(),
              Text(
                product!.isNumbericType! ? product!.priceN! : product!.priceK!,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: mainFontColor,
                  fontFamily: 'pacifico',
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product!.isNumbericType! ? "تومان - هرعدد" : 'تومان - کیلو',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: mainFontColor,
                  fontSize: 13,
                  fontFamily: 'iranyekanlight',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ProductHeaderTextBox extends StatelessWidget {
  final ProductModel? product;
  const ProductHeaderTextBox({
    Key? key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                product!.id!,
                style: TextStyle(
                  color: mainFontColor,
                  fontSize: 27,
                  fontFamily: 'pacifico',
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'کدآیتم',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: mainFontColor,
                  fontSize: 8,
                  fontFamily: 'iranyekanlight',
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              product!.name!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: mainFontColor,
                fontSize: 24,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductHeaderImagesBox extends StatelessWidget {
  final ProductModel? product;
  const ProductHeaderImagesBox({
    Key? key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (ctx, cons) {
          final headerImageCons = cons.maxWidth * 2 / 3;
          final littleImageCons = headerImageCons / 3 - 5;
          // final horizentalPadding = cons.maxWidth / 25;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: headerImageCons,
                  maxHeight: headerImageCons,
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
              SizedBox(width: 7.5),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, ind) => ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: littleImageCons,
                      maxHeight: littleImageCons,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        product!.images![ind],
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Image.asset(
                          'assets/Images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (ctx, ind) => SizedBox(height: 7.5),
                  itemCount:
                      product!.images!.length < 4 ? product!.images!.length : 3,
                ),
              ),
              // Column(
              //   children: [
              //     ConstrainedBox(
              //       constraints: BoxConstraints(
              //         maxWidth: littleImageCons,
              //         maxHeight: littleImageCons,
              //       ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(5),
              //         child: Image.asset(
              //           'assets/Images/2.jpg',
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 7.5),
              //     ConstrainedBox(
              //       constraints: BoxConstraints(
              //         maxWidth: littleImageCons,
              //         maxHeight: littleImageCons,
              //       ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(5),
              //         child: Image.asset(
              //           'assets/Images/7.jpg',
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 7.5),
              //     ConstrainedBox(
              //       constraints: BoxConstraints(
              //         maxWidth: littleImageCons,
              //         maxHeight: littleImageCons,
              //       ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(5),
              //         child: Image.asset(
              //           'assets/Images/6.jpg',
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          );
        },
      ),
    );
  }
}
