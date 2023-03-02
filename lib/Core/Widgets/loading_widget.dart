import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    Color mainFontColor = Colors.black,
  }) : _mainFontColor = mainFontColor, super(key: key);

  final Color _mainFontColor;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitCubeGrid(
          size: 30,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: _mainFontColor,
                // color: index.isEven ? _mainFontColor: _secondColor,
              ),
            );
          },
        ),
      );
  }
}
