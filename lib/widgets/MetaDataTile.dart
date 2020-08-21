import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';

class MetaDataTile extends StatefulWidget {
  final title;
  final value;
  MetaDataTile({Key key, String this.title, String this.value})
      : super(key: key);

  @override
  _metaDataTileState createState() => _metaDataTileState(title, value);
}

class _metaDataTileState extends State<MetaDataTile> {
  final title;
  final value;

  _metaDataTileState(this.title, this.value);
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return ListTile(
        leading: Icon(
          Icons.timeline,
          color: Provider.of<ThemeManager>(context)
              .themeData
              .textTheme
              .headline4
              .color,
        ),
        title: Text(this.title,
            style: TextStyle(
                color: Provider.of<ThemeManager>(context)
                    .themeData
                    .textTheme
                    .headline4
                    .color,
                fontWeight: FontWeight.bold)),
        trailing: SizedBox(
          width: queryData.size.width * 0.32,
          child: Wrap(
              textDirection: TextDirection.ltr,
              direction: Axis.horizontal,
              children: <Widget>[
                Text(this.value,
                    style: TextStyle(
                        color: Provider.of<ThemeManager>(context)
                            .themeData
                            .textTheme
                            .headline5
                            .color,
                        fontWeight: FontWeight.bold))
              ]),
        ));
  }
}
