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
    final cameraSourceLabel = cameraLabel ?? locale.profile_photo_source_camera;
    final gallerySourceLabel =
        galleryLabel ?? locale.profile_photo_source_gallery;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xl,
          vertical: Spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Spacing.searchFilterSheetHandleWidth,
              height: Spacing.searchFilterSheetHandleHeight,
              decoration: BoxDecoration(
                color: color.outlineVariant,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title ?? locale.profile_photo_source_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
              ),
            ),
            const SizedBox(height: Spacing.base),
            _buildSourceTile(
              context: context,
              icon: Icons.camera_alt_rounded,
              label: cameraSourceLabel,
              source: ImageSource.camera,
            ),
            const SizedBox(height: Spacing.sm),
            _buildSourceTile(
              context: context,
              icon: Icons.photo_library_rounded,
              label: gallerySourceLabel,
              source: ImageSource.gallery,
            ),
            const SizedBox(height: Spacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    final color = context.colorScheme;

    return Material(
      color: color.secondaryContainer,
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(source),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.base,
            vertical: Spacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: Spacing.iconLg,
                height: Spacing.iconLg,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Icon(icon, color: color.primary, size: Spacing.iconMd),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
