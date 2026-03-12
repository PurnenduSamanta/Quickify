import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'views/main_screen.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/draft_viewmodel.dart';
import 'data/app_database.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => db),
        ChangeNotifierProvider(create: (_) => HomeViewModel(db)),
        ChangeNotifierProvider(create: (_) => DraftViewModel(db)),
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
