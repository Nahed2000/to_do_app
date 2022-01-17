import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/theme.dart';

import 'ui/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
        home: const HomePage(),
    );
  }
}
