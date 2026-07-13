part of 'calendar_meal_picker_sheet.dart';

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Center(
      child: Container(
        width: 41.6,
        height: 5.2,
        decoration: BoxDecoration(
          color: color.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(104),
        ),
      ),
    );
  }
}
