import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/features/kyc/controller/kyc_controller.dart';

class KYCScreen extends StatelessWidget {
  final KYCController controller = Get.put(KYCController());

  KYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tell Us More About YOU',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Nationality Field
                TextField(
                  onChanged: (value) => controller.nationality.value = value,
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Religious Orientation Field
                TextField(
                  onChanged: (value) => 
                      controller.religiousOrientation.value = value,
                  decoration: InputDecoration(
                    labelText: 'Religious Orientation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Sexual Preferences Field
                TextField(
                  onChanged: (value) => 
                      controller.sexualPreference.value = value,
                  decoration: InputDecoration(
                    labelText: 'Sexual Preferences',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Disabilities',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                Wrap(
                  spacing: 8,
                  children: controller.availableDisabilities
                      .map((disability) => Obx(() {
                            final isSelected = controller.disabilities
                                .contains(disability);
                            return FilterChip(
                              label: Text(disability),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  controller.disabilities.add(disability);
                                } else {
                                  controller.disabilities
                                      .remove(disability);
                                }
                              },
                            );
                          }))
                      .toList(),
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.submitKYCData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 