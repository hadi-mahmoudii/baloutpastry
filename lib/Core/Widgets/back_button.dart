import 'package:flutter/material.dart';

import '../Config/app_session.dart';

class GlobalBackButton extends StatelessWidget {
  const GlobalBackButton({
    Key? key,
    required this.title,
    this.color = const Color(0XFFE8E8E8),
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: mainFontColor),
            bottom: BorderSide(color: mainFontColor),
          ),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(color: mainFontColor),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.chevron_right,
              color: mainFontColor,
              size: 20,
            ),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
