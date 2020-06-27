class Report {
  final String date;
  final double vibration;

  Report({this.date, this.vibration});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        date: json['date'] as String, vibration: json['vibration'] as double);
  }
}
