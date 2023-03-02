import '../../../Core/Widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../Profile/Screens/dashboard.dart';
import '../Providers/signup.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpProvider>(
      create: (ctx) =>
          SignUpProvider(ModalRoute.of(context)!.settings.arguments as String),
      child: SignUpScreenTile(),
    );
  }
}

class SignUpScreenTile extends StatefulWidget {
  const SignUpScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenTileState createState() => _SignUpScreenTileState();
}

class _SignUpScreenTileState extends State<SignUpScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(
      builder: (ctx, provider, _) => SafeArea(
        child: Scaffold(
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    'assets/Images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          // appBar: PreferredSize(
          //   preferredSize: Size(double.infinity, 50),
          //   child: GlobalAppbar(
          //     icon: FlutterIcons.logout,
          //     function: () async {},
          //   ),
          // ),
          body: provider.isLoading
              ? Center(
                  child: LoadingWidget(),
                )
              : NotificationListener(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: ListView(
                      controller: provider.scrollController,
                      children: [
                        Image.asset(
                          'assets/Images/5.jpg',
                          width: MediaQuery.of(context).size.width,
                          height: 350,
                          fit: BoxFit.fitWidth,
                        ),
                        GlobalBackButton(
                          title: 'ورود',
                          color: Color(0XFFF9FBFA),
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'خوشحالیم که اینجا هستید',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: mainFontColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Glad to see you here',
                            style: TextStyle(
                              color: mainFontColor,
                              fontFamily: 'pacifico',
                            ),
                          ),
                        ),
                        !provider.codeSended
                            ? ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: InputBox(
                                      icon: Icons.person,
                                      label: 'نام',
                                      controller: provider.fNameCtrl,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: InputBox(
                                      icon: Icons.person,
                                      label: 'نام خانوادگی',
                                      controller: provider.lNameCtrl,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: InputBox(
                                      icon: Icons.phone,
                                      label: 'شماره همراه شما',
                                      controller: provider.phoneCtrl,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //   child: InputBox(
                                  //     icon: FlutterIcons.asterisk,
                                  //     label: 'کلمه عبور شما',
                                  //     controller: provider.passCtrl,
                                  //   ),
                                  // ),
                                  // SizedBox(height: 20),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //   child: InputBox(
                                  //     icon: FlutterIcons.asterisk,
                                  //     label: 'تکرار کلمه عبور شما',
                                  //     controller: provider.rePassCtrl,
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 30,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => provider.signUp(context),
                                          child: CircleAvatar(
                                            child: Icon(
                                              Icons.chevron_left_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            backgroundColor: Color(0XFF8D411C),
                                            radius: 25,
                                            // foregroundColor: Color(0XFF32CAD5),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DashbourdRowBox(
                                            label: 'حریم خصوصی',
                                            icon: FlutterIcons.shield,
                                            color: mainFontColor,
                                            fontColor: mainFontColor,
                                            route: Routes.privacy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: InputBox(
                                      icon: Icons.person,
                                      label: 'کد دریافتی',
                                      controller: provider.codeCtrl,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 30,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              provider.submitRegister(context),
                                          child: CircleAvatar(
                                            child: Icon(
                                              Icons.chevron_left_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            backgroundColor: Color(0XFF8D411C),
                                            radius: 25,
                                            // foregroundColor: Color(0XFF32CAD5),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 75),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
