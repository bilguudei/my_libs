import 'package:flutter/material.dart';
import 'package:esis/util/ColorPredefined.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class InputTxt extends StatefulWidget{

  TextEditingController controller;
  String hint;
  String label;
  TextInputType inputType;
  Function onchange;
  String text;
  bool pass;
  TextCapitalization capitalization;
  double width;
  FocusNode focusNode;
  FocusNode nextFocus;

  InputTxt({this.controller, this.hint, this.label, this.inputType, this.onchange, this.pass, this.capitalization, this.width, this.focusNode, this.nextFocus});

  @override
  State<StatefulWidget> createState() {
    return inputTxt();
  }

}

class inputTxt extends State<InputTxt>{
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: cBlueLight(),
        accentColor: cGrayDark(),
        hintColor: cGray()
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10, top: 3),
        child: Container(
          width: widget.width != null ? widget.width : isTabPad(MediaQuery.of(context)) ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.9,//MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "${widget.hint}",
              filled: false,
              fillColor: cWhite(),
              labelText: "${widget.label}",
            ),
            focusNode: widget.focusNode,
            onSubmitted: (v){
              FocusScope.of(context).requestFocus(widget.nextFocus);
            },
            textInputAction: widget.nextFocus != null ? TextInputAction.next : TextInputAction.done,
            obscureText: (widget.pass != null) ? widget.pass : false,
            keyboardType: widget.inputType,
            autofocus: false,
            maxLines: (widget.inputType != null && widget.inputType == TextInputType.multiline) ? 4 : 1,
            textCapitalization: (widget.capitalization != null) ? widget.capitalization : TextCapitalization.none,
            style: TextStyle(color: cGrayDark(), fontSize: 16),
            onChanged: (text){
              if(widget.onchange != null)
                widget.onchange(text);
            },
          ),
        ),
      ),
    );
  }

}