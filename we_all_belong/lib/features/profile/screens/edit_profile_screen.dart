import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/features/profile/controller/profile_controller.dart';
import 'package:we_all_belong/features/profile/widgets/logout_button.dart';
import 'package:we_all_belong/features/profile/widgets/animated_profile_image.dart';
import 'package:we_all_belong/features/profile/widgets/user_labels_widget.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.secondary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedProfileImage(
                imageUrl: controller.profileImageUrl.value,
                imageFile: controller.profileImage.value,
                onTap: controller.pickImage,
                isLoading: controller.isLoading.value,
              ),
              const SizedBox(height: 16),
              Obx(() => UserLabelsWidget(
                    userProfile: controller.userProfile.value,
                  )),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextField(
          label: 'Name',
          controller: controller.nameController,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Bio',
          controller: controller.bioController,
          icon: Icons.description_outlined,
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Gender',
          controller: controller.genderController,
          icon: Icons.people_outline,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: _buildTextField(
            label: 'Pronouns',
            controller: controller.pronounsController,
            icon: Icons.wifi_protected_setup,
          ),
        ),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                label: 'Nationality',
                controller: controller.nationalityController,
                icon: Icons.public,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Age',
                controller: controller.ageController,
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Dietary Preferences
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dietary Preferences',
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                    children: [
                      Center(
                        child: CheckboxListTile(
                          title: const Text('Vegan'),
                          value: controller.isVegan.value,
                          onChanged: (value) => controller.isVegan.value = value ?? false,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                      ),
                      Center(
                        child: CheckboxListTile(
                          title: const Text('Halal'),
                          value: controller.isHalal.value,
                          onChanged: (value) => controller.isHalal.value = value ?? false,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                      ),
                      Center(
                        child: CheckboxListTile(
                          title: const Text('Kosher'),
                          value: controller.isKosher.value,
                          onChanged: (value) => controller.isKosher.value = value ?? false,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Disabilities Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disabilities',
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    children: controller.availableDisabilities.map((disability) {
                      final isSelected = controller.disabilities.contains(disability);
                      return FilterChip(
                        label: Text(disability),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.disabilities.add(disability);
                          } else {
                            controller.disabilities.remove(disability);
                          }
                        },
                        selectedColor: Colors.blue[100],
                        checkmarkColor: Colors.blue[800],
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.jost(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16), // Add spacing between buttons

        // Logout Button
        const LogoutButton(),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.black,
          labelText: label,
          labelStyle: GoogleFonts.jost(
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }
}
