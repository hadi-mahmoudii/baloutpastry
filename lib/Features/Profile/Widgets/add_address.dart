import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/static_bottom_selector.dart';
import '../../Product/Screens/special_cake.dart';
import '../Providers/add_address.dart';

class AddAddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddAddressProvider>(
      create: (ctx) => AddAddressProvider(ctx),
      child: AddAddressTile(),
    );
  }
}

class AddAddressTile extends StatefulWidget {
  const AddAddressTile({
    Key? key,
  }) : super(key: key);

  @override
  _AddAddressTileState createState() => _AddAddressTileState();
}

class _AddAddressTileState extends State<AddAddressTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AddAddressProvider>(context, listen: false)
          .getCities(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddAddressProvider>(
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
                            label: '?????? ???? ???????????? ????????',
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
                                return '???????????? ?????? ???????? ???????????? ??????';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          provider.regionsIsLoading
                              ? LoadingWidget()
                              : StaticBottomSelector(
                                  color: mainFontColor,
                                  icon: FlutterIcons.map,
                                  label: '?????????? ???? ???????????? ????????',
                                  controller: provider.regionCtrl,
                                  datas: provider.regionDatas,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return '???????????? ?????? ???????? ???????????? ??????';
                                    return null;
                                  },
                                ),
                          SizedBox(height: 10),
                          InputBox(
                            icon: FlutterIcons.location,
                            label: '???????? ???? ???????? ???????? ???????? ????????',
                            controller: provider.addressCtrl,
                            minLines: 3,
                            maxLines: 5,
                            validator: (String value) {
                              if (value.isEmpty)
                                return '???????????? ?????? ???????? ???????????? ??????';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          InputBox(
                            icon: FlutterIcons.phone,
                            label: '?????????? ????????',
                            controller: provider.phoneCtrl,
                            validator: (String value) {
                              if (value.isEmpty)
                                return '???????????? ?????? ???????? ???????????? ??????';
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
                          SubmitButton(
                              label: '?????? ????????',
                              function: () => provider.addAddress(),
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
