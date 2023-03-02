import '../../../Core/Widgets/date_picker.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/card_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../../Core/Widgets/simple_header.dart';
import '../../Product/Screens/special_cake.dart';
import '../Providers/profile.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (ctx) => ProfileProvider(),
      child: ProfileScreenTile(),
    );
  }
}

class ProfileScreenTile extends StatefulWidget {
  const ProfileScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenTileState createState() => _ProfileScreenTileState();
}

class _ProfileScreenTileState extends State<ProfileScreenTile> {
  @override
  initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProfileProvider>(context, listen: false)
          .getDatas(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
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
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        if (provider.scrollController.position.pixels >
                                provider.scrollController.position
                                        .maxScrollExtent -
                                    30 &&
                            provider.isLoadingMore) {}
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          provider.getDatas(context, resetPage: true),
                      child: ListView(
                        controller: provider.scrollController,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: SimpleHeader(
                              asset: 'pencil',
                              persian: 'ویرایش حساب کاربری',
                              english: 'Personal info editing',
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: InputBox(
                                  icon: FlutterIcons.user,
                                  label: 'نام خانوادگی',
                                  controller: provider.familyCtrl,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: InputBox(
                                  icon: FlutterIcons.user,
                                  label: 'نام',
                                  controller: provider.nameCtrl,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          InputBox(
                            icon: FlutterIcons.user,
                            label: 'English Name',
                            controller: provider.eNameCtrl,
                            textDirection: TextDirection.ltr,
                          ),
                          SizedBox(height: 20),
                          InputBox(
                            icon: FlutterIcons.user,
                            label: 'کدملی',
                            controller: provider.nationCodeCtrl,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: DatePicker(
                                  icon: FlutterIcons.calendar,
                                  label: 'تاریخ ازدواج',
                                  controller: provider.marrigeCtrl,
                                  dateLabelCtrl: provider.marrigeLabelCtrl,
                                  color: mainFontColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: DatePicker(
                                  icon: FlutterIcons.calendar,
                                  label: 'تاریخ تولد',
                                  color: mainFontColor,
                                  dateLabelCtrl: provider.birthdayLabelCtrl,
                                  controller: provider.birthdayCtrl,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Divider(),
                          SizedBox(height: 10),
                          SubmitButton(
                            label: 'ذخیره ی اطلاعات حساب کاربری',
                            function: () {
                              provider.updateData(context);
                            },
                          ),
                          SizedBox(height: 50),
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
