import '../../../Core/Config/app_session.dart';
import '../../../Core/Widgets/flutter_icons.dart';
import '../../../Core/Widgets/global_appbar.dart';
import 'package:flutter/material.dart';

import '../../../Core/Config/datas.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: GlobalAppbar(
            icon: FlutterIcons.logout,
            function: () async {},
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: ListView(
            children: [
              Text(
                privacyText,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: mainFontColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
