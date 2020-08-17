class listItem{
  int id;
  String item;

  // ignore: unnecessary_statements
  listItem(this.id, this.item);

  //Chart options for api link on options page
  static List<listItem> getItems()
  {
    return <listItem>[
      listItem(1, 'HTTP'),
      listItem(2, 'HTTPS'),
    ];
  }
}


