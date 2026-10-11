import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionProgramsPageEntity
    extends PagedEntity<SubscriptionProgramEntity> {
  const SubscriptionProgramsPageEntity({
    required super.items,
    required super.pagination,
    this.addressCoverage,
    this.hasDeliveryAddress,
  });

  final String? addressCoverage;
  final bool? hasDeliveryAddress;

  bool get isAddressRequired => hasDeliveryAddress == false;
  bool get isNoDelivery =>
      hasDeliveryAddress == true &&
      (addressCoverage == 'no_delivery' || addressCoverage == 'uncovered');
}
