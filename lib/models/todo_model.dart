import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String title;
  late DateTime date;
  late bool isCompleted;

  TodoModel.fromJson(Map obj) {
    title = obj["title"];
    date = (obj["date"] as Timestamp).toDate();
    isCompleted = obj["isCompleted"];
  }
}
