import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_map_view.dart';

class FamilyAddressMapSection extends StatelessWidget {
  const FamilyAddressMapSection({
    super.key,
    required this.memberId,
    required this.flowController,
    this.initialAddress,
  });

  final String memberId;
  final AddressEntryFlowController flowController;
  final CustomerAddressEntity? initialAddress;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddressEditorViewModel,
      AddressEditorState,
      ({LocationsCatalogState locations, bool isSubmitting})
    >(
      selector: (state) =>
          (locations: state.locations, isSubmitting: state.action.isLoading),
      builder: (context, mapData) {
        return AddressChooseLocationMapView(
          key: ValueKey(memberId),
          locations: mapData.locations,
          flowController: flowController,
          initialAddress: initialAddress,
          showInitialAddressDetails: false,
          isSubmitting: mapData.isSubmitting,
        );
      },
    );
  }
}
