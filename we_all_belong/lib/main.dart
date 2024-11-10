import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'core/core_shared.dart';
import 'core/firebase/firebase_options.dart';
import 'package:we_all_belong/login.dart';
import 'package:geolocator/geolocator.dart';
import 'core/services/auth_service.dart';
import 'components/specs/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/user_controller/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  // Initialize AuthService
  Get.put(AuthService());

  await Geolocator.requestPermission();
  await Geolocator.isLocationServiceEnabled();

  ///Set App Main route
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  UserController userController = Get.put(UserController());

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'We All Belong',
      theme: ThemeData(
        scaffoldBackgroundColor: GenericColors.background,
        colorScheme: ColorScheme.dark(
          primary: GenericColors.primaryAccent,
          secondary: GenericColors.secondaryAccent,
          background: GenericColors.background,
          surface: GenericColors.background,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.poppins(
            color: GenericColors.primaryAccent,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: GenericColors.secondaryAccent,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: GenericColors.supportGrey,
          ),
        ),
        iconTheme: IconThemeData(
          color: GenericColors.secondaryAccent,
        ),
        useMaterial3: true,
      ),
      home: const LoginApp(),
      textDirection: TextDirection.ltr,
    );
  }
}
