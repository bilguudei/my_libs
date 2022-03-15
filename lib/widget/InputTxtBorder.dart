import 'package:flutter/material.dart';
import 'package:esis/util/ColorPredefined.dart';

class InputTxtBorder extends StatefulWidget{
  String hint;
  bool filled;
  TextInputType inputType = TextInputType.text;
  bool isPassword = false;
  TextInputAction action = TextInputAction.next;
  TextEditingController controller;
  Function onChange;
  double width;
  Color background;
  Color borderColor;
  Color textColor;
  Color hintColor;
  double textSize;
  int maxLines;
  double radius;
  TextCapitalization textCapitalization;
  double bottomPadding = 0;
  FocusNode node;
  FocusNode nextNode;
  bool autoFocus = false;
  Widget prefixIcon;

  InputTxtBorder({this.hint, this.inputType,
    this.isPassword, this.action, this.controller, this.radius,
    this.onChange, this.width, this.borderColor, this.background,
    this.textColor, this.hintColor, this.textSize, this.textCapitalization,
    this.filled, this.maxLines, this.bottomPadding = 0, this.nextNode,
    this.node, this.autoFocus, this.prefixIcon});

  @override
  State<StatefulWidget> createState() {
    return inputTxtBorder();
  }

}

class inputTxtBorder extends State<InputTxtBorder>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Container(
        width: widget.width != null ? widget.width : MediaQuery.of(context).size.width * 0.85,
        height: 50,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(widget.radius != null ? widget.radius : 10.0),
          child: TextField(
            autofocus: widget.autoFocus == null ? false : widget.autoFocus,
            controller: widget.controller,
            onChanged: (str){
              if(widget.onChange != null)
                widget.onChange(str);
            },
            onSubmitted: (str){
              FocusScope.of(context).requestFocus(widget.nextNode);
            },
            focusNode: widget.node,
            textAlign: TextAlign.start,
            cursorColor: widget.textColor,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius != null ? widget.radius : 10.0),
                borderSide: BorderSide(color: widget.borderColor != null ? widget.borderColor : cBlueLight(), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius != null ? widget.radius : 10.0),
                borderSide: BorderSide(color: widget.borderColor != null ? widget.borderColor : cBlueLight(), width: 1),
              ),
              fillColor: widget.background != null ? widget.background : Colors.white,
              labelStyle: TextStyle(color: widget.hintColor != null ? widget.hintColor : cGray()),
              filled: widget.filled != null ? widget.filled : true,
              labelText: widget.hint != null ? widget.hint : "",
              contentPadding: EdgeInsets.only(left: 25, bottom: 5),
            ),
            style: TextStyle(color: widget.textColor != null ? widget.textColor : Colors.white, fontSize: widget.textSize != null ? widget.textSize : isTabPad(MediaQuery.of(context)) ? 22 : 16.0),
            textInputAction: widget.nextNode != null ? TextInputAction.next : TextInputAction.done,
            maxLines: widget.maxLines != null ? widget.maxLines : 1,
            keyboardType: widget.inputType,
            textCapitalization: widget.textCapitalization != null ? widget.textCapitalization : TextCapitalization.none,
            obscureText: widget.isPassword ?? false,
          ),
        ),
      ),
    );
  }

}