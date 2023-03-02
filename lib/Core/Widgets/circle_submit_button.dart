import 'package:flutter/material.dart';

import '../Config/app_session.dart';

class CircleSubmitButton extends StatelessWidget {
  final Function? func;
  final Color? color;
  final IconData? icon;
  const CircleSubmitButton({
    Key? key,
    @required this.func,
    @required this.icon,
    this.color = mainFontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => func!(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 30,
              color: color!.withOpacity(.3),
              offset: Offset(0, 15),
              // spreadRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Icon(
          icon,
          color: Colors.white,
          size: 27,
        ),
      ),
    );
  }
}
