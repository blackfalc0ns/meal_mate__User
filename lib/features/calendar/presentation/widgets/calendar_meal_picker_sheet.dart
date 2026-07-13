import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarMealPickerSheet extends StatefulWidget {
  const CalendarMealPickerSheet({super.key});

  @override
  State<CalendarMealPickerSheet> createState() =>
      _CalendarMealPickerSheetState();
}

class _CalendarMealPickerSheetState extends State<CalendarMealPickerSheet> {
  static const _mealTabs = ['الإفطار', 'الغداء', 'العشاء'];
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final height = MediaQuery.sizeOf(context).height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: height,
        color: color.surface,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 221,
              child: Image.asset(
                Assets.calendarMealPickerHero,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 63,
              right: 24,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: Colors.black,
                iconSize: 24,
              ),
            ),
            Positioned(
              top: 189,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(31.2),
                ),
                child: ColoredBox(
                  color: color.surface,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 18),
                      const _SheetHandle(),
                      const SizedBox(height: 24),
                      const _RestaurantHeader(),
                      const SizedBox(height: 18),
                      const _RestaurantDescription(),
                      const SizedBox(height: 21),
                      const _SourceSection(),
                      const SizedBox(height: 16),
                      _MealTabs(
                        labels: _mealTabs,
                        selectedIndex: _selectedTab,
                        onChanged: (index) {
                          setState(() => _selectedTab = index);
                        },
                      ),
                      const SizedBox(height: 25),
                      _MealOptionsSection(mealType: _mealTabs[_selectedTab]),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 41.6,
        height: 5.2,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(104),
        ),
      ),
    );
  }
}

class _RestaurantHeader extends StatelessWidget {
  const _RestaurantHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _ProteinLogo(size: 59.9),
          const SizedBox(width: 18),
          Text(
            'اسم المطعم',
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 20.8,
              color: const Color(0xFF172B4D),
            ).copyWith(letterSpacing: 0.46),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.verified_user_rounded,
            color: AppColors.brandDeepGreen,
            size: 25,
          ),
        ],
      ),
    );
  }
}

class _RestaurantDescription extends StatelessWidget {
  const _RestaurantDescription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 31, end: 88),
      child: Text(
        'نقدم وجبات صحية عالية الجودة باستخدام مكونات طازجة\nوطبيعية لمساعدتك على تحقيق أهدافك الغذائية والرياضية.',
        textAlign: TextAlign.right,
        style: getRegularStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 12,
          color: const Color(0xFF5A5C62),
        ).copyWith(height: 20 / 12),
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 39, end: 39),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'بلد المنشأ للمكونات الأساسية',
            style: TextStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 9,
              height: 20 / 9,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SourceCard(
                icon: Icons.set_meal_rounded,
                title: 'اللحوم',
                subtitle: 'مستوردة',
                country: 'أستراليا',
              ),
              _SourceCard(
                icon: Icons.egg_alt_rounded,
                title: 'الدواجن',
                subtitle: 'طازجة محلية',
                country: 'محلي',
              ),
              _SourceCard(
                icon: Icons.phishing_rounded,
                title: 'الأسماك',
                subtitle: 'مستوردة',
                country: 'النرويج',
              ),
              _SourceCard(
                icon: Icons.energy_savings_leaf_rounded,
                title: 'الزيوت',
                subtitle: 'مستوردة',
                country: 'إسبانيا',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.country,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.8,
      height: 67,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFA),
        borderRadius: BorderRadius.circular(7.15),
        border: Border.all(color: const Color(0xFFDADADA), width: 0.45),
      ),
      child: Column(
        children: [
          Icon(icon, size: 19, color: AppColors.brandDeepGreen),
          const SizedBox(height: 1),
          Text(
            title,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8,
              color: AppColors.brandDeepGreen,
            ).copyWith(height: 1),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8,
              color: Colors.black,
            ).copyWith(height: 1),
          ),
          const Spacer(),
          Container(
            height: 13,
            constraints: const BoxConstraints(minWidth: 44.7),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD7F0D2),
              borderRadius: BorderRadius.circular(4.47),
            ),
            child: Center(
              child: Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 7.6,
                  color: Colors.black,
                ).copyWith(height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTabs extends StatelessWidget {
  const _MealTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(
              height: 1.04,
              thickness: 1.04,
              color: Color(0xFFF4F5F7),
            ),
          ),
          Positioned(
            right: 36,
            left: 36,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < labels.length; index++)
                  _TabLabel(
                    text: labels[index],
                    active: selectedIndex == index,
                    onTap: () => onChanged(index),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 36,
            left: 36,
            bottom: 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment(1 - selectedIndex.toDouble(), 0),
              child: Container(
                width: 100,
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 100,
        height: 32,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 13.52,
              color: active ? AppColors.primary : const Color(0xFF172B4D),
            ).copyWith(height: 12.48 / 13.52, letterSpacing: 0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class _MealOptionsSection extends StatelessWidget {
  const _MealOptionsSection({required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Column(
        key: ValueKey(mealType),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(mealType: mealType),
          const SizedBox(height: 20),
          const _MealOptionCard(selected: false),
          const _DividerLine(),
          const _MealOptionCard(selected: true),
          const _DividerLine(),
          const _MealOptionCard(selected: false),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36),
      child: Text(
        'وجبات $mealType',
        textAlign: TextAlign.right,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 18,
          color: const Color(0xFF172B4D),
        ),
      ),
    );
  }
}

class _MealOptionCard extends StatelessWidget {
  const _MealOptionCard({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36.4, end: 36.4),
      child: SizedBox(
        width: 317,
        height: 97,
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            _SelectButton(selected: selected),
            const SizedBox(width: 20),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 3),
                    Text(
                      'اسم الوجبة',
                      style: TextStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 16.64,
                        height: 24.96 / 16.64,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    SizedBox(height: 7),
                    _MealNutritionRow(),
                    Spacer(),
                    Text(
                      'المكونات',
                      style: TextStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 6.8,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    _MealIngredientRow(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.6),
              child: Image.asset(
                Assets.calendarMealPickerBreakfast,
                width: 88,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  const _SelectButton({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? AppColors.brandDeepGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.brandDeepGreen, width: 1.4),
      ),
      child: Icon(
        selected ? Icons.check_rounded : Icons.add_rounded,
        color: selected ? Colors.white : AppColors.brandDeepGreen,
        size: selected ? 17 : 21,
      ),
    );
  }
}

class _MealNutritionRow extends StatelessWidget {
  const _MealNutritionRow();

  @override
  Widget build(BuildContext context) {
    const items = [
      _MealNutrition(
        icon: Icons.local_fire_department_rounded,
        value: '550',
        label: 'سعرة حرارية',
      ),
      _MealNutrition(
        icon: Icons.water_drop_outlined,
        value: '35 جم',
        label: 'بروتين',
      ),
      _MealNutrition(
        icon: Icons.grass_rounded,
        value: '55 جم',
        label: 'كربوهيدرات',
      ),
      _MealNutrition(
        icon: Icons.water_drop_rounded,
        value: '18 م',
        label: 'دهون',
      ),
    ];

    return SizedBox(
      height: 22,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            items[index],
            if (index != items.length - 1)
              Container(
                width: 0.45,
                height: 18,
                color: const Color(0xFFCDCDCD),
              ),
          ],
        ],
      ),
    );
  }
}

class _MealNutrition extends StatelessWidget {
  const _MealNutrition({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: label == 'سعرة حرارية' ? 38 : 31,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.brandDeepGreen, size: 9.5),
              const SizedBox(width: 1.5),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 7,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 5.8,
              color: const Color(0xFF5A5C62),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealIngredientRow extends StatelessWidget {
  const _MealIngredientRow();

  @override
  Widget build(BuildContext context) {
    const ingredients = ['دجاج مشوي', 'أرز بني', 'بروكلي', 'جزر', 'المزيد ..'];

    return FittedBox(
      alignment: Alignment.centerRight,
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final ingredient in ingredients) ...[
            _IngredientChip(label: ingredient),
            const SizedBox(width: 3.5),
          ],
        ],
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isMore = label.contains('المزيد');

    return Container(
      margin: const EdgeInsetsDirectional.only(start: 1.5),
      height: 18,
      constraints: BoxConstraints(minWidth: isMore ? 27.7 : 31),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.13),
        border: Border.all(color: AppColors.brandDeepGreen, width: 0.42),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMore) ...[
            Icon(_iconFor(label), color: AppColors.brandDeepGreen, size: 8.5),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: isMore ? const Color(0xFF191C1D) : const Color(0xFF5A5C62),
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String label) {
    if (label.contains('دجاج')) return Icons.set_meal_rounded;
    if (label.contains('أرز')) return Icons.rice_bowl_rounded;
    if (label.contains('بروكلي')) return Icons.spa_rounded;
    return Icons.eco_rounded;
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(start: 37, end: 36),
      child: Divider(height: 20.8, thickness: 1.04, color: Color(0xFFF4F5F7)),
    );
  }
}

class _ProteinLogo extends StatelessWidget {
  const _ProteinLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'THE\nPROTEIN\nKITCHEN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: size * 0.159,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
