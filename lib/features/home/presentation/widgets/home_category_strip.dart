import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeCategoryStrip extends StatelessWidget {
  const HomeCategoryStrip({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<HomeCategoryEntity> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 103,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var index = 0; index < categories.length; index++)
              SizedBox(
                width: 61.21,
                child: _CategoryItem(
                  category: categories[index],
                  selected: index == selectedIndex,
                  onTap: () => onCategorySelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final HomeCategoryEntity category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: selected
            ? _SelectedCategoryContent(
                key: ValueKey('selected-${category.title}'),
                category: category,
              )
            : _UnselectedCategoryContent(
                key: ValueKey('normal-${category.title}'),
                category: category,
              ),
      ),
    );
  }
}

class _SelectedCategoryContent extends StatelessWidget {
  const _SelectedCategoryContent({super.key, required this.category});

  final HomeCategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Container(
        width: 61.21,
        height: 91.82,
        padding: const EdgeInsets.all(3.82),
        decoration: BoxDecoration(
          color: const Color(0xFF48AD75),
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 5.74,
              offset: Offset(0, 3.82),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CategoryImage(
              imageAsset: category.imageAsset,
              size: 53.56,
              borderColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 7.65),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnselectedCategoryContent extends StatelessWidget {
  const _UnselectedCategoryContent({super.key, required this.category});

  final HomeCategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CategoryImage(imageAsset: category.imageAsset, size: 61.21),
          const SizedBox(height: 7),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 11.48,
              color: const Color(0xFF59413D),
            ).copyWith(height: 1.33),
          ),
        ],
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({
    required this.imageAsset,
    required this.size,
    this.borderColor,
  });

  final String imageAsset;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        shape: BoxShape.circle,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      child: ClipOval(child: Image.asset(imageAsset, fit: BoxFit.cover)),
    );
  }
}
