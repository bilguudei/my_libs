import 'package:medle/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class C_empty extends StatelessWidget {
  String text;
  double width;
  Color color;

  C_empty({@required this.text, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15,),
          Image.asset("images/medle_new/ic_empty.png", width: isHorizontal(context) ? width ?? Get.width * 0.2 : width ?? Get.width * 0.4,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Text(text, style: TextStyle(fontSize: 12, color: color ?? color_black.withOpacity(0.8)),),
          )
        ],
      ),
    );
  }
}
