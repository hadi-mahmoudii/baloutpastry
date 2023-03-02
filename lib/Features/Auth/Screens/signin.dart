import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../../../Core/Config/routes.dart';
import '../../../Core/Widgets/back_button.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/input_box.dart';
import '../../../Core/Widgets/loading_widget.dart';
import '../../Product/Screens/special_cake.dart';
import '../Providers/signin.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInProvider>(
      create: (ctx) => SignInProvider(),
      child: SignInScreenTile(),
    );
  }
}

class SignInScreenTile extends StatefulWidget {
  const SignInScreenTile({
    Key? key,
  }) : super(key: key);

  @override
  _SignInScreenTileState createState() => _SignInScreenTileState();
}

class _SignInScreenTileState extends State<SignInScreenTile> {
  @override
  initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<Test>(context, listen: false).getUserDatas(context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(
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
                  child: SingleChildScrollView(
                    controller: provider.scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/Images/4.jpg',
                          width: MediaQuery.of(context).size.width,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                        GlobalBackButton(
                          title: 'صفحه ی اصلی',
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'ورود به یه دنیای خوشمزه',
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
                            'Login to delicious world',
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
                                      icon: Icons.phone,
                                      label: 'شماره همراه شما',
                                      controller: provider.phoneCtrl,
                                      textType: TextInputType.phone,
                                    ),
                                  ),
                                  SizedBox(height: 10),
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
                                          onTap: () => provider.signIn(context),
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
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4),
                                          child: SubmitButton(
                                            label: 'ثبت نام',
                                            function: () =>
                                                Navigator.of(context).pushNamed(
                                              Routes.signUp,
                                              arguments:
                                                  provider.phoneCtrl.text,
                                            ),
                                            icon: Icons.add,
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
                                      icon: FlutterIcons.number,
                                      label: 'کد دریافتی',
                                      controller: provider.codeCtrl,
                                      textType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(height: 10),
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
                                              provider.submitLogin(context),
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
