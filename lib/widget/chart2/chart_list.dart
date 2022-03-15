import 'package:esis/model/indicator/model_indicator.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

class ChartList extends StatelessWidget {
  double width;
  List<ModelIndicator> datas;
  bool twoDatas;
  bool show3;

  ChartList({this.width, this.datas, this.twoDatas = false, this.show3 = false});

  @override
  Widget build(BuildContext context) {
    return datas.length == 0 ? Container() : Container(
      width: width,
      // height: datas.length * 32.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: datas.length * 30.0,
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
          Container(
            width: Get.width * 0.30 - 16,
            height: datas.length * 30.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 5,),

                for(int i = 0; i < datas.length; i++)
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${datas[i].indicatorvalue1}", style: TextStyle(fontSize: 11.5, color: Colors.blue, fontWeight: FontWeight.bold),),
                        Text("${datas[i].indicatorvalue2}", style: TextStyle(fontSize: 11.5, color: Colors.green, fontWeight: FontWeight.bold),),
                        if(!twoDatas)Text("${datas[i].indicatorvalue3}", style: TextStyle(fontSize: 11.5, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                SizedBox(height: 5,),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<charts.Series<Map, String>> _createSampleData() {
    //print("_______+++ $datas");

    List<Map> uls = twoDatas ? _data("indicatorvalue1") : _data("indicatorvalue2");
    List<Map> huvi = twoDatas ?  _data("indicatorvalue2") : _data("indicatorvalue3");
    List<Map> third = [];

    if(show3){
      uls = _data("indicatorvalue1");
      huvi = _data("indicatorvalue2");
      third = _data("indicatorvalue3");
    }

    return [
      new charts.Series<Map, String>(
          id: 'public',
          domainFn: (Map m, _) => "${m["name"]}",
          measureFn: (Map m, _) => int.parse("${m["data"]}".replaceAll("null", "0")),
          data: uls,

          colorFn: (Map m, _) => charts.MaterialPalette.blue.shadeDefault,
          labelAccessorFn: (Map m, _) => ""//"${m["data"]}"
      ),
      new charts.Series<Map, String>(
          id: 'private',
          domainFn: (Map m, _) => "${m["name"]}",
          measureFn: (Map m, _) => int.parse("${m["data"]}".replaceAll("null", "0")),
          data: huvi,
          colorFn: (Map m, _) => charts.MaterialPalette.green.shadeDefault,
          labelAccessorFn: (Map m, _) => ""//"${m["data"]}",
        // displayName: "display"
      ),
      if(show3)new charts.Series<Map, String>(
          id: 'third',
          domainFn: (Map m, _) => "${m["name"]}",
          measureFn: (Map m, _) => int.parse("${m["data"]}".replaceAll("null", "0")),
          data: third,
          colorFn: (Map m, _) => charts.MaterialPalette.purple.shadeDefault,
          labelAccessorFn: (Map m, _) => ""//"${m["data"]}",
        // displayName: "display"
      ),
    ];
  }

  List<Map> _data(String s){
    List<Map> list = new List();

    for(int i = 0; i < datas.length; i++){
      ModelIndicator m = datas[i];
      String str = m.indicatorvalue1;
      switch(s){
        case "indicatorvalue2": str = m.indicatorvalue2;break;
        case "indicatorvalue3": str = m.indicatorvalue3;break;
        case "indicatorvalue4": str = m.indicatorvalue4;break;
      }
      String string = "";
      List l = m.indicatorvaluestr.replaceAll("null", "Нэргүй").split(" ");
      int loop = 0;
      for(int i = 0; i < l.length; i++){
        if(loop < 2){
          string += l[i] + " ";
        }else{
          string += l[i] + "\n";
          loop = 0;
        }
        loop++;
      }
      list.add({"name": string, "data": str});
    }

    return list;
  }
}
