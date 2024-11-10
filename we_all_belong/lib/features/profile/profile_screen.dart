import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/specs/colors.dart';
import '../homepage/homepage_screen.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = GenericColors.background
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final circlePaint = Paint()
      ..color = GenericColors.primaryAccent
      ..style = PaintingStyle.fill;

    final circleRadius = size.width / 1.7;
    canvas.drawCircle(Offset(size.width / 2, -50), circleRadius, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final List<Widget> screens = [
  const Placeholder(),
  HomePage(),
  const ProfileScreen(),
];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the background transparent
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: BackgroundPainter(),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Move the GestureDetector with CircleAvatar above the Stack
                  GestureDetector(
                    onTap: () {}, // Make the picture clickable
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 200.0)), // Padding instead of SizedBox

                  // Name Input
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name", style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0), // Padding for name
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "PLACEHOLDER NAME",
                        style: GoogleFonts.candal(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Bio Input

                  // Gender Input
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Gender", style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0), // Padding for gender
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "PLACEHOLDER GENDER",
                        style: GoogleFonts.candal(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Age Input
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Age", style: TextStyle(color: Colors.black)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PLACEHOLDER AGE",
                      style: GoogleFonts.candal(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 200.0)),
                  // Padding after Age
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
