part of 'calendar_meal_picker_sheet.dart';

class CalendarMealOptionCard extends StatelessWidget {
  const CalendarMealOptionCard({
    super.key,
    required this.option,
    this.onTap,
    this.onDetailsTap,
  });

  final CalendarMealPickerOption option;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final blockReason = option.blockReason;
    final isBlocked = blockReason != null && blockReason.isNotEmpty;
    final showsSelectButton = onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      child: SizedBox(
        height: isBlocked
            ? Spacing.restaurantDetailsMealCardHeight + Spacing.lg
            : Spacing.restaurantDetailsMealCardHeight,
        child: Opacity(
          opacity: isBlocked ? 0.58 : 1,
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDetailsTap ?? (isBlocked ? null : onTap),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Spacing.restaurantDetailsMealImageRadius,
                  ),
                  child: option.imageUrl == null || option.imageUrl!.isEmpty
                      ? Image.asset(
                          option.imageAsset,
                          width: Spacing.restaurantDetailsMealImageSize,
                          height: Spacing.restaurantDetailsMealImageSize,
                          fit: BoxFit.cover,
                        )
                      : AppCachedNetworkImage(
                          imageUrl: option.imageUrl,
                          width: Spacing.restaurantDetailsMealImageSize,
                          height: Spacing.restaurantDetailsMealImageSize,
                          fit: BoxFit.cover,
                          semanticLabel: option.title,
                        ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDetailsTap ?? (isBlocked ? null : onTap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        option.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size16,
                          color: color.onSurface,
                        ).copyWith(height: 1.5),
                      ),
                      const SizedBox(height: Spacing.xs),
                      CalendarMealPickerNutritionRow(option: option),
                      if (isBlocked) ...[
                        const SizedBox(height: Spacing.xs),
                        Text(
                          blockReason,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.error,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: Spacing.xs),
                        child: Text(
                          locale.calendar_ingredients,
                          textAlign: TextAlign.start,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      CalendarMealIngredientRow(
                        ingredients: option.ingredients,
                      ),
                    ],
                  ),
                ),
              ),
              if (showsSelectButton) ...[
                const SizedBox(width: Spacing.lg),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isBlocked ? null : onTap,
                  child: CalendarSelectButton(
                    selected: option.selected,
                    enabled: !isBlocked,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
