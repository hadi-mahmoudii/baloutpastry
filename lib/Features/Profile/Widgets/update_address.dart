import '../../Shop/Models/submit_card_datas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/static_bottom_selector.dart';
import '../../Product/Screens/special_cake.dart';
import '../Providers/update_address.dart';

class UpdateAddressWidget extends StatelessWidget {
  final AddressRowModel? address;

  const UpdateAddressWidget({Key? key,@required this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateAddressProvider>(
      create: (ctx) => UpdateAddressProvider(ctx, address!),
      child: UpdateAddressTile(),
    );
  }
}

class UpdateAddressTile extends StatefulWidget {
  const UpdateAddressTile({
    Key? key,
  }) : super(key: key);

  @override
  _UpdateAddressTileState createState() => _UpdateAddressTileState();
}

class _UpdateAddressTileState extends State<UpdateAddressTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<UpdateAddressProvider>(context, listen: false)
          .getCities(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateAddressProvider>(
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
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Form(
                      key: provider.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Icon(
                          //     Icons.close,
                          //     size: 25,
                          //     color: mainFontColor,
                          //   ),
                          // ),
                          SizedBox(height: 15),
                          StaticBottomSelector(
                            color: mainFontColor,
                            icon: Icons.location_city,
                            label: 'شهر را انتخاب کنید',
                            controller: provider.cityCtrl,
                            datas: provider.cityDatas,
                            function: () {
                              // print(provider.cityDatas
                              //     .firstWhere((element) =>
                              //         element.title == provider.cityCtrl.text)
                              //     .id);
                              provider.getRegions(context);
                            },
                            validator: (String value) {
                              if (value.isEmpty)
                                return 'پرکردن این فیلد اجباری است';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          provider.regionsIsLoading
                              ? LoadingWidget()
                              : StaticBottomSelector(
                                  color: mainFontColor,
                                  icon: FlutterIcons.map,
                                  label: 'منطقه را انتخاب کنید',
                                  controller: provider.regionCtrl,
                                  datas: provider.regionDatas,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'پرکردن این فیلد اجباری است';
                                    return null;
                                  },
                                ),
                          SizedBox(height: 10),
                          InputBox(
                            icon: FlutterIcons.location,
                            label: 'آدرس را بطور کامل وارد کنید',
                            controller: provider.addressCtrl,
                            minLines: 3,
                            maxLines: 5,
                            validator: (String value) {
                              if (value.isEmpty)
                                return 'پرکردن این فیلد اجباری است';
                              return null;
                            },
                          ),
                          // SizedBox(height: 10),
                          // InputBox(
                          //   icon: FlutterIcons.phone,
                          //   label: 'شماره تماس',
                          //   controller: provider.phoneCtrl,
                          //   validator: (String value) {
                          //     if (value.isEmpty)
                          //       return 'پرکردن این فیلد اجباری است';
                          //     return null;
                          //   },
                          // ),
                          SizedBox(height: 30),
                          SubmitButton(
                              label: 'بروزرسانی آدرس',
                              function: () => provider.updateAddress(),
                              icon: Icons.add),
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
