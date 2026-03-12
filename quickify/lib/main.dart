import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'views/main_screen.dart';
import 'viewmodels/drafts_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DraftsViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeViewModel>(context);

    final light = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightPrimary),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.lightText)),
    );

    final dark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkPrimary),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.darkText)),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quickify',
      theme: themeModel.isDark ? dark : light,
      home: const MainScreen(),
    );
  }
}


