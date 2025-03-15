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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailItem(
            context,
            icon: Icons.person_outline,
            title: 'Name',
            value: controller.nameController.text,
          ),
          if (controller.ageController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.cake_outlined,
              title: 'Age',
              value: '${controller.ageController.text} years',
            ),
          if (controller.nationalityController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.public,
              title: 'Nationality',
              value: controller.nationalityController.text,
            ),
          if (controller.genderController.text.isNotEmpty)
            _buildDetailItem(
              context,
              icon: Icons.people_outline,
              title: 'Gender',
              value: controller.genderController.text,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 