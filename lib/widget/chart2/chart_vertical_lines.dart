import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartVerticalLines extends StatelessWidget {
  double width;
  List<String> hints;
  List<String> values;
  bool kindergarten = false;
  bool isDouble = false;

  //ChartVerticalLines(
  //     width: Get.width * 0.8,
  //     hints: [
  //       ...ctrl.all[s2].map((e) => e.indicatorvaluestr).toList()
  //     ],
  //     values: [
  //       ...ctrl.all[s2].map((e) => e.indicatorvalue1).toList()
  //     ],
  //  )

  ChartVerticalLines({this.width, this.hints, this.kindergarten = false, this.isDouble = false, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hints.length * 35.0,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.76,
            child: charts.BarChart(
              _createSampleData(),
              animate: true,
              barGroupingType: charts.BarGroupingType.stacked,
              vertical: false,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<Map, String>> _createSampleData() {

    final data = _data();
    return [
      new charts.Series<Map, String>(
        id: 'private',
        domainFn: (Map m, _) => m["name"],
        measureFn: (Map m, _) => m["data"],
        data: data,
        colorFn: (Map m, _) => kindergarten != null && kindergarten ? charts.MaterialPalette.cyan.shadeDefault : charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Map m, _) => "${m["data"]}",
        // displayName: "display"
      ),
    ];
  }

  List<Map> _data(){
    List<Map> list = new List();

    for(int i = 0; i < hints.length; i++){
      list.add(
        {
          "name": hints[i],
          "data": isDouble ? double.parse(values[i].replaceAll("null", "0")) : int.parse(values[i].replaceAll("null", "0"))
        });
    }

    return list;
  }
}
