import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_subscription_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilySubscriptionSetupScreen extends StatefulWidget {
  const FamilySubscriptionSetupScreen({super.key, this.selectedPackage});

  final FamilySizePackageEntity? selectedPackage;

  @override
  State<FamilySubscriptionSetupScreen> createState() =>
      _FamilySubscriptionSetupScreenState();
}

class _FamilySubscriptionSetupScreenState
    extends State<FamilySubscriptionSetupScreen> {
  late final TextEditingController _familyNameController;
  bool _didSyncInitialPackage = false;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  void _onSaveFamilyName(BuildContext context) {
    final name = _familyNameController.text.trim();
    if (name.isEmpty) return;

    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      UpdateFamilyGroupEvent(
        name: name,
        familyPackageId: widget.selectedPackage?.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilySubscriptionSetupViewModel>(
      create: (_) {
        final vm = getIt<FamilySubscriptionSetupViewModel>();
        final selectedPackage = widget.selectedPackage;
        if (selectedPackage != null) {
          vm.doIntent(SelectFamilySizePackageEvent(selectedPackage));
        }
        vm.doIntent(const GetFamilySubscriptionCurrentEvent());
        vm.doIntent(const GetFamilyRelationshipsEvent());
        vm.doIntent(const GetFamilyAddressesEvent());
        return vm;
      },
      child: isInFamilyFlow
          ? BlocListener<FamilySubscriptionSetupViewModel, FamilyPlanState>(
              listenWhen: _shouldListenForDelete,
              listener: _onDeleteStateChanged,
              child:
                  BlocConsumer<
                    FamilySubscriptionSetupViewModel,
                    FamilyPlanState
                  >(
                    listenWhen: _shouldListen,
                    listener: _onStateChanged,
                    builder: _buildContent,
                  ),
            )
          : Scaffold(
              appBar: CustomAppBar(
                showBackButton: true,
                titleWidget: Column(
                  children: [
                    Text(
                      locale.family_setup_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_setup_subtitle,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child:
                    BlocListener<
                      FamilySubscriptionSetupViewModel,
                      FamilyPlanState
                    >(
                      listenWhen: _shouldListenForDelete,
                      listener: _onDeleteStateChanged,
                      child:
                          BlocConsumer<
                            FamilySubscriptionSetupViewModel,
                            FamilyPlanState
                          >(
                            listenWhen: _shouldListen,
                            listener: _onStateChanged,
                            builder: _buildContent,
                          ),
                    ),
              ),
            ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyPlanState state) {
    if (state.isCurrentFlowLoading && state.currentFlow == null) {
      return const FamilySubscriptionSetupLoadingSkeleton();
    }

    if (state.failure != null && state.currentFlow == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context
            .read<FamilySubscriptionSetupViewModel>()
            .doIntent(const GetFamilySubscriptionCurrentEvent()),
      );
    }

    final color = context.colorScheme;
    return Stack(
      children: [
        FamilySubscriptionSetupContent(
          state: state,
          familyNameController: _familyNameController,
          onSaveFamilyName: () => _onSaveFamilyName(context),
        ),
        if (state.isDeletingMember)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.2),
                child: const CustomProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  bool _shouldListen(FamilyPlanState previous, FamilyPlanState current) =>
      previous.currentFlow != current.currentFlow;

  bool _shouldListenForDelete(
    FamilyPlanState previous,
    FamilyPlanState current,
  ) =>
      previous.deleteMemberSuccess != current.deleteMemberSuccess ||
      previous.deleteMemberFailure != current.deleteMemberFailure;

  void _onDeleteStateChanged(BuildContext context, FamilyPlanState state) {
    final locale = context.localization;
    if (state.deleteMemberSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message: locale.family_delete_member_success,
      );
    } else if (state.deleteMemberFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.deleteMemberFailure!.errorMessage,
      );
    }
  }

  void _onStateChanged(BuildContext context, FamilyPlanState state) {
    final locale = context.localization;
    final currentFlow = state.currentFlow;
    if (currentFlow == null) return;

    if (_familyNameController.text.isEmpty &&
        currentFlow.name != null &&
        currentFlow.name!.isNotEmpty) {
      _familyNameController.text = currentFlow.name!;
    }

    final selectedPackage = widget.selectedPackage;
    if (_didSyncInitialPackage ||
        selectedPackage == null ||
        currentFlow.selectedFamilyPackageId == selectedPackage.id) {
      return;
    }

    _didSyncInitialPackage = true;
    final currentName = _familyNameController.text.isNotEmpty
        ? _familyNameController.text
        : (currentFlow.name ?? locale.family_name_hint);
    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      UpdateFamilyGroupEvent(
        name: currentName,
        familyPackageId: selectedPackage.id,
      ),
    );
  }
}
