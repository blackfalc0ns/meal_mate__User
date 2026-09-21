import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_type_feature_item.dart';

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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textDirection = Directionality.of(context);
    final accentColor = type.isFamily ? color.secondary : color.primary;
    final isEnabled = type.isAvailable;
    final dividerColor = type.isFamily
        ? color.outlineVariant
        : color.surface.withValues(alpha: 0.86);

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: title,
      child: Material(
        color: color.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
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
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                          ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Spacing.subscriptionProgramCardRadius,
                    ),
                    child: Stack(
                      children: [
                        if (!type.isFamily)
                          PositionedDirectional(
                            end: -cardWidth * 0.03,
                            bottom: -cardHeight * 0.18,
                            child: Container(
                              width: cardWidth * 0.42,
                              height: cardHeight * 0.82,
                              decoration: BoxDecoration(
                                color: color.primary.withValues(alpha: 0.34),
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(cardWidth * 0.42),
                                  bottomStart: Radius.circular(
                                    cardWidth * 0.42,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        PositionedDirectional(
                          top: imageTop,
                          end: imageEnd,
                          child: Image.asset(
                            type.imageAsset,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.contain,
                            semanticLabel: locale.nav_subscription,
                          ),
                        ),
                        PositionedDirectional(
                          top: contentTop,
                          start: Spacing.lg,
                          width: contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                textDirection: textDirection,
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
                                  Expanded(
                                    child: Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: getBoldStyle(
                                        fontFamily:
                                            FontConstant.alexandria,
                                        fontSize: FontSize.size15,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.sm),
                              Align(
                                alignment:
                                    AlignmentDirectional.centerStart,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: cardWidth * 0.34,
                                  ),
                                  child: Text(
                                    description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
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
                        PositionedDirectional(
                          top: Spacing.base,
                          end: Spacing.base,
                          child: Container(
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
                        ),
                        PositionedDirectional(
                          top: dividerTop,
                          start: Spacing.xxl,
                          width: contentWidth - Spacing.xxl,
                          child: Divider(
                            color: dividerColor,
                            height: Spacing.border,
                            thickness: Spacing.hairline,
                          ),
                        ),
                        PositionedDirectional(
                          top: featureTop,
                          start: Spacing.xl,
                          width: contentWidth - Spacing.xxl,
                          child: Row(
                            textDirection: textDirection,
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
                        if (!isEnabled)
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color.surface.withValues(alpha: 0.56),
                                borderRadius: BorderRadius.circular(
                                  Spacing.subscriptionProgramCardRadius,
                                ),
                              ),
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
