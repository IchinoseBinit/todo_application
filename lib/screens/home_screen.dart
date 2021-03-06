import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/utils/settings_controller.dart';
import '/utils/date_formatter.dart';
import '/models/todo_model.dart';
import '/widgets/general_bottom_sheet.dart';
import '/constants/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.userId, {Key? key}) : super(key: key);

  // settingsController

  final String userId;

  @override
  Widget build(BuildContext context) {
    final fireStore = FirebaseFirestore.instance;

    final collection = fireStore.collection(TodoConstants.todo);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Application"),
        actions: [
          IconButton(
            onPressed: () async {
              final todoName =
                  await GeneralBottomSheet().customBottomSheet(context);
              if (todoName != null) {
                final todoModel = TodoModel(todoName, userId);
                collection.add(todoModel.toMap());
              }
            },
            icon: const Icon(
              Icons.add_outlined,
            ),
          )
        ],
      ),
      body: Padding(
          padding: basePadding,
          child: StreamBuilder(
            stream: collection.where("userId", isEqualTo: userId).snapshots(),
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
                    final queryDocSnapshot = snapshot.data!.docs[index];
                    final data = queryDocSnapshot.data()! as Map;
                    final todo = TodoModel.fromJson(data);
                    return Dismissible(
                      key: ValueKey(queryDocSnapshot.id),
                      onDismissed: (_) {
                        queryDocSnapshot.reference.delete();
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      child: ListTile(
                        onTap: () {
                          queryDocSnapshot.reference.update(
                            todo.updateStatus(),
                          );
                        },
                        title: Text(todo.title),
                        subtitle: Text(
                          DateFormatter.formatDateTime(todo.date),
                        ),
                        trailing: Icon(
                          todo.isCompleted
                              ? Icons.done_outlined
                              : Icons.pending_outlined,
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  primary: false,
                ),
              );
            },
          )),
      bottomNavigationBar: CustomSwitch(),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    Key? key,
  }) : super(key: key);

  // settingsController

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsController>(
          context,
        ).themeMode ==
        ThemeMode.dark;
    return ListTile(
      title: const Text(
        "Dark Mode",
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (value) {
          Provider.of<SettingsController>(context, listen: false)
              .updateThemeMode(value);
        },
      ),
    );
  }
}
