import 'package:esis/model/indicator/model_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum DataType{
  int,
  double,
}

class ChartLine extends StatelessWidget {

  List<List<String>> list = [];
  List<String> listDates = [];
  DataType type = DataType.int;
  List<Color> colors = [Colors.orangeAccent, Colors.lightBlue, Colors.deepPurpleAccent, Colors.green];
  List<String> hints = [];

  ChartLine({@required this.list, @required this.listDates, this.type = DataType.double, this.hints = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: LineChart(
            chart_data(),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
        if(hints.isNotEmpty)Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(int i = 0; i < hints.length; i++)
              widgetHint(i)
          ],
        ),
      ],
    );
  }

  Widget widgetHint(int i){
    return Row(
      children: [
        Container(
          width: 20,
          height: 4,
          decoration: BoxDecoration(
            color: colors[i],
            borderRadius: BorderRadius.circular(4)
          ),
        ),
        SizedBox(width: 5,),
        Text("${hints[i]}"),
      ],
    );
  }

  LineChartData chart_data() {
    double max = 10;
    // int interval = 5;
    // // print("_____chart_data: $list");
    //
    list.forEach((l) {
      l.forEach((e) {
        if(double.parse(e) > max)
          max = double.parse(e);
      });
    });

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: max / 5,
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
                {if(listDates.length >= 1)
                  return '${listDates[0]}';
                }break;
              case 3:
                {if(listDates.length >= 2)
                  return '${listDates[1]}';
                }break;
              case 6:
                {if(listDates.length >= 3)
                  return '${listDates[2]}';
                }break;
              case 9:
                {if(listDates.length >= 4)
                  return '${listDates[3]}';
                }break;
              case 12:
                {if(listDates.length >= 5)
                  return '${listDates[4]}';
                }break;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (c, b) => TextStyle(
            color: Color(0xff75729e),
            fontSize: 13,
          ),
          getTitles: (value) {
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

            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          // show: true,
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
      lineBarsData: [
        for(int i = 0; i < list.length; i++)
          chart(colors[i], list[i])
      ],
    );
  }

  LineChartBarData chart(Color color, List<String> l){
    return LineChartBarData(
      spots: [
        if(l.length >= 1)FlSpot(0, double.parse(l[0])),
        if(l.length >= 2)FlSpot(3, double.parse(l[1])),
        if(l.length >= 3)FlSpot(6, double.parse(l[2])),
        if(l.length >= 4)FlSpot(9, double.parse(l[3])),
        if(l.length >= 5)FlSpot(12, double.parse(l[4])),
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
    );
  }
}
