import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/constants/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fireStore = FirebaseFirestore.instance;
    final stream =
        fireStore.collection(TodoConstants.todo).doc('RiN3YaS1BXAAPevEByqV');
    stream.get().then((value) => log(value.data().toString()));
    // print(object)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Application"),
      ),
      body: Padding(
        padding: basePadding,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text("Home Screen"),
            ],
          ),
        ),
      ),
    );
  }
}
