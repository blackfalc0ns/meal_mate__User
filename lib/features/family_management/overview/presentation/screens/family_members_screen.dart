import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/manager/family_overview_event.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/manager/family_overview_state.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/manager/family_overview_view_model.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_management_entity.dart'
    as ui_mgmt;
import 'package:meal_meat_user/features/family_management/overview/presentation/widgets/family_members_add_button.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/widgets/family_members_list_card.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/widgets/family_members_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/widgets/family_members_search_field.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  late final FamilyOverviewViewModel _viewModel;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt.isRegistered<FamilyOverviewViewModel>()
        ? getIt<FamilyOverviewViewModel>()
        : FamilyOverviewViewModel(getIt(), getIt());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    if (getIt.isRegistered<FamilyContextViewModel>() &&
        getIt<FamilyContextViewModel>().state.contexts.isEmpty) {
      getIt<FamilyContextViewModel>().loadFamilyContext();
    }
    _viewModel.doIntent(
      LoadFamilyMembersEvent(locale: context.localization.localeName),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  bool _isViewerManager() {
    if (getIt.isRegistered<FamilyContextViewModel>()) {
      final state = getIt<FamilyContextViewModel>().state;
      if (state.contexts.isNotEmpty) {
        return state.hasManagerContext;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isViewerManager = _isViewerManager();

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyOverviewViewModel, FamilyOverviewState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) => CustomSnackbar.showError(
          context: context,
          message: ErrorMessagePresenter.fromFailure(context, state.failure!),
        ),
        builder: (context, state) => Scaffold(
          backgroundColor: color.surface,
          extendBody: true,
          appBar: CustomAppBar(
            title: locale.family_members_title,
            titleFontSize: FontSize.size15,
            backgroundColor: color.surface,
            showShadow: false,
          ),
          body: SafeArea(
            top: false,
            child: state.isLoadingMembers && state.members.isEmpty
                ? const FamilyMembersLoadingSkeleton()
                : RefreshIndicator(
                    color: color.primary,
                    onRefresh: () async {
                      _viewModel.doIntent(
                        LoadFamilyMembersEvent(locale: locale.localeName),
                      );
                      await _viewModel.stream.firstWhere(
                        (next) => !next.isLoadingMembers,
                      );
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.familyMembersHorizontalPadding,
                        end: Spacing.familyMembersHorizontalPadding,
                        bottom:
                            Spacing.bottomNavHeight +
                            Spacing.familyMembersBottomNavTopGap,
                      ),
                      children: [
                        const SizedBox(
                          height: Spacing.familyMembersSearchTopGap,
                        ),
                        FamilyMembersSearchField(
                          onChanged: (query) => _viewModel.doIntent(
                            SearchFamilyMembersEvent(query),
                          ),
                        ),
                        const SizedBox(height: Spacing.familyMembersListTopGap),
                        for (
                          int i = 0;
                          i < state.filteredMembers.length;
                          i++
                        ) ...[
                          if (i > 0)
                            const SizedBox(
                              height: Spacing.familyMembersCardGap,
                            ),
                          _buildMemberCard(context, state.filteredMembers[i]),
                        ],
                        if (isViewerManager) ...[
                          const SizedBox(
                            height: Spacing.familyMembersAddButtonTopGap,
                          ),
                          FamilyMembersAddButton(
                            onPressed: () => context.pushNamed(
                              AppRoutes.familySubscriptionSetup,
                            ),
                          ),
                        ],
                        const SizedBox(height: Spacing.md),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    FamilyMemberSummaryEntity member,
  ) {
    final uiMember = ui_mgmt.FamilyMemberSummaryEntity(
      memberId: member.memberId,
      displayName: member.displayName,
      role: member.isManager ? 1 : 2,
      ageYears: member.ageYears,
      isPaused: member.isPaused,
      subscriptionId: member.effectiveSubscriptionId,
      programName: member.programName,
      remainingDays: member.remainingDays,
      setupStatus: member.hasPlan ? 1 : 0,
      todayFilledCount: member.todayFilledCount,
      todayRequiredCount: member.todayRequiredCount,
      todayUiStatus: member.todayUiStatus,
      isPaidPreparing: member.isPaidPreparingCalendar,
      isDetached: member.isDetached,
      isDisabled: member.isDisabled,
      isSetupRequired: member.isSetupRequired,
    );

    return FamilyMembersListCard(
      member: uiMember,
      onTap: () async {
        final localeName = context.localization.localeName;
        await context.pushNamed(
          AppRoutes.familySubscriptionMemberDetails,
          arguments: member,
        );
        if (!mounted) return;
        _viewModel.doIntent(LoadFamilyMembersEvent(locale: localeName));
      },
    );
  }
}
