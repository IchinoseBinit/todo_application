import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/models/todo_model.dart';
import '/constants/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fireStore = FirebaseFirestore.instance;

    final collection = fireStore.collection(TodoConstants.todo);
    // final stream =
    //     fireStore.collection(TodoConstants.todo).doc('RiN3YaS1BXAAPevEByqV');
    // stream.get().then((value) => log(
    //       value.data().toString(),
    //     ));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Application"),
      ),
      body: Padding(
          padding: basePadding,
          child: StreamBuilder(
            stream: collection.orderBy("date").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data()! as Map;
                    final todo = TodoModel.fromJson(data);
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: Text(
                        todo.date.toString(),
                      ),
                      trailing: Icon(
                        todo.isCompleted
                            ? Icons.done_outlined
                            : Icons.pending_outlined,
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              );
            },
          )),
    );
  }
}
