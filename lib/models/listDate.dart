class ListDate {
  List<DateTime> list;

  ListDate() {
    DateTime now = DateTime.now();
    
    list = [
      now.subtract(Duration(days: 7)),
      now.subtract(Duration(days: 6)),
      now.subtract(Duration(days: 5)),
      now.subtract(Duration(days: 4)),
      now.subtract(Duration(days: 3)),
      now.subtract(Duration(days: 2)),
      now.subtract(Duration(days: 1)),
      now,
      now.add(Duration(days: 1)),
      now.add(Duration(days: 2)),
      now.add(Duration(days: 3)),
      now.add(Duration(days: 4)),
      now.add(Duration(days: 5)),
      now.add(Duration(days: 6)),
      now.add(Duration(days: 7)),
    ];
  }
}