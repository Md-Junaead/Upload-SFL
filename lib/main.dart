import 'package:flutter/material.dart';
import 'screens/splash_decider.dart';

void main() {
  // Ensure binding before running app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// flutter build apk --build-name=1.0 --build-number=1
// flutter clean && flutter build appbundle --release

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove debug banner
      debugShowCheckedModeBanner: false,
      title: 'SaverFavor',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // Start at the SplashDecider which shows animation then WebView
      home: const SplashDecider(),
    );
  }
}
