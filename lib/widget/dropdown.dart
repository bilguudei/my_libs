import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dropdown extends StatefulWidget {
  final List<DropdownMenuItem> items;
  final dynamic value;
  final Function onChanged;
  final Color textColor;
  final Color color;
  Color borderColor;
  double width;
  double height;
  bool loading;
  String err = "";
  Function restart;

  Dropdown(
      {@required this.items, this.textColor, this.color, this.value, this.onChanged, this.width, @required this.loading, @required this.err, @required this.restart, this.height, this.borderColor});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    print("${widget.items.length}");
    return Container(
        width: widget.width,
        height: widget.height ?? 40,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: widget.borderColor ?? Colors.transparent, width: 1)
        ),
        child: child()
    );
  }

  Widget child(){
    if(widget.loading && widget.err.length == 0)
      return SpinKitWave(
        color: Colors.white,
        size: 11.5,
      );
    if(!widget.loading && "${widget.err}".length > 0)
      return GestureDetector(
        onTap: widget.restart,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Дахин оролдох", style: TextStyle(color: widget.textColor ?? Colors.white, fontSize: 11),),
            Icon(Icons.refresh, color: widget.textColor ?? Colors.white, size: 18,)
          ],
        ),
      );
    if(!widget.loading && widget.err.length == 0 && widget.items.length == 0)
      return Center(child: Text("Хоосон байна", style: TextStyle(fontSize: 11.5, color: widget.textColor.withOpacity(.7) ?? Colors.white.withOpacity(0.7)),));
    return DropdownButton(
        isDense: false,
        isExpanded: true,
        underline: Container(
          color: Colors.transparent,
        ),
        onTap: (){},
        dropdownColor: widget.color ?? Colors.white,
        icon: SizedBox(
          width: 15,
          child: Icon(Icons.arrow_drop_down, color: widget.textColor ?? Colors.white),
        ),
        iconEnabledColor: widget.textColor ?? Colors.white,
        style: TextStyle(color: widget.textColor ?? Colors.white, fontSize: 11.5),
        items: widget.items,
        value: widget.value,
        onChanged: (e) {
          widget.onChanged(e);
          setState(() {});
        }
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final int value;
  final String hint;
  final String errorText;
  final List<DropdownMenuItem> items;
  final Function onChanged;

  const CustomDropDown(
      {Key key,
        this.value,
        this.hint,
        this.items,
        this.onChanged,
        this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
          child: DropdownButton<int>(
            value: value,
            hint: Text(
              hint,
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            style: Theme.of(context).textTheme.bodyText2,
            items: items,
            onChanged: (item) {
              onChanged(item);
            },
            isExpanded: true,
            underline: Container(),
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text(errorText, style: TextStyle(fontSize: 12, color: Colors.red[800]),),
          )

      ],
    );
  }
}
