import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/features/profile/controller/profile_controller.dart';
import 'package:we_all_belong/features/profile/screens/edit_profile_screen.dart';
import 'package:we_all_belong/features/profile/widgets/animated_profile_image.dart';
import 'package:we_all_belong/features/profile/widgets/user_labels_widget.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
            onPressed: () => Get.to(() => EditProfileScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: AnimatedProfileImage(
                  imageUrl: controller.profileImageUrl.value,
                  imageFile: controller.profileImage.value,
                  onTap: controller.pickImage,
                  isLoading: controller.isLoading.value,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                controller.nameController.text,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (controller.bioController.text.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    controller.bioController.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // User labels widget
              UserLabelsWidget(
                userProfile: controller.userProfile.value,
                spacing: 10,
                runSpacing: 10,
              ),
              const SizedBox(height: 32),
              _buildProfileDetails(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    // Debug print to check values
    debugPrint('Name: ${controller.nameController.text}');
    debugPrint('Age: ${controller.ageController.text}');
    debugPrint('Nationality: ${controller.nationalityController.text}');
    debugPrint('Gender: ${controller.genderController.text}');
    debugPrint('Pronouns: ${controller.pronounsController.text}');
    debugPrint('Disabilities: ${controller.disabilities}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          _buildDetailItem(
            context,
            icon: Icons.person_outline,
            value: controller.nameController.text.isEmpty ? 'Add your name' : controller.nameController.text,
          ),
          if (controller.ageController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.cake_outlined,
              value: '${controller.ageController.text} years',
            ),
          if (controller.nationalityController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.public,
              value: controller.nationalityController.text,
            ),
          if (controller.genderController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.people_outline,
              value: controller.genderController.text,
            ),
          if (controller.pronounsController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.person_outline,
              value: controller.pronounsController.text,
            ),
          // Display disabilities if any
          if (controller.disabilities.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.accessible_outlined,
              value: controller.disabilities.join(', '),
            ),
          // Fallback if no details are available
          if (controller.nameController.text.isEmpty &&
              controller.ageController.text.isEmpty &&
              controller.nationalityController.text.isEmpty &&
              controller.genderController.text.isEmpty &&
              controller.pronounsController.text.isEmpty &&
              controller.disabilities.isEmpty)
            Text(
              'No profile details available. Tap the edit button to add your information.',
              style: GoogleFonts.jost(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: GoogleFonts.jost(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
