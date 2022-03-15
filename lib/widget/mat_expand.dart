import 'package:medle/widget/anim/AnimSize.dart';
import 'package:flutter/material.dart';

class MatExpand extends StatefulWidget {
  double width;
  double height;
  Widget head;
  List<Widget> children;
  bool isCenter;
  Widget headOpen;
  double radius;

  MatExpand({
    this.width,
    this.height,
    this.head,
    this.children,
    this.isCenter,
    this.headOpen,
    this.radius
  });

  @override
  _MatExpandState createState() {
    return _MatExpandState();
  }
}

class _MatExpandState extends State<MatExpand> {
  bool open = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: widget.width,
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(widget.radius ?? 10),
            elevation: 5,
            child: InkWell(
              onTap: (){
                setState(() {
                  open = !open;
                });
              },
              child: widget.headOpen != null
                  ? Container(
                height: widget.height != null ? widget.height : 50,
                child: Center(
                  child: AnimatedCrossFade(
                    crossFadeState: open
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 400),
                    firstChild: widget.headOpen,
                    secondChild: widget.head,
                  ),
                ),
              ) : Container(
                child: widget.head,
                height: widget.height != null ? widget.height : 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: AnimSize(
                expand: !open,
                expand2: open,
                type: "expand",
                child: Column(
                  crossAxisAlignment: widget.isCenter != null
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: widget.children,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
