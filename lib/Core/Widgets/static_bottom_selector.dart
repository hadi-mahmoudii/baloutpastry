import 'package:flutter/material.dart';

import '../Models/option_model.dart';
import 'empty.dart';
import 'input_box.dart';

class StaticBottomSelector extends StatefulWidget {
  final Color? color;
  final IconData? icon;
  final String? label;
  final Function? function;
  final Future<dynamic>? futureFunction;
  final TextEditingController? controller;
  final Function? validator;
  final bool enable;
  final List<OptionModel>? datas;
  final bool mustFill;

  const StaticBottomSelector({
    Key? key,
    @required this.color,
    @required this.icon,
    @required this.label,
    @required this.controller,
    @required this.datas,
    this.validator,
    this.function,
    this.futureFunction,
    this.enable = true,
    this.mustFill = false,
  }) : super(key: key);

  @override
  _StaticBottomSelectorState createState() => _StaticBottomSelectorState();
}

class _StaticBottomSelectorState extends State<StaticBottomSelector> {
  bool isTapped = false;
  List<OptionModel> datas = [];
  @override
  void initState() {
    if (widget.datas != null) datas = widget.datas!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputBox(
      // color: widget.color,
      icon: widget.icon,
      label: widget.label,
      controller: widget.controller,
      readOnly: true,
      mustFill: widget.mustFill,
      validator: widget.validator,
      onTapFunction: () async {
        await showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (mainCtx) => Container(
            padding: EdgeInsets.all(10),
            color: Colors.transparent,
            // constraints: BoxConstraints(maxHeight: AppSession.deviceHeigth / 2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(' '),
                    ),
                  ),
                  datas.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, ind) => Container(
                            child: InkWell(
                              onTap: () async {
                                widget.controller!.text = datas[ind].title!;
                                Navigator.of(mainCtx).pop();
                                if (widget.function != null) widget.function!();
                                if (widget.futureFunction != null)
                                  await widget.futureFunction;
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  datas[ind].title!,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      // color: AppSession.mainFontColor,
                                      // fontSize: 4 * AppSession.deviceBlockSize,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          itemCount: datas.length,
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: EmptyWidget(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
