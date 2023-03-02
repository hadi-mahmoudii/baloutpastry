import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Config/app_session.dart';
import '../Providers/search.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool isTapped = false;
  String lastInput =
      ''; // this use cuz of a bug in text feild that when keyboard close state will refresh

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (ctx, provider, _) {
      lastInput = provider.searchCtrl.text;
      return Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: FocusScope(
            onFocusChange: (val) {
              setState(() {
                isTapped = val;
              });
            },
            child: TextFormField(
              controller: provider.searchCtrl,
              // onTap: widget.onTapFunction != null
              //     ? () async {
              //         widget.onTapFunction();
              //       }
              //     : () {},
              // validator: validator,
              // maxLength: widget.maxLength,
              onChanged: (value) {
                if (lastInput != value) {
                  // print(lastInput);
                  // print(value);
                  lastInput = value;
                  if (value.length < 2) {
                    // print('more datas need');
                    return;
                  } else {
                    provider.lockPage = false;
                    provider.getDatas(context, resetPage: true);
                  }
                }
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'کلمه یا عبارت موردنظر را وارد کنید',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color:
                      isTapped ? mainFontColor : mainFontColor.withOpacity(.5),
                ),
                prefixIcon: InkWell(
                  // onTap: widget.function ?? widget.function,
                  child: Icon(
                    Icons.search,
                    color: isTapped
                        ? mainFontColor
                        : mainFontColor.withOpacity(.5),
                  ),
                ),
              ),
              // cursorColor: widget.color,
              style: TextStyle(
                fontSize: 18,
                color: mainFontColor,
              ),
            ),
          ),
        ),
      );
    });
  }
}
