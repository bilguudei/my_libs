import 'package:esis/util/ColorPredefined.dart';
import 'package:esis/widget/button/BtnAnimated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class C_date_picker extends StatefulWidget {
  Function onSelected;
  String text;
  String current;
  Function onClick;
  Function onOutsideClick;

  C_date_picker({this.onSelected, this.text, this.current, this.onClick, this.onOutsideClick});

  @override
  _C_date_pickerState createState() {
    return _C_date_pickerState();
  }
}

class _C_date_pickerState extends State<C_date_picker> {
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
    return GestureDetector(
      onTap: (){
        if(widget.onOutsideClick != null){
          widget.onOutsideClick();
        }
      },
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${widget.text}", style: TextStyle(),),
              DatePickerWidget(
                looping: false,   // default is not looping
                firstDate: DateTime(2021),
                lastDate: DateTime.now().add(Duration(days: 360)),
                initialDate: DateTime.parse(widget.current),
                dateFormat: "yyyy-MM-dd",
                onChange: (DateTime newDate, _){
//                => _selectedDate = newDate

                  widget.onSelected(newDate);
                },
                pickerTheme: DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19)
                ),
              ),
              SizedBox(height: 15,),
              BtnAnimated(
                textSize: 16,
                onClick: (){
                  widget.onClick();
                  Navigator.pop(context);
                },
                radius: 8,
                colorText: Colors.white,
                colorBtn: cCyan(),
                btnText: "Сонгох",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class C_time_picker extends StatefulWidget {
  Function onSelected;
  String text;
  String current;
  Function onClick;
  Function onOutsideClick;

  C_time_picker({this.onSelected, this.text, this.current, this.onClick, this.onOutsideClick});

  @override
  _C_time_pickerState createState() {
    return _C_time_pickerState();
  }
}

class _C_time_pickerState extends State<C_time_picker> {
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
    return GestureDetector(
      onTap: (){
        if(widget.onOutsideClick != null){
          widget.onOutsideClick();
        }
      },
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${widget.text}", style: TextStyle(),),

              DatePickerWidget(
                looping: false,   // default is not looping
                firstDate: DateTime(2021),
                lastDate: DateTime.now().add(Duration(days: 360)),
                initialDate: DateTime.parse(widget.current),
                dateFormat: "tt:mm",
                onChange: (DateTime newDate, _){
//                => _selectedDate = newDate

                  widget.onSelected(newDate);
                },
                pickerTheme: DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19)
                ),
              ),
              SizedBox(height: 15,),
              BtnAnimated(
                textSize: 16,
                onClick: (){
                  widget.onClick();
                  Navigator.pop(context);
                },
                radius: 8,
                colorText: Colors.white,
                colorBtn: cCyan(),
                btnText: "Сонгох",
              )
            ],
          ),
        ),
      ),
    );
  }
}