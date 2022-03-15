import 'package:flutter/material.dart';

class AnimBlink extends StatefulWidget{
  final Widget child;
  final Duration duration;
  AnimBlink({this.child, this.duration});

  @override
  State<StatefulWidget> createState() {
    return Blink();
  }


}

class Blink extends State<AnimBlink> with SingleTickerProviderStateMixin{
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(vsync: this, duration: widget.duration,);
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = Tween(begin: 1.0, end: 0.1).animate(curve);
    animation.addStatusListener((status){
      if(status == AnimationStatus.completed)
        controller.reverse();
      else if(status == AnimationStatus.dismissed)
        controller.forward();
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: widget.child,
        ),
      ),
    );
  }
}
