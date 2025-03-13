// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:get/get.dart';

class AnimatedProfileImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onTap;
  final bool isLoading;

  const AnimatedProfileImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profile_image',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Get.theme.colorScheme.surface,
          border: Border.all(
            color: Get.theme.colorScheme.primary,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Get.theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipOval(
              child: imageFile != null
                  ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    )
                  : imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Get.theme.colorScheme.secondary,
                        ),
            ),
            if (isLoading)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
