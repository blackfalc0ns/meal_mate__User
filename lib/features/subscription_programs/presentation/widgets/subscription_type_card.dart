import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_type_feature_item.dart';

class SubscriptionTypeCard extends StatelessWidget {
  const SubscriptionTypeCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.features,
    required this.icons,
    required this.isSelected,
    required this.onTap,
  });

  final SubscriptionTypeEntity type;
  final String title;
  final String description;
  final List<String> features;
  final List<IconData> icons;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final accentColor = type.isFamily ? color.secondary : color.primary;
    final dividerColor = type.isFamily
        ? color.outlineVariant
        : color.surface.withValues(alpha: 0.86);

    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: color.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionProgramCardRadius,
          ),
          child: SizedBox(
            height: Spacing.subscriptionTypeMobileCardHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final cardHeight = constraints.maxHeight;
                final imageWidth = cardWidth * (type.isFamily ? 0.48 : 0.45);
                final imageHeight = cardHeight * (type.isFamily ? 1.08 : 0.88);
                final imageTop = cardHeight * (type.isFamily ? -0.02 : 0.13);
                final imageEnd = cardWidth * (type.isFamily ? -0.02 : 0.01);
                final contentWidth = cardWidth * 0.57;
                final contentTop = cardHeight * 0.12;
                final featureTop = cardHeight * 0.61;
                final dividerTop = cardHeight * 0.53;

                return Container(
                  decoration: BoxDecoration(
                    color: type.isFamily
                        ? color.surface.withValues(alpha: 0.92)
                        : color.primaryContainer.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(
                      Spacing.subscriptionProgramCardRadius,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : type.isFamily
                          ? color.secondary
                          : color.primary.withValues(alpha: 0.42),
                      width: isSelected
                          ? Spacing.border + Spacing.hairline
                          : Spacing.border,
                    ),
                    gradient: type.isFamily
                        ? null
                        : LinearGradient(
                            colors: [
                              color.surface.withValues(alpha: 0.72),
                              color.primaryContainer.withValues(alpha: 0.52),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Spacing.subscriptionProgramCardRadius,
                    ),
                    child: Stack(
                      children: [
                        if (!type.isFamily)
                          Positioned(
                            right: -cardWidth * 0.03,
                            bottom: -cardHeight * 0.18,
                            child: Container(
                              width: cardWidth * 0.42,
                              height: cardHeight * 0.82,
                              decoration: BoxDecoration(
                                color: color.primary.withValues(alpha: 0.34),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(cardWidth * 0.42),
                                  bottomLeft: Radius.circular(cardWidth * 0.42),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: imageTop,
                          right: imageEnd,
                          child: Image.asset(
                            type.imageAsset,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.contain,
                            semanticLabel: locale.nav_subscription,
                          ),
                        ),
                        Positioned(
                          top: contentTop,
                          left: Spacing.lg,
                          width: contentWidth,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: Spacing.xl,
                                          height: Spacing.xl,
                                          decoration: BoxDecoration(
                                            color: type.isFamily
                                                ? color.secondaryContainer
                                                      .withValues(alpha: 0.85)
                                                : color.surface,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            type.isFamily
                                                ? Icons.groups_rounded
                                                : Icons.person_rounded,
                                            size: Spacing.iconSm,
                                            color: accentColor,
                                            semanticLabel: title,
                                          ),
                                        ),
                                        const SizedBox(width: Spacing.sm),

                                        Flexible(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: cardWidth * 0.28,
                                            ),
                                            child: Text(
                                              title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                              style: getBoldStyle(
                                                fontFamily:
                                                    FontConstant.alexandria,
                                                fontSize: FontSize.size15,
                                                color: accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: Spacing.sm),
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: cardWidth * 0.34,
                                        ),
                                        child: Text(
                                          description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size11,
                                            color: color.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: Spacing.lg,
                                height: Spacing.lg,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? accentColor
                                      : color.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? accentColor
                                        : color.onSurfaceVariant.withValues(
                                            alpha: 0.72,
                                          ),
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check_rounded,
                                        size: Spacing.iconSm,
                                        color: color.onPrimary,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: dividerTop,
                          left: Spacing.xxl,
                          width: contentWidth - Spacing.xxl,
                          child: Divider(
                            color: dividerColor,
                            height: Spacing.border,
                            thickness: Spacing.hairline,
                          ),
                        ),
                        Positioned(
                          top: featureTop,
                          left: Spacing.xl,
                          width: contentWidth - Spacing.xxl,
                          child: Row(
                            children: [
                              SubscriptionTypeFeatureItem(
                                label: features[0],
                                icon: icons[0],
                                accentColor: accentColor,
                              ),
                              SizedBox(
                                height: Spacing
                                    .subscriptionTypeMobileFeatureDividerHeight,
                                child: VerticalDivider(color: dividerColor),
                              ),
                              SubscriptionTypeFeatureItem(
                                label: features[1],
                                icon: icons[1],
                                accentColor: accentColor,
                              ),
                              SizedBox(
                                height: Spacing
                                    .subscriptionTypeMobileFeatureDividerHeight,
                                child: VerticalDivider(color: dividerColor),
                              ),
                              SubscriptionTypeFeatureItem(
                                label: features[2],
                                icon: icons[2],
                                accentColor: accentColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
