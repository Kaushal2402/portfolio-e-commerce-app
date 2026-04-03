import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/onboarding/presentation/pages/splash_page.dart';
import 'features/onboarding/presentation/pages/walkthrough_page.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartCommerceApp());
}

class SmartCommerceApp extends StatelessWidget {
  const SmartCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
        // Add other global BLoCs here
      ],
      child: MaterialApp(
        title: 'SmartCommerce',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashPage(), // Start with Splash Screen
      ),
    );
  }
}
