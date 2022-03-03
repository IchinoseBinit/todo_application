import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/theme/theme_data.dart';
import 'package:todo_application/utils/settings_controller.dart';
import 'package:todo_application/utils/settings_service.dart';
import 'package:todo_application/utils/size_config.dart';
import '/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsService.sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsController(),
        ),
      ],
      child: LayoutBuilder(builder: (context, boxConstraint) {
        final controller = Provider.of<SettingsController>(
          context,
          listen: false,
        );
        SizeConfig().init(boxConstraint);
        return AnimatedBuilder(
          animation: controller,
          builder: (context, __) {
            controller.loadSettings();
            return MaterialApp(
              title: 'Todo Application',
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: controller.themeMode,
              home: LoginScreen(),
            );
          },
        );
      }),
    );
  }
}
