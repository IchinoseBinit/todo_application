import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String title;
  DateTime date = DateTime.now();
  bool isCompleted = false;

  TodoModel.fromJson(Map obj) {
    title = obj["title"];
    date = (obj["date"] as Timestamp).toDate();
    isCompleted = obj["isCompleted"];
  }

  TodoModel(
    this.title,
  );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["title"] = title;
    map["isCompleted"] = isCompleted;
    map["date"] = Timestamp.fromDate(date);

    return map;
  }

  Map<String, bool> updateStatus() {
    final Map<String, bool> map = {};
    map["isCompleted"] = !isCompleted;
    return map;
  }
}
