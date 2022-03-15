
// import 'package:medle/widget/complex/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

enum SHIMMER_TYPE { single, list, grid }

class C_load extends StatefulWidget {
  final SHIMMER_TYPE type;
  final double childWidth;
  final double childHeight;
  final bool loading;
  final String msg;
  final int gridCount;
  final Function onClick;
  final double padding;
  final int count;
  final double ratio;
  final bool expanded;
  Axis axis;
  double radius;

  C_load({
    @required this.type,
    @required this.loading,
    @required this.msg,
    this.gridCount,
    @required this.onClick,
    this.padding,
    this.count,
    this.ratio,
    this.expanded,
    this.childHeight,
    this.childWidth,
    this.axis,
    this.radius = 15.0,
  });

  @override
  _C_loadState createState() => _C_loadState();
}

class _C_loadState extends State<C_load> {
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 100,
    //   width:  Get.width * 0.9,
    //   child: Shimmer.fromColors(
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.red,
    //         borderRadius: BorderRadius.circular(30)
    //       ),
    //       height: 100,
    //       width:  Get.width * 0.9,
    //       child: Text("gg"),
    //     ),
    //     baseColor: colorPrimary.withOpacity(0.4),
    //     highlightColor: Colors.indigoAccent.withOpacity(0.4)
    //   ),
    // );
    return widget.loading
        ?
        widget.expanded != null && widget.expanded == true ?
        Expanded(
          child: SafeArea(
            child: child(),
          ),
        ) :
        SafeArea(
          child: child(),
        )
        : SafeArea(
          child: GestureDetector(
            onTap: widget.onClick,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  if(widget.msg.contains("Интернет холболт"))Image.asset(
                    'images/connection.png',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  SizedBox(height: 10,),
                  Text(widget.msg != null ? widget.msg : "Хүсэлт амжилтгүй.", style: TextStyle(fontSize: 13, color: Colors.black),),
                  Text("Дахин оролдох", style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  Icon(
                    Icons.refresh,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(height: 15,),
                ],
              ),
          ),
        );
  }

  Widget child() {
    Widget w = ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: widget.axis ?? Axis.vertical,
      itemBuilder: (c, i) => Padding(
        padding: EdgeInsets.only(bottom: 10, right: widget.axis != null && widget.axis == Axis.horizontal ? 12 : 0),
        child: SizedBox(
          width: widget.childWidth ?? Get.width * 0.9,
          height: widget.childHeight ?? 90,
          child: Shimmer.fromColors(
              baseColor: Color(0xff6c7a89).withOpacity(0.45),
              highlightColor: Color(0xfff2f1ef).withOpacity(0.7),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    color: Colors.white
                ),
              )
          ),
        ),
      ),
      itemCount: widget.count != null ? widget.count : 5,
      shrinkWrap: true,
      padding: EdgeInsets.all(widget.padding != null ? widget.padding : 20),
    );


    switch (widget.type) {
      case SHIMMER_TYPE.single:
        return SizedBox(
          width: widget.childWidth ?? Get.width * 0.9,
          height: widget.childHeight ?? 90,
          child: Shimmer.fromColors(
              baseColor: Color(0xff6c7a89).withOpacity(0.45),
              highlightColor: Color(0xfff2f1ef).withOpacity(0.7),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    color: Colors.white
                ),
              )
          ),
        );
      case SHIMMER_TYPE.list:
        Widget w1 = w;
        if(widget.axis == null || widget.axis != null && widget.axis == Axis.vertical){

        }else{
          w1 = SizedBox(
            width: Get.width,
            height: widget.childHeight ?? 90,
            child: w,
          );
        }
        return w1;
      case SHIMMER_TYPE.grid:
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.gridCount != null ? widget.gridCount : 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: widget.ratio != null ? widget.ratio : (widget.childWidth ?? Get.width * 0.8 / widget.childHeight ?? 90.0 / widget.gridCount ?? 2)),
          itemBuilder: (c, i) => SizedBox(
            width: widget.childWidth ?? Get.width * 0.3,
            height: widget.childHeight ?? 90.0,
            child: Shimmer.fromColors(
                baseColor: Color(0xff6c7a89).withOpacity(0.45),
                highlightColor: Color(0xfff2f1ef).withOpacity(0.7),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      color: Colors.white
                  ),
                )
            ),
          ),
          itemCount: widget.count != null ? widget.count : 9,
          shrinkWrap: true,
          padding: EdgeInsets.all(widget.padding != null ? widget.padding : 20),
        );
      default:
        return SizedBox(
          width: widget.childWidth ?? Get.width * 0.9,
          height: widget.childHeight ?? 90,
          child: Shimmer.fromColors(
              baseColor: Color(0xff6c7a89).withOpacity(0.45),
              highlightColor: Color(0xfff2f1ef).withOpacity(0.7),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    color: Colors.white
                ),
              )
          ),
        );
    }
  }
}
