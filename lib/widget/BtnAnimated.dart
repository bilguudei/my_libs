import 'package:flutter/material.dart';
import 'package:esis/util/ColorPredefined.dart';

class BtnAnimated extends StatefulWidget {

  String btnText;
  Function onClick;
  Color colorText;
  Color colorBtn;
  double radius;
  double textSize;
  double blur;
  Color border;
  double width;


  BtnAnimated({this.btnText, this.onClick, this.radius, this.colorText, this.colorBtn, this.textSize, this.blur, this.border, this.width});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<BtnAnimated>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onClick,
      onTapCancel: (){
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
//    width: widget.width != null ? widget.width : (widget.btnText.length * 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(widget.radius),
      border: Border.all(color: widget.border != null ? widget.border : Colors.transparent, width: widget.border != null ? 1 : 0),
      boxShadow: [
        BoxShadow(
          color: widget.blur != null ? Color(0x30000000) : Colors.transparent,
          blurRadius: widget.blur != null ? widget.blur : 0,
          offset: Offset(0.0, 3.0),
        ),
      ],
      color: widget.colorBtn
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
      child: Center(
        child: Text(
          '${widget.btnText}',
          style: TextStyle(
            fontSize: widget.textSize,
            color: widget.colorText,
          ),
        ),
      ),
    ),
  );
}