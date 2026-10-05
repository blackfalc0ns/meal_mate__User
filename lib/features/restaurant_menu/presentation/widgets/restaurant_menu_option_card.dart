part of 'restaurant_menu_view.dart';

class RestaurantMenuOptionCard extends StatelessWidget {
  const RestaurantMenuOptionCard({
    super.key,
    required this.option,
    this.onTap,
    this.onDetailsTap,
    this.selectionControlBuilder,
  });

  final RestaurantMenuOption option;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;
  final Widget Function(BuildContext context, RestaurantMenuOption option)?
  selectionControlBuilder;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final blockReason = option.blockReason;
    final isBlocked = blockReason != null && blockReason.isNotEmpty;
    final showsSelectButton = onTap != null || selectionControlBuilder != null;
    const cardHeight = Spacing.restaurantDetailsMealCardHeight + Spacing.md;

    return SizedBox(
      height: isBlocked ? cardHeight + Spacing.lg : cardHeight,
      child: Opacity(
        opacity: isBlocked ? 0.58 : 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDetailsTap ?? (isBlocked ? null : onTap),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Spacing.restaurantDetailsMealImageRadius,
                ),
                child: (option.imageUrl != null && option.imageUrl!.isNotEmpty)
                    ? AppCachedNetworkImage(
                        imageUrl: option.imageUrl,
                        width: Spacing.restaurantDetailsMealImageSize,
                        height: Spacing.restaurantDetailsMealImageSize,
                        fit: BoxFit.cover,
                        semanticLabel: option.title,
                      )
                    : option.imageAsset.isNotEmpty
                    ? Image.asset(
                        option.imageAsset,
                        width: Spacing.restaurantDetailsMealImageSize,
                        height: Spacing.restaurantDetailsMealImageSize,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        width: Spacing.restaurantDetailsMealImageSize,
                        height: Spacing.restaurantDetailsMealImageSize,
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
                    RestaurantMenuNutritionRow(option: option),
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
                    RestaurantMenuIngredientRow(
                      ingredients: option.ingredients,
                    ),
                  ],
                ),
              ),
            ),
            if (showsSelectButton) ...[
              const SizedBox(width: Spacing.lg),
              SizedBox(
                height: Spacing.restaurantDetailsMealImageSize,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isBlocked ? null : onTap,
                    child: selectionControlBuilder != null
                        ? selectionControlBuilder!(context, option)
                        : RestaurantMenuSelectButton(
                            selected: option.selected,
                            enabled: !isBlocked,
                          ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
