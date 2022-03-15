import 'package:esis/util/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridWidget extends StatelessWidget {

  int verticalCount;
  int horizontalCount;
  double height;
  IndexedWidgetBuilder itemBuilder;
  int count;
  EdgeInsets padding;
  List<Widget> children;
  ScrollPhysics physics;
  double spacing;

  GridWidget(
      {
        @required this.verticalCount,
        @required this.horizontalCount,
        @required this.height,
        this.itemBuilder,
        this.children,
        this.count,
        this.padding,
        this.physics,
        this.spacing = 12
      });

  @override
  Widget build(BuildContext context) {
    if(itemBuilder == null && children.length > 0)
      return GridView(
        children: children,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: spacing, crossAxisSpacing: spacing,
            crossAxisCount: isHorizontal(context) ? horizontalCount : verticalCount,
            childAspectRatio: isHorizontal(context) ? (Get.width / height / horizontalCount) : (Get.width / height / verticalCount)
        ),
        shrinkWrap: true,
        physics: physics ?? BouncingScrollPhysics(),
        padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      );
    if(itemBuilder != null)
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: spacing, crossAxisSpacing: spacing,
          crossAxisCount: isHorizontal(context) ? horizontalCount : verticalCount,
          childAspectRatio: isHorizontal(context) ? (Get.width / height / horizontalCount) : (Get.width / height / verticalCount)
        ),
        itemBuilder: itemBuilder,
        itemCount: count ?? 0,
        physics: physics ?? BouncingScrollPhysics(),
        padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        shrinkWrap: true,
      );
    return Container();
  }
}
