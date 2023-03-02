import '../../Profile/Widgets/update_address.dart';
import '../Models/submit_card_datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/circle_submit_button.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../../Core/Widgets/static_bottom_selector.dart';
import '../../Product/Screens/special_cake.dart';
import '../../Profile/Widgets/add_address.dart';
import '../Providers/select_address.dart';

class SelectAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectAddressProvider>(
      create: (ctx) => SelectAddressProvider(),
      child: SelectAddressScreenTile(),
    );
  }
}

class SelectAddressScreenTile extends StatefulWidget {
  const SelectAddressScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SelectAddressScreenTileState createState() =>
      _SelectAddressScreenTileState();
}

class _SelectAddressScreenTileState extends State<SelectAddressScreenTile>
    with WidgetsBindingObserver {
  @override
  initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    Future.microtask(
      () => Provider.of<SelectAddressProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectAddressProvider>(
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
              : RefreshIndicator(
                  onRefresh: () async =>
                      provider.getDatas(context, resetPage: true),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: DeliveryTypeSelectorBox(
                                pTitle: 'ارسال درب منزل',
                                eTitle: 'Deliver to my place',
                                func: () =>
                                    provider.changeLetSelectAddress(true),
                                status: provider.letSelectAddress,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: DeliveryTypeSelectorBox(
                                pTitle: 'دریافت حضوری',
                                eTitle: 'Self pickup',
                                func: () =>
                                    provider.changeLetSelectAddress(false),
                                status: !provider.letSelectAddress,
                              ),
                            ),
                          ],
                        ),
                      ),
                      provider.letSelectAddress
                          ? ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(child: AddressHeader()),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) =>
                                        AddressSelectorRow(
                                      address: provider.datas.addresses![ind],
                                      selectFunc: () =>
                                          provider.changeSelectedAddress(ind),
                                      deleteFunc: () => provider.deleteAddress(
                                          context,
                                          provider.datas.addresses![ind].id!),
                                      currentStatus: provider.selectedAddress,
                                      orgStatus: ind,
                                    ),
                                    separatorBuilder: (ctx, ind) =>
                                        SizedBox(height: 10),
                                    itemCount: provider.datas.addresses!.length,
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(child: BranchHeader()),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, ind) =>
                                        BranchSelectorRow(
                                      branch: provider.branches[ind],
                                      selectFunc: () =>
                                          provider.changeSelectedBranch(ind),
                                      currentStatus: provider.selectedBranch,
                                      orgStatus: ind,
                                    ),
                                    separatorBuilder: (ctx, ind) =>
                                        SizedBox(height: 10),
                                    itemCount: provider.branches.length,
                                  ),
                                ),
                              ],
                            ),
                      Divider(),
                      SizedBox(height: 30),
                      Center(
                        child: SimpleHeader(
                          asset: 'clock (1)',
                          persian: 'زمان تحویل',
                          english: 'Delivery time',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StaticBottomSelector(
                          color: mainFontColor,
                          icon: Icons.format_align_right_sharp,
                          label: 'روز تحویل',
                          controller: provider.dayCtrl,
                          datas: provider.days,
                          function: () {
                            provider.changeSelectedDayId();
                          },
                        ),
                      ),
                      !provider.letSelectHour
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, right: 20, left: 20),
                              child: StaticBottomSelector(
                                color: mainFontColor,
                                icon: Icons.format_align_right_sharp,
                                label: 'ساعت تحویل',
                                controller: provider.hourCtrl,
                                datas: provider.hours,
                              ),
                            ),
                      Divider(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     CircleSubmitButton(
                      //       func: () {
                      //         Navigator.of(context).pushNamed(Routes.payment);
                      //       },
                      //       icon: FlutterIcons.angle_left,
                      //     ),
                      //     Spacer(),
                      //   ],
                      // ),
                      SizedBox(height: 40),
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
                            !provider.isCheckingDiscount
                                ? CircleSubmitButton(
                                    func: () {
                                      provider.checkDiscountInUI();
                                    },
                                    icon: FlutterIcons.check_1,
                                    color: Color(0Xff32CAD5),
                                  )
                                : LoadingWidget(
                                    mainFontColor: Color(0Xff32CAD5),
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
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Text(
                          provider.offValue != ''
                              ? provider.offValue
                              : provider.discountError,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF32CAD5),
                            fontSize: 14,
                          ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                provider.depositPayment,
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
                      SizedBox(height: 15),
                      provider.currentShippingCost != '0' &&
                              provider.letSelectAddress
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      provider.currentShippingCost,
                                      // textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: mainFontColor,
                                        fontSize: 25,
                                        fontFamily: 'pacifico',
                                        fontWeight: FontWeight.bold,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      'هزینه ارسال',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: mainFontColor,
                                        fontSize: 10,
                                        fontFamily: 'iranyekanlight',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 25),
                        child: SubmitButton(
                          label: 'تاییدنهایی سفارش و پرداخت مبلغ',
                          function: () {
                            provider.sendGateway(
                                context, WidgetsBinding.instance!);
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class DeliveryTypeSelectorBox extends StatelessWidget {
  final String? pTitle;
  final String? eTitle;
  final Function? func;
  final bool? status;

  const DeliveryTypeSelectorBox({
    Key? key,
    @required this.pTitle,
    @required this.eTitle,
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
            SizedBox(height: 5),
            Container(
              alignment: Alignment.center,
              child: Text(
                eTitle!,
                style: TextStyle(
                  color: status!
                      ? mainFontColor.withOpacity(.9)
                      : mainFontColor.withOpacity(.3),
                  fontFamily: 'pacifico',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressSelectorRow extends StatelessWidget {
  final AddressRowModel? address;
  final Function? selectFunc;
  final Function? deleteFunc;

  final int? currentStatus;
  final int? orgStatus;

  const AddressSelectorRow({
    Key? key,
    @required this.address,
    @required this.selectFunc,
    @required this.deleteFunc,
    @required this.currentStatus,
    @required this.orgStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleSubmitButton(
          func: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: Text(
                'آیا برای حذف آدرس اطمینان دارید؟',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: mainFontColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => deleteFunc!(),
                  child: Text(
                    'بله',
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'خیر',
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
              ],
            ),
          ),
          icon: Icons.delete,
        ),
        SizedBox(width: 5),
        CircleSubmitButton(
            func: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  builder: (ctx) => UpdateAddressWidget(
                    address: address,
                  ),
                ),
            icon: Icons.edit),
        SizedBox(width: 5),
        Expanded(
          child: InkWell(
            onTap: () => selectFunc!(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: currentStatus! == orgStatus!
                    ? mainFontColor.withOpacity(.2)
                    : mainFontColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: currentStatus! == orgStatus!
                      ? mainFontColor.withOpacity(.9)
                      : mainFontColor.withOpacity(.3),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  address!.address!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: currentStatus! == orgStatus!
                        ? mainFontColor.withOpacity(.9)
                        : mainFontColor.withOpacity(.3),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AddressHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainFontColor,
              ),
              child: IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  builder: (ctx) => AddAddressWidget(),
                ),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Spacer(),
            Container(
              // color: Colors.red,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cons.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'آدرس ارسال',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Delivery location',
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
              width: 77,
              height: 77,
              // color: Colors.red,
              child: SvgPicture.asset(
                'assets/Icons/location.svg',
                // width: 77,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BranchSelectorRow extends StatelessWidget {
  final BranchRowModel? branch;
  final Function? selectFunc;

  final int? currentStatus;
  final int? orgStatus;

  const BranchSelectorRow({
    Key? key,
    @required this.branch,
    @required this.selectFunc,
    @required this.currentStatus,
    @required this.orgStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => selectFunc!(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: currentStatus! == orgStatus!
                    ? mainFontColor.withOpacity(.2)
                    : mainFontColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: currentStatus! == orgStatus!
                      ? mainFontColor.withOpacity(.9)
                      : mainFontColor.withOpacity(.3),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  branch!.name!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: currentStatus! == orgStatus!
                        ? mainFontColor.withOpacity(.9)
                        : mainFontColor.withOpacity(.3),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class BranchHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cons.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'محل دریافت',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pickup Location',
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
              width: 77,
              height: 77,
              // color: Colors.red,
              child: SvgPicture.asset(
                'assets/Icons/location.svg',
                // width: 77,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
