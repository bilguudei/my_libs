import 'package:esis/widget/button/BtnAnimated.dart';
import 'package:flutter/material.dart';

class Btn_animated_icon extends StatefulWidget{
  String btnText;
  Function onClick;
  Color colorText;
  Color colorBtn;
  double radius;
  double textSize;
  double blur;
  Color border;
  double width;
  Icon icon;

  Btn_animated_icon({this.btnText, this.onClick, this.colorText, this.colorBtn,
      this.radius, this.textSize, this.blur, this.border, this.width,
      this.icon});

  @override
  State<StatefulWidget> createState() {
    return btn_animated_icon();
  }

}

class btn_animated_icon extends State<Btn_animated_icon> with SingleTickerProviderStateMixin{
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
    width: 150,//widget.width != null ? widget.width : (widget.btnText.length * 12.0) + widget.icon.size,
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        widget.icon,
        SizedBox(width: 4,),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 15),
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
      ],
    ),
  );
}