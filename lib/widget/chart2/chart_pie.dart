import 'dart:math';

import 'package:esis/model/indicator/model_indicator.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';

class ChartPie extends StatelessWidget {

  double width;
  double height;
  double pieWidth;
  List<String> hints;
  List<String> datas;
  bool isRow;
  int arcWidth;
  List<Color> colors;
  bool showHint;

  ChartPie({this.width, this.height, this.datas, this.isRow, this.arcWidth, this.pieWidth,
    this.colors, this.showHint, this.hints});

  //ChartPie(
  //     height: 180,
  //     isRow: true,
  //     showHint: true,
  //     width: Get.width * 0.9,
  //     colors: [Colors.purple, Colors.pinkAccent, Colors.lightBlue, Colors.orange, Colors.blueAccent, Colors.amber],
  //     arcWidth: 90,
  //     hints: [
  //       ...ctrl.all[s7].map((e) => e.indicatorvaluestr).toList()
  //     ],
  //     datas: [
  //       ...ctrl.all[s7].map((e) => e.indicatorvalue1).toList()
  //     ],
  //   ),

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 180,
      width: width ?? Get.width * .9,
      child: isRow ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          pie(),
          if(showHint != null && showHint)Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(int i = 0; i < hints.length; i++)
                  hint(text: hints[i], color: colors[i])
              ],
            ),
          )
        ],
      ) : Column(
        children: [
          pie(),
          if(showHint != null && showHint)SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i = 0; i < datas.length; i++)
                  hint(text: hints[i], color: colors[i])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pie(){
    return Container(
      width: pieWidth != null ? pieWidth : isRow ? width * 0.5 : width,//showHint!= null && showHint == false ?
      height: pieWidth != null ? pieWidth : isRow ? height : height * 0.8,
      child: charts.PieChart(_samplePie(), animate: true, defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: arcWidth != null ? arcWidth : 100,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]
      ),),
    );
  }

  Widget hint({String text, Color color}){
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),),
        SizedBox(width: 6,),
        Expanded(child: Text("$text", style: TextStyle(fontSize: 11), maxLines: 3,)),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Map, String>> _samplePie() {
    // List<Map> data = [
    //   {"name": "Бага", "data": 20},
    //   {"name": "Дунд", "data": 60},
    //   {"name": "Бүрэн дунд", "data": 20},
    // ];
    List<Map> data = new List();

    // final List<Map> d = data;

    return [
      new charts.Series<Map, String>(
        id: 'Sales',
        domainFn: (Map m, _) => m["name"],
        measureFn: (Map m, _) => m["data"],
        colorFn: (Map m, _){
          String str = m["color"].toString();
          String c = "${str.substring(str.indexOf("0xff") + 4, str.indexOf("0xff") + 10)}";
          print("_______>> $str");
          return charts.Color.fromHex(code: "#$c");
        },
        data: _data(),
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Map row, _) => '${row["data"]}',
      )
    ];
  }

  List<Map> _data(){
    List<Map> d = new List();

    for(int i = 0; i < datas.length; i++){
      d.add({"name": hints[i], "data": int.parse(datas[i].replaceAll("null", "0")), "color": colors[i]});
    }
    return d;
  }
}
