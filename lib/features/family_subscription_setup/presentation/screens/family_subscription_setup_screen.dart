import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
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

    final body =
        BlocListener<
          FamilySubscriptionSetupViewModel,
          FamilySubscriptionSetupState
        >(
          listenWhen: _shouldListenForActions,
          listener: _onActionStateChanged,
          child:
              BlocConsumer<
                FamilySubscriptionSetupViewModel,
                FamilySubscriptionSetupState
              >(
                listenWhen: _shouldListen,
                listener: _onStateChanged,
                buildWhen: (previous, current) =>
                    previous.currentFlow != current.currentFlow ||
                    previous.selectedPackage != current.selectedPackage ||
                    previous.members != current.members ||
                    previous.relationships != current.relationships ||
                    previous.isMemberSaving != current.isMemberSaving ||
                    previous.isMemberLookupLoading !=
                        current.isMemberLookupLoading ||
                    previous.memberLookup != current.memberLookup ||
                    previous.memberLookupFailure !=
                        current.memberLookupFailure ||
                    previous.memberSaveSuccess != current.memberSaveSuccess ||
                    previous.isCurrentFlowLoading !=
                        current.isCurrentFlowLoading ||
                    previous.failure != current.failure ||
                    previous.isDeletingMember != current.isDeletingMember,
                builder: _buildContent,
              ),
        );

    return BlocProvider<FamilySubscriptionSetupViewModel>(
      create: (_) {
        final vm = getIt<FamilySubscriptionSetupViewModel>();
        final selectedPackage = widget.selectedPackage;
        if (selectedPackage != null) {
          vm.doIntent(SelectFamilySizePackageEvent(selectedPackage));
        }
        vm.doIntent(const GetFamilySubscriptionCurrentEvent());
        vm.doIntent(const GetFamilyRelationshipsEvent());
        return vm;
      },
      child: isInFamilyFlow
          ? body
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
              body: SafeArea(child: body),
            ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    FamilySubscriptionSetupState state,
  ) {
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
          members: state.members,
          maxMembers: state.maxMembers,
          minMembers: state.minMembers,
          relationships: state.relationships,
          isMemberSaving: state.isMemberSaving,
          isMemberLookupLoading: state.isMemberLookupLoading,
          memberLookup: state.memberLookup,
          memberLookupFailure: state.memberLookupFailure,
          memberSaveSuccess: state.memberSaveSuccess,
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

  bool _shouldListen(
    FamilySubscriptionSetupState previous,
    FamilySubscriptionSetupState current,
  ) => previous.currentFlow != current.currentFlow;

  bool _shouldListenForActions(
    FamilySubscriptionSetupState previous,
    FamilySubscriptionSetupState current,
  ) =>
      previous.deleteMemberSuccess != current.deleteMemberSuccess ||
      previous.deleteMemberFailure != current.deleteMemberFailure ||
      previous.memberSaveSuccess != current.memberSaveSuccess ||
      previous.memberSaveFailure != current.memberSaveFailure ||
      (previous.failure != current.failure && current.currentFlow != null);

  void _onActionStateChanged(
    BuildContext context,
    FamilySubscriptionSetupState state,
  ) {
    final locale = context.localization;
    if (state.deleteMemberSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message: locale.family_delete_member_success,
      );
    } else if (state.memberSaveSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message: locale.family_add_member_success,
      );
    } else if (state.deleteMemberFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.fromFailure(
          context,
          state.deleteMemberFailure!,
        ),
      );
    } else if (state.memberSaveFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.fromFailure(
          context,
          state.memberSaveFailure!,
        ),
      );
    } else if (state.failure != null && state.currentFlow != null) {
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.fromFailure(context, state.failure!),
      );
    }
  }

  void _onStateChanged(
    BuildContext context,
    FamilySubscriptionSetupState state,
  ) {
    final locale = context.localization;
    final currentFlow = state.currentFlow;
    if (currentFlow == null) return;

    if (FamilyFlowScope.isActive(context)) {
      FamilyFlowScope.updateFamilyName(context, currentFlow.name);
    }

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
