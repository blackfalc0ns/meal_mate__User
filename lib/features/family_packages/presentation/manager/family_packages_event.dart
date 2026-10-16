import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

sealed class FamilyPackagesEvent {
  const FamilyPackagesEvent();
}

class GetFamilySizePackagesEvent extends FamilyPackagesEvent {
  const GetFamilySizePackagesEvent();
}

class SelectFamilySizePackageEvent extends FamilyPackagesEvent {
  const SelectFamilySizePackageEvent(this.package);

  final FamilySizePackageEntity package;
}
