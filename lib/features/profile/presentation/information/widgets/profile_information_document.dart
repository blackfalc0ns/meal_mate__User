import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_information_document_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/information/widgets/profile_information_section.dart';

class ProfileInformationDocument extends StatelessWidget {
  const ProfileInformationDocument({super.key, required this.document});

  final ProfileInformationDocumentEntity document;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.cardPadding),
          decoration: BoxDecoration(
            color: color.secondaryContainer,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(color: color.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: Spacing.iconMd,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  locale.profile_legal_demo_notice,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
        ...document.sections.map(
          (section) => ProfileInformationSection(
            key: ValueKey(section.id),
            title: section.title(locale),
            body: section.body(locale),
          ),
        ),
      ],
    );
  }
}
