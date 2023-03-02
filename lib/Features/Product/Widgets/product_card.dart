import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../Shop/Widgets/add_to_card.dart';
import '../Models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductOverviewModel? product;
  const ProductCard({
    Key? key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) {
        final imageHeight = cons.maxHeight * 2 / 3;
        final horizentalPadding = cons.maxWidth / 33;
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.productDetails,
              arguments: product!.id,
            );
          },
          child: Card(
            elevation: 3,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      product!.image,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Image.asset(
                        'assets/Images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizentalPadding,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product!.id,
                            style: TextStyle(
                              color: mainFontColor,
                              fontSize: 16,
                              fontFamily: 'pacifico',
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'کدآیتم',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: mainFontColor,
                              fontSize: 5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          product!.name,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: mainFontColor,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizentalPadding,
                    vertical: 1,
                  ),
                  child: Divider(
                    color: mainFontColor,
                    height: 1,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizentalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: product!.available ? 1.0 : .2,
                        child: InkWell(
                          onTap: () {
                            product!.available
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
                                        builder: (ctx) => AddToCardWidget(
                                            productId: product!.id),
                                      )
                                    : Navigator.of(context)
                                        .pushNamed(Routes.signIn)
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
                            padding: EdgeInsets.all(
                              horizentalPadding,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          product!.discount != '' && product!.discount != '0'
                              ? Text(
                                  product!.discount,
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
                            product!.isNumbericType
                                ? product!.priceN
                                : product!.priceK,
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
                            product!.isNumbericType
                                ? "تومان - هرعدد"
                                : 'تومان - کیلو',
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
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
