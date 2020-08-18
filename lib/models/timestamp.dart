//Variables for time stamp (time series data)
import 'dart:convert';

class TimeStamp {
  int value;
  int timestamp;
  TimeStamp({
    this.value,
    this.timestamp,
  });

  @override
  int get hashCode => value.hashCode ^ timestamp.hashCode;

  DateTime get Timestamp {
    var date = DateTime.fromMillisecondsSinceEpoch(this.timestamp);
    DateTime timestamp_date = new DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.microsecond,
        date.millisecond);
    return timestamp_date;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TimeStamp && o.value == value && o.timestamp == timestamp;
  }

  TimeStamp copyWith({
    int value,
    String timestamp,
  }) {
    return TimeStamp(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() => 'TimeStamp(value: $value, timestamp: $timestamp)';

  static TimeStamp fromJson(String source) => fromMap(json.decode(source));

  static TimeStamp fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TimeStamp(
      value: map['value'],
      timestamp: map['timestamp'],
    );
  }
}
