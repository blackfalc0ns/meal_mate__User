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
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_add_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_list_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_search_field.dart';

class FamilySubscriptionMembersScreen extends StatefulWidget {
  const FamilySubscriptionMembersScreen({super.key});
  @override
  State<FamilySubscriptionMembersScreen> createState() =>
      _FamilySubscriptionMembersScreenState();
}

class _FamilySubscriptionMembersScreenState
    extends State<FamilySubscriptionMembersScreen> {
  late final FamilyManagementViewModel _viewModel;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FamilyManagementViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _viewModel.doIntent(
      LoadFamilyMembersEvent(context.localization.localeName),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyManagementViewModel, FamilyManagementState>(
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
            child: state.isLoading && state.members.isEmpty
                ? const FamilyMembersLoadingSkeleton()
                : RefreshIndicator(
                    color: color.primary,
                    onRefresh: () async {
                      _viewModel.doIntent(
                        LoadFamilyMembersEvent(locale.localeName),
                      );
                      await _viewModel.stream.firstWhere(
                        (next) => !next.isLoading,
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
                          int index = 0;
                          index < state.filteredMembers.length;
                          index++
                        )
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: index == state.filteredMembers.length - 1
                                  ? Spacing.zero
                                  : Spacing.familyMembersCardGap,
                            ),
                            child: FamilyMembersListCard(
                              member: state.filteredMembers[index],
                              onTap: () async {
                                await context.pushNamed(
                                  AppRoutes.familySubscriptionMemberDetails,
                                  arguments: state.filteredMembers[index],
                                );
                                if (!mounted) return;
                                _viewModel.doIntent(
                                  LoadFamilyMembersEvent(locale.localeName),
                                );
                              },
                            ),
                          ),
                        const SizedBox(
                          height: Spacing.familyMembersAddButtonTopGap,
                        ),
                        FamilyMembersAddButton(
                          onPressed: () => context.pushNamed(
                            AppRoutes.familySubscriptionSetup,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
