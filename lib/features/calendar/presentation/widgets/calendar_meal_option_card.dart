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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      child: SizedBox(
        width: 317,
        height: isBlocked ? 126 : 105,
        child: Opacity(
          opacity: isBlocked ? 0.58 : 1,
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isBlocked ? null : onTap,
                child: CalendarSelectButton(
                  selected: option.selected,
                  enabled: !isBlocked,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDetailsTap ?? (isBlocked ? null : onTap),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          option.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size15,
                            color: color.onSurface,
                          ).copyWith(height: 24.96 / 16.64),
                        ),
                        const SizedBox(height: 7),
                        CalendarMealPickerNutritionRow(option: option),
                        if (isBlocked) ...[
                          const SizedBox(height: Spacing.xs),
                          Text(
                            blockReason,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
              ),
              const SizedBox(width: Spacing.xss),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDetailsTap ?? (isBlocked ? null : onTap),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.6),
                  child: option.imageUrl == null || option.imageUrl!.isEmpty
                      ? Image.asset(
                          option.imageAsset,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                        )
                      : AppCachedNetworkImage(
                          imageUrl: option.imageUrl,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          semanticLabel: option.title,
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
