import 'package:charts_flutter/flutter.dart';
import 'package:esis/model/indicator/model_indicator.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

class ChartListParam extends StatefulWidget {
  List<String> hints = [];
  List<List<String>> datas = [];

  ChartListParam({@required this.datas, @required this.hints});

  @override
  State<ChartListParam> createState() => _ChartListParamState();
}

class _ChartListParamState extends State<ChartListParam> {
  List<List<Map>> list = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < widget.hints.length; i++){
      List<Map> li = [];
      widget.datas.forEach((e) {
        li.add({"name": widget.hints[i], "data": e[i]});
      });
      list.add(li);
    }
  }

  @override
  Widget build(BuildContext context) {
    return list.length == 0 ? Container() : Container(
      width: Get.width,
      // height: datas.length * 32.0,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: widget.hints.length * 30.0,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: charts.BarChart(
                    _createSampleData(),
                    animate: true,
                    barGroupingType: charts.BarGroupingType.stacked,
                    vertical: false,
                    barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<charts.Series<Map, String>> _createSampleData() {

    List<charts.Color> colors = [charts.MaterialPalette.green.shadeDefault, charts.MaterialPalette.blue.shadeDefault, charts.MaterialPalette.purple.shadeDefault, charts.MaterialPalette.green.shadeDefault,];

    List<Map> list1 = [];
    List<Map> list2 = [];
    List<Map> list3 = [];
    List<Map> list4 = [];
    for(int i = 0; i < list.length; i++){
      if(list.length > 0)
        list1.add(list[i][0]);
      if(list.length > 1)
        list2.add(list[i][1]);
      if(list.length > 2)
        list3.add(list[i][2]);
    }

    return [
      if(list1.isNotEmpty)
        charts.Series<Map, String>(
            id: 'gg',
            domainFn: (Map m, _) => m["name"],
            measureFn: (Map m, _) => double.parse("${m["data"]}".replaceAll("null", "0")),
            data: list1,
            overlaySeries: false,
            colorFn: (Map m, _) => colors[0],
            labelAccessorFn: (Map m, _) => double.parse("${m["data"]}") > 20 ? "${m["data"]}" : ""
        ),
      if(list2.isNotEmpty)
        charts.Series<Map, String>(
            id: 'gg',
            domainFn: (Map m, _) => m["name"],
            overlaySeries: false,
            measureFn: (Map m, _) => double.parse("${m["data"]}".replaceAll("null", "0")),
            data: list2,
            colorFn: (Map m, _) => colors[1],
            labelAccessorFn: (Map m, _) => double.parse("${m["data"]}") > 20 ? "${m["data"]}" : ""
        ),
      if(list3.isNotEmpty)
        charts.Series<Map, String>(
            id: 'gg',
            overlaySeries: false,
            domainFn: (Map m, _) => m["name"],
            measureFn: (Map m, _) => double.parse("${m["data"]}".replaceAll("null", "0")),
            data: list3,
            colorFn: (Map m, _) => colors[2],
            labelAccessorFn: (Map m, _) => double.parse("${m["data"]}") > 20 ? "${m["data"]}" : "",
        ),
    ];
  }
}
