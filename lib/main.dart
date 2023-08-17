import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Open AI',
      home: const SplashScreen(),
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
    );
  }
}

class AppTheme {
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(
        size: 25,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  );

}
