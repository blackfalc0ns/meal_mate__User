import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

class FamilyPackagesState {
  const FamilyPackagesState({
    this.isPackagesLoading = false,
    this.packages = const [],
    this.selectedPackage,
    this.failure,
  });

  final bool isPackagesLoading;
  final List<FamilySizePackageEntity> packages;
  final FamilySizePackageEntity? selectedPackage;
  final Failure? failure;

  FamilyPackagesState copyWith({
    bool? isPackagesLoading,
    List<FamilySizePackageEntity>? packages,
    FamilySizePackageEntity? selectedPackage,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FamilyPackagesState(
      isPackagesLoading: isPackagesLoading ?? this.isPackagesLoading,
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
