import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = ((constraints.maxWidth - 24) / categories.length)
            .clamp(68.0, 80.0)
            .toDouble();

        return SizedBox(
          height: 124,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < categories.length; index++)
                  SizedBox(
                    width: itemWidth,
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
      },
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
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 124,
        child: selected
            ? _SelectedCategoryContent(category: category)
            : _UnselectedCategoryContent(category: category),
      ),
    );
  }
}

class _SelectedCategoryContent extends StatelessWidget {
  const _SelectedCategoryContent({required this.category});

  final HomeCategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 30,
          child: Container(
            width: 76,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFF4CB86F),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 28,
                left: 6,
                right: 6,
                bottom: 8,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 78,
            height: 78,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CB86F),
                width: 3,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  category.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UnselectedCategoryContent extends StatelessWidget {
  const _UnselectedCategoryContent({required this.category});

  final HomeCategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 68,
          height: 68,
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F4),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              category.imageAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          category.title,
          textAlign: TextAlign.center,
          style: getMediumStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size13,
            color: const Color(0xFF7A6258),
          ),
        ),
      ],
    );
  }
}
