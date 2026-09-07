import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';

class FamilyAddressesScreen extends StatefulWidget {
  const FamilyAddressesScreen({super.key});

  @override
  State<FamilyAddressesScreen> createState() => _FamilyAddressesScreenState();
}

class _FamilyAddressesScreenState extends State<FamilyAddressesScreen> {
  String? _openedMemberId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<FamilyAddressesViewModel>()..load(),
    child: BlocConsumer<FamilyAddressesViewModel, FamilyAddressesState>(
      listenWhen: (previous, current) =>
          previous.currentMember?.memberId != current.currentMember?.memberId ||
          previous.completed != current.completed ||
          previous.isLoading != current.isLoading,
      listener: _handleState,
      builder: (context, state) => const LoadingWidget.fullScreen(),
    ),
  );

  Future<void> _handleState(
    BuildContext context,
    FamilyAddressesState state,
  ) async {
    if (state.completed) {
      context.pushReplacementNamed(AppRoutes.familyPaymentSetup);
      return;
    }
    final member = state.currentMember;
    if (state.isLoading ||
        member == null ||
        _openedMemberId == member.memberId) {
      return;
    }
    _openedMemberId = member.memberId;
    final saved = await context.pushNamed(
      AppRoutes.addressChooseLocation,
      arguments: AddressChooseLocationArgs(familyMemberId: member.memberId),
    );
    if (!context.mounted) return;
    _openedMemberId = null;
    if (saved == true) {
      context.read<FamilyAddressesViewModel>().addressSaved();
    }
  }
}
