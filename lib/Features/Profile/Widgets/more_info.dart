import 'package:baloutpastry/Core/Config/app_session.dart';
import 'package:flutter/material.dart';

class MoreInfoBox extends StatelessWidget {
  const MoreInfoBox({
    Key? key,
    required this.title,
    required this.function,
  }) : super(key: key);

  final String title;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        // width: 150,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: mainFontColor,
              width: .4,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 15,
              color: mainFontColor,
              fontFamily: 'iranyekanlight',
            ),
          ),
        ),
      ),
    );
  }
}
