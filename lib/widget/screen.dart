import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenWidget extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final List<Widget> children;
  final CrossAxisAlignment alignment;
  final ScrollController scrollController;

  ScreenWidget({
    @required this.children,
    this.height,
    this.width,
    this.padding,
    this.alignment,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (c, o) => Container(
        width: width != null ? width : Get.width,
        height: height != null ? height : Get.height,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          padding: padding != null ? padding : EdgeInsets.only(
              top: 20,
              bottom: 30),
          child: Column(
            crossAxisAlignment:
                alignment != null ? alignment : CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
