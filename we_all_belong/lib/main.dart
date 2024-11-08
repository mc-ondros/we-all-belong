import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'providers/place_provider.dart';

void main() {
  runApp(const WeAllBelongApp());
}

class WeAllBelongApp extends StatelessWidget {
  const WeAllBelongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlaceProvider(),
      child: MaterialApp(
        title: 'We All Belong',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const WelcomeScreen(), // Updated to WelcomeScreen
      ),
    );
  }
}