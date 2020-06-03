import 'dart:convert';
import './timestamp.dart';
class DataPoint {
  String key;
  String value;
  DataPoint({
    this.key,
    this.value,
  });
  List timeStamps = new List();

  DataPoint copyWith({
    String key,
    String value,
  }) {
    return DataPoint(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }

  static DataPoint fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DataPoint(
      key: map['key'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static DataPoint fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'DataPoint(key: $key, value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataPoint &&
      o.key == key &&
      o.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;


  addTimeStamps(TimeStamp timestamps){
    this.timeStamps.add(timestamps);
  }
}
