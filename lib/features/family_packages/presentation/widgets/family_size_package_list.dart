import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_size_package_card.dart';

class FamilySizePackageList extends StatelessWidget {
  const FamilySizePackageList({
    super.key,
    required this.packages,
    required this.selectedPackageId,
    required this.onSelectPackage,
  });

  final List<FamilySizePackageEntity> packages;
  final String? selectedPackageId;
  final ValueChanged<FamilySizePackageEntity> onSelectPackage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
      itemBuilder: (context, index) {
        final package = packages[index];
        final isSelected = package.id == selectedPackageId;

        return FamilySizePackageCard(
          package: package,
          isSelected: isSelected,
          onTap: () => onSelectPackage(package),
        );
      },
    );
  }
}
