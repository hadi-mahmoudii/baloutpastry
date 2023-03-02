import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DatePicker extends StatefulWidget {
  final Color? color;
  final IconData? icon;
  final String? label;
  final Function? function;
  final Function? optionalFunction;
  final Function? validator;
  final TextEditingController? controller;
  final TextEditingController? dateLabelCtrl;
  final bool? enable;
  final bool? onlyDate;

  const DatePicker({
    Key? key,
    @required this.color,
    @required this.icon,
    @required this.label,
    @required this.controller,
    @required this.dateLabelCtrl,
    this.validator,
    this.function,
    this.optionalFunction,
    this.enable = true,
    this.onlyDate = false,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool isTapped = false;
  Function? validator;
  @override
  void initState() {
    //this use for set default validator
    if (widget.validator != null)
      validator = widget.validator;
    else
      validator = (value) {
        return null;
      };
    super.initState();
  }

  // final TextEditingController dateLabelCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            controller: widget.dateLabelCtrl,
            enabled: widget.enable,
            readOnly: true,
            onTap: () async {
              Jalali? picked = await showPersianDatePicker(
                context: context,
                initialDate: Jalali.now(),
                firstDate: Jalali(1300),
                lastDate: Jalali.now(),
              );
              if (picked == null) return;
              // TimeOfDay? timePicked = await showPersianTimePicker(
              //   context: context,
              //   initialTime: TimeOfDay.now(),
              // );
              // if (timePicked == null) return;
              // Jalali result = Jalali(
              //   picked.year,
              //   picked.month,
              //   picked.day,
              //   timePicked.hour,
              //   timePicked.minute,
              // );
              Gregorian gregorainDate = picked.toGregorian();
              // var label = picked.formatFullDate();
              // print(label);
              // print(picked.toDateTime());
              // String value = DateConvertor.dateToGregorian(picked);
              widget.controller!.text = DateTime(
                gregorainDate.year,
                gregorainDate.month,
                gregorainDate.day,
                // timePicked.hour,
                // timePicked.minute,
              ).toString();
              // print(widget.controller.text);
              // if (widget.onlyDate)
              //   widget.controller.text = widget.controller.text.split(' ')[0];
              widget.dateLabelCtrl!.text = picked.formatFullDate();
              try {
                widget.optionalFunction!();
              } catch (e) {}
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              isDense: true,
              // border: InputBorder.none,
              labelText: widget.label,
              labelStyle: TextStyle(
                fontSize: 10,
                color: isTapped ? widget.color : widget.color!.withOpacity(.5),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     color: widget.color!,
              //   ),
              //   borderRadius: BorderRadius.circular(15),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     color: widget.color!.withOpacity(.5),
              //   ),
              //   borderRadius: BorderRadius.circular(15),
              // ),
              // errorBorder: InputBorder.none,
              // disabledBorder: InputBorder.none,
              suffixIcon: InkWell(
                onTap: () {},
                child: Icon(
                  widget.icon,
                  color:
                      isTapped ? widget.color : widget.color!.withOpacity(.5),
                ),
              ),
            ),
            // validator: validator,
            cursorColor: widget.color,
            style: TextStyle(
              fontSize: 15,
              color: isTapped ? widget.color : widget.color!.withOpacity(.5),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            minLines: 1,
            maxLines: 3,
          ),
        ),
      ),
    );
  }
}
