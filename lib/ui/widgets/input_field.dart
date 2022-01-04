import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ui/size_config.dart';
import '../theme.dart';
import 'package:get/get.dart';
class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;

  final String hint;

  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TitleStyle,),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            height: 52,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      autofocus: false,
                      controller: controller,
                      readOnly: widget!=null?true:false,
                      style: subTitle,
                      cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                      decoration:  InputDecoration(
                        hintText: hint,
                        hintStyle: subTitle,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0
                          )
                        )
                      ),
                    )),
                widget??Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
