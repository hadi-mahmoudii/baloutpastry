import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/app_session.dart';
import '../Config/routes.dart';
import 'flutter_icons.dart';

class GlobalAppbar extends StatelessWidget {
  final IconData? icon;
  final Function? function;
  const GlobalAppbar({
    Key? key,
    this.icon,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppSession.token != ''
          ? IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(
                FlutterIcons.logout,
                color: mainFontColor,
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.signIn);
              },
              icon: Icon(
                FlutterIcons.login,
                color: mainFontColor,
              ),
            ),
      backgroundColor: Color(0xFFE8E8E8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              'assets/Images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Opacity(
              opacity: AppSession.token != '' ? 1.0 : 0,
              child: Icon(
                FlutterIcons.user,
                color: mainFontColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.dashboard);
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
      elevation: 1,
    );
  }
}

Future logout(BuildContext context, {bool sendRequest = false}) async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(
        'آیا برای خروج اطمینان دارید؟',
        textDirection: TextDirection.rtl,
        style: TextStyle(color: mainFontColor),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            AppSession.token = '';
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('userData');
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(Routes.home);
          },
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
  );
  // if (sendRequest) {
  // await http.post(
  //   Urls.logout,
  //   headers: {
  //     'X-Requested-With': 'XMLHttpRequest',
  //     'Authorization': AppSession.token,
  //     'device-id': AppSession.deviceId,
  //   },
  // );
  // }
  // notifyListeners();
  // return true;
}
