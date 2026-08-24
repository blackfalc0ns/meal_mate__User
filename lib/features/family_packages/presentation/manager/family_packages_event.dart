import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySizePackagesEvent extends FamilyPlanEvent {
  const GetFamilySizePackagesEvent();
}

class SelectFamilySizePackageEvent extends FamilyPlanEvent {
  const SelectFamilySizePackageEvent(this.package);

  final FamilySizePackageEntity package;
}
