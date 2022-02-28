import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/theme/theme_data.dart';
import 'package:todo_application/utils/settings_controller.dart';
import '/screens/home_screen.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController();
  await settingsController.loadSettings();
  await Firebase.initializeApp();
  runApp(MyApp(settingsController));
}

class MyApp extends StatelessWidget {
  const MyApp(this.settingsController, {Key? key}) : super(key: key);

  final SettingsController settingsController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (_, __) {
        return MaterialApp(
          title: 'Todo Application',
          theme: lightTheme(context),
          darkTheme: darkTheme(context),
          themeMode: settingsController.themeMode,
          home: LoginScreen(),
        );
      },
    );
  }
}
