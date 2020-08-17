//Variables for tile items

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class TileItem{
  int id;
  Image tileImage;
  String chartTitle;
  String chartDescription;

  //Constructor
  TileItem({
    @required this.id,
    @required this.tileImage,
    @required this.chartTitle,
    @required this.chartDescription,
  });
}