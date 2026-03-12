import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/main_screen.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/draft_viewmodel.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel(initialDarkMode: isDark)),
        ChangeNotifierProvider(create: (_) => DraftViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeViewModel>(context);

    final light = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightPrimary),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.lightText),
      ),
    );

    final dark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkPrimary),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.darkText),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quickify',
      theme: homeModel.isDark ? dark : light,
      home: const MainScreen(),
    );
  }
}
