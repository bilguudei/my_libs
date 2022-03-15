import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medle/util/constant.dart';

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
        primaryColor: Colors.deepPurpleAccent,
        hintColor: Colors.blueGrey
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10, top: 3),
        child: Container(
          width: widget.width != null ? widget.width : MediaQuery.of(context).size.width * 0.9,//MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "${widget.hint}",
              filled: false,
              fillColor: Color(0xffececec),
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
            style: TextStyle(color: color_black, fontSize: 16),
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