import 'package:flutter/material.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';

/// A class that builds user labels based on their profile data
class UserLabelBuilder {
  /// Builds a list of user labels from a UserProfileModel
  static List<UserLabel> buildLabels(UserProfileModel? profile) {
    if (profile == null) {
      return [];
    }

    final List<UserLabel> labels = [];

    // Add nationality if available
    if (profile.nationality != null && profile.nationality!.isNotEmpty) {
      labels.add(UserLabel(
        label: profile.nationality!,
        icon: Icons.public,
        category: LabelCategory.nationality,
      ));
    }

    // Add gender if available
    if (profile.gender != null && profile.gender!.isNotEmpty) {
      labels.add(UserLabel(
        label: profile.gender!,
        icon: Icons.people_outline,
        category: LabelCategory.gender,
      ));
    }

    // Add religious orientation if available
    if (profile.religiousOrientation != null && profile.religiousOrientation!.isNotEmpty) {
      labels.add(UserLabel(
        label: profile.religiousOrientation!,
        icon: Icons.church_outlined,
        category: LabelCategory.religiousOrientation,
      ));
    }

    // Add sexual preference if available
    if (profile.sexualPreference != null && profile.sexualPreference!.isNotEmpty) {
      labels.add(UserLabel(
        label: profile.sexualPreference!,
        icon: Icons.favorite_outline,
        category: LabelCategory.sexualPreference,
      ));
    }

    // Add disabilities if available
    if (profile.disabilities != null && profile.disabilities!.isNotEmpty) {
      for (final disability in profile.disabilities!) {
        labels.add(UserLabel(
          label: disability,
          icon: Icons.accessibility_new_outlined,
          category: LabelCategory.disability,
        ));
      }
    }

    return labels;
  }

  /// Gets the color for a label category
  static Color getCategoryColor(LabelCategory category) {
    switch (category) {
      case LabelCategory.nationality:
        return Colors.blue;
      case LabelCategory.gender:
        return Colors.purple;
      case LabelCategory.religiousOrientation:
        return Colors.amber;
      case LabelCategory.sexualPreference:
        return Colors.pink;
      case LabelCategory.disability:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

/// Represents a user label with its category and display properties
class UserLabel {
  final String label;
  final IconData icon;
  final LabelCategory category;

  UserLabel({
    required this.label,
    required this.icon,
    required this.category,
  });
}

/// Enum representing different categories of user labels
enum LabelCategory {
  nationality,
  gender,
  religiousOrientation,
  sexualPreference,
  disability,
} 