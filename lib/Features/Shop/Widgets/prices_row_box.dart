import 'package:flutter/material.dart';

class PricesRowBox extends StatelessWidget {
  final String? label, price;
  final Color? color;
  const PricesRowBox({
    Key? key,
    @required this.label,
    @required this.price,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        border: Border(
          top: BorderSide(color: color!),
          bottom: BorderSide(color: color!),
        ),
        color: Color(0XFF32CAD5).withOpacity(.15),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  price!,
                  // textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontFamily: 'pacifico',
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
              ),
              // SizedBox(height: 5),
              Container(
                child: Text(
                  'تومان',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            child: Text(
              label!,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
