import '../../../Core/Widgets/simple_header.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Models/option_model.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/static_bottom_selector.dart';
import '../Providers/add_to_card.dart';

class AddToCardWidget extends StatelessWidget {
  final String? productId;

  const AddToCardWidget({Key? key, @required this.productId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddToCardProvider>(
      create: (ctx) => AddToCardProvider(
        productId!,
        ctx,
      ),
      child: AddToCardTile(),
    );
  }
}

class AddToCardTile extends StatefulWidget {
  const AddToCardTile({
    Key? key,
  }) : super(key: key);

  @override
  _AddToCardTileState createState() => _AddToCardTileState();
}

class _AddToCardTileState extends State<AddToCardTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AddToCardProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddToCardProvider>(
      builder: (ctx, provider, _) => SafeArea(
        child: provider.isLoading
            ? Center(
                child: LoadingWidget(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  // controller: provider.scrollController,
                  child: Form(
                    key: provider.formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.close,
                                    size: 45,
                                    color: mainFontColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SimpleHeader(
                                  asset: 'shopping-bag (1)',
                                  persian: provider.product!.name,
                                  english: provider.product!.eName,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15),
                          //in some products user can select between two options
                          provider.product!.avarageW == ''
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      provider.product!.isNumbericType!
                                          ? 'عدد'
                                          : 'کیلو گرم',
                                      style: TextStyle(
                                          color: mainFontColor,
                                          fontSize: 14,
                                          fontFamily: 'iranyekanlight'),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: InputBox(
                                        icon: FlutterIcons.number,
                                        label: provider.product!.isNumbericType!
                                            ? 'چه تعداد؟'
                                            : 'چه مقدار؟',
                                        controller: provider.valueCtrl,
                                        minLines: 1,
                                        maxLines: 1,
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'این فیلد نیاز است';
                                          }
                                          if (provider
                                              .product!.minWeight!.isNotEmpty) {
                                            final minWeight = double.parse(
                                                provider.product!.minWeight!);
                                            if (double.parse(value) <
                                                minWeight) {
                                              return 'مقداروارد شده صحیح نمی باشد';
                                            }
                                          }
                                          if (provider
                                              .product!.maxWeight!.isNotEmpty) {
                                            final minWeight = double.parse(
                                                provider.product!.maxWeight!);
                                            if (double.parse(value) >
                                                minWeight) {
                                              return 'مقداروارد شده صحیح نمی باشد';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DeliveryTypeSelectorBox(
                                              pTitle: 'مقدار براساس تعداد',
                                              func: () => provider
                                                  .changeNumericSelected(true),
                                              status: provider.numericSelected,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: DeliveryTypeSelectorBox(
                                              pTitle: 'مقدار براساس کیلو',
                                              func: () => provider
                                                  .changeNumericSelected(false),
                                              status: !provider.numericSelected,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    !provider.numericSelected
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'کیلو گرم',
                                                style: TextStyle(
                                                    color: mainFontColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'iranyekanlight'),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: InputBox(
                                                  icon: FlutterIcons.number,
                                                  label: 'چه مقدار ؟',
                                                  controller:
                                                      provider.valueCtrl,
                                                  minLines: 1,
                                                  maxLines: 1,
                                                  textType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'این فیلد نیاز است';
                                                    }
                                                    if (provider
                                                        .product!
                                                        .minWeight!
                                                        .isNotEmpty) {
                                                      final minWeight =
                                                          double.parse(provider
                                                              .product!
                                                              .minWeight!);
                                                      if (double.parse(value) <
                                                          minWeight) {
                                                        return 'مقداروارد شده صحیح نمی باشد';
                                                      }
                                                    }
                                                    if (provider
                                                        .product!
                                                        .maxWeight!
                                                        .isNotEmpty) {
                                                      final minWeight =
                                                          double.parse(provider
                                                              .product!
                                                              .maxWeight!);
                                                      if (double.parse(value) >
                                                          minWeight) {
                                                        return 'مقداروارد شده صحیح نمی باشد';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'عدد',
                                                style: TextStyle(
                                                    color: mainFontColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'iranyekanlight'),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: InputBox(
                                                  icon: FlutterIcons.number,
                                                  label: 'چه تعداد ؟',
                                                  controller:
                                                      provider.numValueCtrl,
                                                  minLines: 1,
                                                  maxLines: 1,
                                                  textType:
                                                      TextInputType.number,
                                                ),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                          provider.product!.maxWeight!.isEmpty &&
                                  provider.product!.minWeight!.isEmpty
                              ? SizedBox(height: 10)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      provider.product!.maxWeight!.isNotEmpty
                                          ? Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: MinMaxValueBox(
                                                  value: provider
                                                      .product!.maxWeight!,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      provider.product!.minWeight!.isNotEmpty
                                          ? Expanded(
                                              child: MinMaxValueBox(
                                                value: provider
                                                    .product!.minWeight!,
                                                isMin: true,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, ind) {
                              List<OptionModel> options = [];
                              provider.product!.options![ind].options!
                                  .forEach((element) {
                                options.add(OptionModel(
                                    id: element.id,
                                    title:
                                        '${element.name} - ${element.price} تومان'));
                              });
                              return StaticBottomSelector(
                                color: mainFontColor,
                                icon: Icons.format_align_right_sharp,
                                label: provider.product!.options![ind].name,
                                controller: provider.optionCtrls[ind],
                                datas: options,
                              );
                            },
                            separatorBuilder: (ctx, ind) => SizedBox(
                              height: 10,
                            ),
                            itemCount: provider.product!.options!.length,
                          ),
                          provider.product!.letTextOnItem!
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: InputBox(
                                    icon: Icons.format_align_right_outlined,
                                    label: 'متن روی کیک',
                                    controller: provider.textOnItemCtrl,
                                    minLines: 3,
                                    maxLines: 5,
                                  ),
                                )
                              : Container(),
                          provider.product!.letTextAroundItem!
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: InputBox(
                                    icon: Icons.format_align_right_outlined,
                                    label: 'متن دور کیک',
                                    controller: provider.textAroundItemCtrl,
                                    minLines: 3,
                                    maxLines: 5,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          // Spacer(),
                          Divider(),
                          ProductShopBox(provider: provider),
                          SizedBox(height: 20),
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

class MinMaxValueBox extends StatelessWidget {
  const MinMaxValueBox({
    Key? key,
    required this.value,
    this.isMin = false,
    this.isNumeric = false,
  }) : super(key: key);

  final String value;
  final bool isMin;
  final bool isNumeric;

  @override
  Widget build(BuildContext context) {
    String label = '';
    if (isMin) {
      label += 'حداقل: $value ';
    } else {
      label += 'حداکثر: $value ';
    }
    if (isNumeric) {
      label += 'عدد';
    } else {
      label += 'کیلوگرم';
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:
            !isMin ? Colors.grey.withOpacity(.2) : Colors.grey.withOpacity(.12),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'iranyekanlight',
                color: Colors.black54,
              ),
            ),
          ),
          Icon(
            isMin
                ? Icons.keyboard_arrow_down_rounded
                : Icons.keyboard_arrow_up_rounded,
            color: Colors.black54,
          )
        ],
      ),
    );
  }
}

class ProductShopBox extends StatelessWidget {
  final AddToCardProvider? provider;
  const ProductShopBox({
    Key? key,
    @required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: provider!.product!.available! ? 1.0 : .2,
            child: InkWell(
              onTap: () {
                provider!.product!.available!
                    ? provider!.addToCart()
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
              provider!.product!.discount! != '' &&
                      provider!.product!.discount! != '0'
                  ? Text(
                      provider!.product!.discount!,
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
                provider!.product!.isNumbericType!
                    ? provider!.product!.priceN!
                    : provider!.product!.priceK!,
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
                provider!.product!.isNumbericType!
                    ? "تومان - هرعدد"
                    : 'تومان - کیلو',
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

class DeliveryTypeSelectorBox extends StatelessWidget {
  final String? pTitle;
  final Function? func;
  final bool? status;

  const DeliveryTypeSelectorBox({
    Key? key,
    @required this.pTitle,
    @required this.func,
    @required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => func!(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: status!
              ? mainFontColor.withOpacity(.2)
              : mainFontColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: status!
                ? mainFontColor.withOpacity(.9)
                : mainFontColor.withOpacity(.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                pTitle!,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: status!
                      ? mainFontColor.withOpacity(.9)
                      : mainFontColor.withOpacity(.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
