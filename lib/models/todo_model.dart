import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String title;
  DateTime date = DateTime.now();
  bool isCompleted = false;
  late String userId;

  TodoModel.fromJson(Map obj) {
    title = obj["title"];
    date = (obj["date"] as Timestamp).toDate();
    isCompleted = obj["isCompleted"];
    userId = obj["userId"];
  }

  TodoModel(
    this.title,
    this.userId,
  );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["title"] = title;
    map["isCompleted"] = isCompleted;
    map["date"] = Timestamp.fromDate(date);
    map["userId"] = userId;

    return map;
  }

  Map<String, bool> updateStatus() {
    final Map<String, bool> map = {};
    map["isCompleted"] = !isCompleted;
    return map;
  }
}
