import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuro_math/core/injection/di.dart';
import 'package:neuro_math/core/theme/app_themes.dart'; // Import AppThemes
import 'package:neuro_math/core/theme/theme_cubit.dart'; // Import ThemeCubit
import 'package:neuro_math/view/auth/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // Keep landscape commented out unless specifically needed globally
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);

  // Initialize dependency injection
  initInject();

  // Run the app, providing SharedPreferences to ThemeCubit
  runApp(Math(prefs: prefs));
}

class Math extends StatelessWidget {
  final SharedPreferences prefs;
  const Math({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Provide ThemeCubit at the top level
    return BlocProvider(
      create: (_) => ThemeCubit(prefs),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Neuro Math', // Add a title
            theme: AppThemes.lightTheme, // Provide light theme
            darkTheme: AppThemes.darkTheme, // Provide dark theme
            themeMode: themeMode, // Control theme mode via ThemeCubit
            home: const LoginScreen(), // Start with LoginScreen
          );
        },
      ),
    );
  }
}
