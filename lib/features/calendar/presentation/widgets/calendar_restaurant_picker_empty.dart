part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantPickerEmpty extends StatelessWidget {
  const CalendarRestaurantPickerEmpty({
    super.key,
    this.onClear,
  });

  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsFake.searchEmptyResults,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.search_empty_title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.search_empty_description,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurfaceVariant,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(height: Spacing.base),
              TextButton(
                onPressed: onClear,
                child: Text(
                  locale.search_empty_clear,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.primary,
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
