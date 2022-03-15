import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:esis/util/ColorPredefined.dart';

class BtnLoad extends StatefulWidget{

  Color splash = Color(0xff624594);
  Color color = Colors.white;
  Color textColor = Color(0xffd6b9e1);
  Color borderColor = Color(0xffa971bc);
  double width;
  bool loading;
  double textSize;
  List<Color> gradient;
  Alignment start;
  Alignment end;
  double height;

  final GestureTapCallback onPressed;
  String text = "text";


  BtnLoad({this.splash, this.color, this.textColor, this.borderColor, this.start, this.end,
    this.onPressed, this.text, this.width, this.loading, this.textSize, this.gradient, this.height});

  @override
  State<StatefulWidget> createState() {
    return btn();
  }

}

class btn extends State<BtnLoad>{
  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: widget.loading ? (isTabPad(MediaQuery.of(context)) ? 70 : 55) : widget.width,//MediaQuery.of(context).size.width * 0.85,
        height: widget.height != null ? widget.height : isTabPad(MediaQuery.of(context)) ? 70 : 55,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: widget.loading ? BorderRadius.circular(50.0) : BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          elevation: isPressed ? 0.0 : 5.0,
          shadowColor: cGray(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.gradient != null ? widget.gradient : [widget.color, widget.color],
                  end: widget.end != null ? widget.end : Alignment(0.5, 1),
                  begin: widget.start != null ? widget.start : Alignment(0.5, 0)),
              borderRadius: widget.loading ? BorderRadius.circular(50.0) : BorderRadius.circular(10.0),
              shape: BoxShape.rectangle,
              border: Border.all(color: widget.borderColor != null ? widget.borderColor : Colors.transparent, width: widget.gradient != null ? 0 : 2.0),
            ),
            child: Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              child: InkWell(
                splashColor: widget.splash,
                onTap: (){
                  widget.onPressed();
                },
                borderRadius: widget.loading ? BorderRadius.circular(50.0) : BorderRadius.circular(10.0),
                child: Container(
                  // padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: AnimatedCrossFade(
                      firstChild: Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.textSize != null ? widget.textSize : isTabPad(MediaQuery.of(context)) ? 22 : 16.0,
                        ),
                      ),
                      secondChild: SpinKitRing(duration: Duration(milliseconds: 2500), color: widget.textColor, size: isTabPad(MediaQuery.of(context)) ? 35 : 25, lineWidth: 2,),
                      crossFadeState: widget.loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 400),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}