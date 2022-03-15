import 'package:esis/model/indicator/model_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart5day extends StatelessWidget {

  List<ModelIndicator> list;
  bool sick;
  bool covid;
  Chart5day(this.list, {this.sick = false, this.covid = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: LineChart(
        chart_data(list),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData chart_data(List<ModelIndicator> list,) {
    double max = 10;
    int interval = 5;
    // print("_____chart_data: $list");

    for(int i = 0; i < list.length; i++){
      if(double.parse("${list[i].indicatorValue1}") > max)
        max = double.parse("${list[i].indicatorValue1}");
      if(double.parse("${list[i].indicatorValue2}") > max)
        max = double.parse("${list[i].indicatorValue2}");
    }
    print("max: $max");

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: (sick != null && sick || covid != null && covid) ? max > 5 ? max / 5 : 10 : 20,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (c, b) =>  const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                {if(list.length >= 1)
                  return '${list[0].indicatorValueStr1}';
                }break;
              case 3:
                {if(list.length >= 2)
                  return '${list[1].indicatorValueStr1}';
                }break;
              case 6:
                {if(list.length >= 3)
                  return '${list[2].indicatorValueStr1}';
                }break;
              case 9:
                {if(list.length >= 4)
                  return '${list[3].indicatorValueStr1}';
                }break;
              case 12:
                {if(list.length >= 5)
                  return '${list[4].indicatorValueStr1}';
                }break;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (c, b) => TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {

            if(covid != null && covid){
              if(value.toString() == "$max")return "$max";
              switch (value.toString()) {
                case "10":return '10';
                case "40":return '40';
                case "60":return '60';
                case "80":return '80';
                case "100":return '100';
              }
            }else if(sick != null && sick){
              switch (value.toString()) {
                case "0":return '0';case "0.01":return '0.01';case "0.02":return '0.02';case "0.05":return '0.05';
                case "0.1":return '0.1';case "0.5":return '0.5';case "1":return '1';case "2":return '2';
                case "5":return '5';//case "20":return '20';case "20":return '20';case "20":return '20';
              // case "20":return '20';case "20":return '20';case "20":return '20';case "20":return '20';
              // case "20":return '20';case "20":return '20';case "20":return '20';case "20":return '20';
                case "20":return '20';
                case "40":return '40';
                case "60":return '60';
                case "80":return '80';
                case "100":return '100';
              }
            }else{
              switch (value.toInt()) {
                case 20:
                  return '20';
                case 40:
                  return '40';
                case 60:
                  return '60';
                case 80:
                  return '80';
                case 100:
                  return '100';
              }
            }

            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.purple,
              width: 0.5,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: max * 1.2,
      minY: 0,
      lineBarsData: linesBarData2(list, ),
    );
  }

  List<LineChartBarData> linesBarData2(List<ModelIndicator> list,) {
    List<double> eelj1 = [];
    List<double> eelj2 = [];
    List<double> eelj3 = [];
    for(int i = 0; i < list.length; i++){
      ModelIndicator m = list[i];
      eelj1.add(double.parse("${m.indicatorValue1}"));
      if(covid != null && covid)eelj2.add(double.parse("${m.indicatorValue2}"));
      // eelj2.add(double.parse("${m["indicatorValue2"]}"));
      if(sick == null && covid == null)eelj2.add(double.parse("${m.indicatorValue2}"));
      if(sick == null && covid == null)eelj3.add(double.parse("${m.indicatorValue3}"));
    }
    return [
      chart(Colors.deepPurple, eelj1),
      // chart(Colors.purpleAccent, eelj2),
      if(eelj2.length > 0)chart(Colors.orange, eelj2),
      if(eelj3.length > 0)chart(Colors.green, eelj3),
    ];
  }

  LineChartBarData chart(Color color, List<double> value){
    return value.length > 0 ? LineChartBarData(
      spots: [
        if(value.length >= 1)FlSpot(0, value[0]),
        if(value.length >= 2)FlSpot(3, value[1]),
        if(value.length >= 3)FlSpot(6, value[2]),
        if(value.length >= 4)FlSpot(9, value[3]),
        if(value.length >= 5)FlSpot(12, value[4]),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: [
        color,
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ) : LineChartBarData(
      spots: [
        FlSpot(0, 0),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: [
        color,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
      ),
    );
  }
}
