class listItem{
  int id;
  String item;

  // ignore: unnecessary_statements
  listItem(this.id, this.item);

  static List<listItem> getItems()
  {
    return <listItem>[
      listItem(1, 'HTTP'),
      listItem(2, 'HTTPS'),
    ];
  }
}


class listItem2{
  int id;
  String item;

  // ignore: unnecessary_statements
  listItem2(this.id, this.item);

  static List<listItem> getItems2()
  {
    return <listItem>[
      listItem(1, '/pattoo/api/v1/'),
    ];
  }
}



