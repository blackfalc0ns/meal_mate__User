import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AppImageSourceSheet extends StatelessWidget {
  const AppImageSourceSheet({
    super.key,
    this.title,
    this.cameraLabel,
    this.galleryLabel,
  });

  final String? title;
  final String? cameraLabel;
  final String? galleryLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.base,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title ?? locale.profile_photo_source_title,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            ListTile(
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
              leading: Icon(
                Icons.camera_alt_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
              title: Text(
                cameraLabel ?? locale.profile_photo_source_camera,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              leading: Icon(
                Icons.photo_library_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
              title: Text(
                galleryLabel ?? locale.profile_photo_source_gallery,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
