import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:futter_to_do_app/ui/style.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          height: 52,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8, left: 8, right: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Row(children: [
            Expanded(
                child: TextFormField(
              readOnly: widget == null ? false : true,
              autofocus: false,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              controller: controller,
              style: subTitleStyle,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subTitleStyle,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: context.theme.backgroundColor, width: 0)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: context.theme.backgroundColor, width: 0))),
            )),
            widget == null
                ? Container()
                : Container(
                    child: widget,
                  )
          ]),
        )
      ]),
    );
  }
}
