import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:we_all_belong/core/services/api_key_controller.dart';
import 'core/core_shared.dart';
import 'core/firebase/firebase_options.dart';
import 'package:we_all_belong/login.dart';
import 'package:geolocator/geolocator.dart';
import 'core/services/auth_service.dart';
import 'components/specs/colors.dart';
import 'core/services/profile_image_service.dart';

import 'core/user_controller/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize ProfileImageService
  Get.put(ProfileImageService());

  await Geolocator.requestPermission();
  await Geolocator.isLocationServiceEnabled();

  ///Set App Main route
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  // Initialize AuthService
  Get.put(AuthService());
  Get.put(ApiKeyController());
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
          // ignore: deprecated_member_use
          background: GenericColors.background,
          surface: GenericColors.background,
          error: Colors.red[700]!,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            color: GenericColors.primaryAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.poppins(
            color: GenericColors.primaryAccent,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: GenericColors.secondaryAccent,
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: GenericColors.supportGrey,
            fontSize: 14,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: GenericColors.highlightBlue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: GenericColors.primaryAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[700]!, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GenericColors.primaryAccent,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginApp(),
      textDirection: TextDirection.ltr,
    );
  }
}
