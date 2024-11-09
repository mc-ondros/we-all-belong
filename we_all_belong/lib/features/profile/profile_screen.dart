import 'package:we_all_belong/core/core_shared.dart';
import 'package:we_all_belong/features/homepage/homepage_screen.dart';
import 'package:we_all_belong/features/profile/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final List<Widget> screens = [
  const Placeholder(),
  HomePage(),
  const ProfileScreen(), // Replace with your actual screen// Replace with your actual screen
];
final ProfileController profileController = Get.put(ProfileController());

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8), // Reverted background color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'View Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7F3E8), // Reverted background color
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {}, // Make the picture clickable
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Change Profile Picture",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Name Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Name", style: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFABBA7C)), // Highlight color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Bio Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Bio", style: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  hintText: "Tell something about yourself",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFABBA7C)), // Highlight color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // Gender Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Gender", style: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  hintText: "Enter your gender",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFABBA7C)), // Highlight color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Nationality and Age Inputs
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nationality", style: TextStyle(color: Colors.black)),
                        TextField(
                          controller: TextEditingController(),
                          decoration: const InputDecoration(
                            hintText: "Enter nationality",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFABBA7C)), // Highlight color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Age", style: TextStyle(color: Colors.black)),
                        TextField(
                          controller: TextEditingController(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter age",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFABBA7C)), // Highlight color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFABBA7C), // Highlight color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
