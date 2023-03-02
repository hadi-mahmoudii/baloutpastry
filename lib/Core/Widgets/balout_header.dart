import 'package:flutter/material.dart';

import '../Config/app_session.dart';

class BaloutHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cons.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '''تمام حقوق این برنامه متعلق به
مجموعه ی بلوط می باشد''',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 14,
                        fontFamily: 'iranyekanlight',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'All rights reserved',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: mainFontColor,
                        fontSize: 14,
                        fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 72,
              height: 82,
              child: Image.asset(
                'assets/Images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
