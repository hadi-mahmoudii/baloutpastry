import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Config/app_session.dart';

class SimpleHeader extends StatelessWidget {
  final String? asset;
  final String? persian;
  final String? english;

  const SimpleHeader({
    Key? key,
    @required this.asset,
    @required this.persian,
    @required this.english,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // color: Colors.red,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cons.maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: cons.maxWidth - 90),
                        child: Text(
                          persian!,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: mainFontColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: cons.maxWidth - 90),
                        child: Text(
                          english!,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: mainFontColor,
                            fontSize: 16,
                            fontFamily: 'pacifico',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 77,
                height: 77,
                // color: Colors.red,
                child: SvgPicture.asset(
                  'assets/Icons/$asset.svg',
                  // width: 77,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
