import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';
import 'package:we_all_belong/features/profile/widgets/user_label_builder.dart';

/// A compact widget that displays user labels in a horizontal row
/// Designed for use in smaller spaces like wall posts
class CompactUserLabelsWidget extends StatelessWidget {
  final UserProfileModel? userProfile;
  final double spacing;
  final int maxLabels;
  final double labelHeight;

  const CompactUserLabelsWidget({
    super.key,
    required this.userProfile,
    this.spacing = 4.0,
    this.maxLabels = 5,
    this.labelHeight = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final labels = UserLabelBuilder.buildLabels(userProfile);

    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }

    // Limit the number of labels to display
    final displayedLabels = labels.length > maxLabels ? labels.sublist(0, maxLabels) : labels;

    return Wrap(
      spacing: spacing,
      children: [
        ...displayedLabels.map((label) => _buildCompactLabel(context, label)),
        // Show a "+X more" chip if there are more labels than we're displaying
        if (labels.length > maxLabels)
          Container(
            height: labelHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '+${labels.length - maxLabels}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactLabel(BuildContext context, UserLabel label) {
    final color = UserLabelBuilder.getCategoryColor(label.category);

    return Container(
      height: labelHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            label.icon,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            label.label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
