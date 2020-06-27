import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pattoomobile/chartdir/report.dart';

class ReportRepository {

  Future<List<Report>> getReports() async {
    String jsonString = await _loadFromAsset();
    return parseReports(jsonString);
  }

  List<Report> parseReports(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Report>((json) => Report.fromJson(json)).toList();
  }

  Future<String>_loadFromAsset() async {
    return await rootBundle.loadString("assets/chart_data.json");
  }

}
