import 'dart:math';

import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:pattoomobile/chartdir/report_repository.dart';


class ChartUtil {

  Future<List<Series>> getChartData() async {

    var reports = await ReportRepository().getReports().then((reports) {

      List<VibrationData> vibrationData = [];

      reports.forEach((report) {
        vibrationData.add(new VibrationData(DateTime.parse(report.date), report.vibration));
      });

      return _createChartData(vibrationData);
    });

    return reports;
  }

  static List<Series> _createChartData(List<VibrationData> vibrationData) {

    var data = [
      new Series<VibrationData, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (VibrationData vibrationData, _) => vibrationData.time,
        measureFn: (VibrationData vibrationData, _) => vibrationData.vibrationReading,
        data: vibrationData,
      ),
    ];

    return data;
  }
}

class VibrationData {
  final DateTime time;
  final double vibrationReading;

  VibrationData(this.time, this.vibrationReading);
}

double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

getDate(String lastTrip) {
  final DateTime dateTime = DateTime.parse(lastTrip);
  return DateFormat("MMM d, yyyy").format(dateTime);
}