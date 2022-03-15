import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimSize extends StatefulWidget {

  Widget child;
  bool expand;
  bool expand2;
  String type;
  Color color;

  AnimSize({
    this.child,
    this.expand,
    this.expand2,
    this.type, this.color
  });

  @override
  _SizeAnimationState createState() => _SizeAnimationState();
}

class _SizeAnimationState extends State<AnimSize>  with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  // Setting up the animation
  void prepareAnimations() {
    _controller = AnimationController(vsync: this, duration: new Duration(milliseconds: 250));
    animation = new Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
     if(widget.expand2){
       _controller.forward();
     }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        widget.type == 'expand' ? SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: widget.child,
        ) : Container(),

        widget.type == 'rotate' ? AnimatedBuilder(
            animation: animation,
            builder: (context , child) {
              return Transform.rotate(
                angle: animation.value * 1.0 * math.pi/2,
                child: Icon(Icons.keyboard_arrow_right, size: 30, color: widget.color != null ? widget.color : Colors.black.withOpacity(0.9),),
              );
            }
        )
            : Container(),

      ],
    );

  }

  @override
  void didUpdateWidget(AnimSize oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.expand){
      _controller.reverse();
    } else {
      _controller.forward();
    }

  }
}