part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantSearchField extends StatefulWidget {
  const CalendarRestaurantSearchField({
    super.key,
    required this.onChanged,
    this.controller,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  State<CalendarRestaurantSearchField> createState() =>
      _CalendarRestaurantSearchFieldState();
}

class _CalendarRestaurantSearchFieldState
    extends State<CalendarRestaurantSearchField> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.trim().isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
          border: Border.all(
            color: color.outlineVariant,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 14, end: 6),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: color.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  textAlign: TextAlign.start,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: locale.calendar_search_restaurant_hint,
                    hintStyle: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
              if (_hasText)
                IconButton(
                  onPressed: _clearSearch,
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 28,
                    height: 28,
                  ),
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: color.onSurface.withValues(alpha: 0.45),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

