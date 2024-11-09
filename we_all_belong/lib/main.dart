import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:we_all_belong/features/homepage/homepage_screen.dart';
import 'core/core_shared.dart';
import 'core/firebase/firebase_options.dart';
import 'package:we_all_belong/login.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  ///Initialise cache storage
  // await GetStorage.init('SettingsBox');

  await Geolocator.requestPermission();
  await Geolocator.isLocationServiceEnabled();

  ///Set App Main route
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'We All Belong',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginApp(),
      textDirection: TextDirection.ltr,
    );
  }
}
