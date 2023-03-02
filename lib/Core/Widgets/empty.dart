import '../Config/app_session.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size sizeDatas = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: sizeDatas.height / 5),
        width: sizeDatas.width / 2,
        child: Column(
          children: [
            Container(
              width: sizeDatas.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainFontColor,
                    ),
                    child: Text(' '),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainFontColor,
                    ),
                    child: Text(' '),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            RotationTransition(
              turns: new AlwaysStoppedAnimation(-10 / 360),
              child: Container(
                width: sizeDatas.width / 5,
                child: Divider(
                  color: mainFontColor,
                  thickness: 4,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'متــــــــــاسفیم',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: mainFontColor,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            Text(
              'هیچ آیـــــــــتمی برای\nنمایش وجـــــود ندارد.',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: mainFontColor,
                fontSize: 24,
                fontFamily: 'iranyekanregular',
              ),
            ),
            Divider(
              color: mainFontColor,
            ),
            Text(
              'NOTHING TO SHOW',
              style: TextStyle(
                color: mainFontColor.withOpacity(.5),
                fontFamily: 'pacifico',
                fontSize: 13,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
