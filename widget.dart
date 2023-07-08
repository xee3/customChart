import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    Key? key,
    this.width,
    this.height,
    required this.argStatistics,
    required this.filterCondition,
    required this.argCurrencyCode,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<StatisticsRecord> argStatistics;
  final String filterCondition;
  final String argCurrencyCode;

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(
              width: 0.5,
              color: Color(0xFF696969)), // Shows vertical gridlines.
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF696969),
          ),
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.currency(
              locale: 'en_US',
              symbol: widget.argCurrencyCode + ' ',
              decimalDigits: 0),
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(
              width: 0.5,
              color: Color(0xFF696969)), // Shows vertical gridlines.
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF696969),
          ),
        ),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: false,
          header: '',
          format: 'point.x : point.y',
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        series: _getAreaSeries(),
      ),
    );
  }

  List<AreaSeries<_ChartData, String>> _getAreaSeries() {
    Map<String, double> chartDataMap = _filterData();
    List<_ChartData> chartData = chartDataMap.entries
        .map((entry) => _ChartData(entry.key, entry.value))
        .toList();

    if (widget.filterCondition == "Week") {
      final orderedWeekdays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];
      chartData.sort((a, b) =>
          orderedWeekdays.indexOf(a.x).compareTo(orderedWeekdays.indexOf(b.x)));
    } else if (widget.filterCondition == "Year") {
      final orderedMonths = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      chartData.sort((a, b) =>
          orderedMonths.indexOf(a.x).compareTo(orderedMonths.indexOf(b.x)));
    } else {
      chartData.sort((a, b) => a.x.compareTo(b.x));
    }

    return <AreaSeries<_ChartData, String>>[
      AreaSeries<_ChartData, String>(
        dataSource: chartData,
        xValueMapper: (_ChartData data, _) => data.x,
        yValueMapper: (_ChartData data, _) => data.y,
        color: Color(0xFF23CE6B), // Line color
        dataLabelSettings: DataLabelSettings(
            isVisible: true, color: Color(0xFF696969)), // Text color
        enableTooltip: true,
        borderColor: Color(0xFF23CE6B), // Area border color
        borderWidth: 3, // Area border width
        opacity: 0.3, // Area fill opacity
        animationDuration: 2500,
        name: 'Prices',
      )
    ];
  }

  Map<String, double> _filterData() {
    Map<String, double> chartData = {};
    var now = DateTime.now();

    for (var document in widget.argStatistics) {
      var docDate = document.createdAt;
      var total = document.total;

           if (docDate != null && total != null) {
        String key = '';
        if (widget.filterCondition == "Week" &&
            docDate.isAfter(now.subtract(Duration(days: now.weekday)))) {
          key = DateFormat('EEEE').format(docDate);
        } else if (widget.filterCondition == "Month" &&
            docDate.month == now.month &&
            docDate.year == now.year) {
          key = 'Week ${((docDate.day - 1) ~/ 7) + 1}';
        } else if (widget.filterCondition == "Year" &&
            docDate.year == now.year) {
          key = DateFormat('MMM').format(docDate);
        }

        if (key != '') {
          if (chartData.containsKey(key)) {
            chartData[key] = chartData[key]! + total;
          } else {
            chartData[key] = total;
          }
        }
      }
    }

    return chartData;
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
