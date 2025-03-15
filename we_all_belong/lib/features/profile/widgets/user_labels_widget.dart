import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';
import 'package:we_all_belong/features/profile/widgets/user_label_builder.dart';

/// A widget that displays user labels in a visually appealing way
class UserLabelsWidget extends StatelessWidget {
  final UserProfileModel? userProfile;
  final double spacing;
  final double runSpacing;

  const UserLabelsWidget({
    super.key,
    required this.userProfile,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final labels = UserLabelBuilder.buildLabels(userProfile);

    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: labels.map((label) => _buildLabelChip(context, label)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelChip(BuildContext context, UserLabel label) {
    final color = UserLabelBuilder.getCategoryColor(label.category);
    
    return Chip(
      avatar: Icon(
        label.icon, 
        color: Colors.white,
        size: 16,
      ),
      label: Text(
        label.label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
} 