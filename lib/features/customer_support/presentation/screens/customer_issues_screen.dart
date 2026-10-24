import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_state.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_view_model.dart';
import 'package:meal_meat_user/features/customer_support/presentation/screens/customer_issue_details_screen.dart';
import 'package:meal_meat_user/features/customer_support/presentation/widgets/customer_issue_card.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_complaints_screen.dart';

enum _IssueFilter { all, inProgress, resolved }

class CustomerIssuesScreen extends StatefulWidget {
  const CustomerIssuesScreen({super.key});

  @override
  State<CustomerIssuesScreen> createState() => _CustomerIssuesScreenState();
}

class _CustomerIssuesScreenState extends State<CustomerIssuesScreen> {
  _IssueFilter _selectedFilter = _IssueFilter.all;

  bool _isIssueResolved(CustomerIssueEntity issue) {
    final status = issue.status.toLowerCase().trim();
    return status.contains('resolved') ||
        status.contains('closed') ||
        status.contains('تم') ||
        status.contains('محلول') ||
        status.contains('مغلق');
  }

  Widget _buildTabBar(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tabs = [
      (_IssueFilter.all, locale.customer_support_filter_all),
      (_IssueFilter.inProgress, locale.customer_support_filter_in_progress),
      (_IssueFilter.resolved, locale.customer_support_filter_resolved),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(
          bottom: BorderSide(
            color: color.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedFilter == tab.$1;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = tab.$1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tab.$2,
                      style: isSelected
                          ? getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.primary,
                            )
                          : getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurfaceVariant,
                            ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2.5,
                      width: isSelected ? 40 : 0,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.primary
                            : color.surface.withValues(alpha: 0),
                        borderRadius: BorderRadius.circular(Spacing.radiusXs),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    final color = context.colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.screenH),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
      itemBuilder: (_, _) => ShimmerWidget(
        child: Container(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: Spacing.avatarSm,
                    height: Spacing.avatarSm,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 14,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusXs),
                          ),
                        ),
                        const SizedBox(height: Spacing.xxs),
                        Container(
                          width: 80,
                          height: 11,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusXs),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Container(
                    width: 65,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 18,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.radiusXs),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Divider(
                height: 1,
                color: color.outlineVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.radiusXs),
                    ),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<CustomerSupportViewModel>(
      create: (_) {
        final viewModel = getIt<CustomerSupportViewModel>();
        unawaited(viewModel.loadIssues());
        return viewModel;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: locale.profile_support_complaints_title,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (scaffoldContext) {
            return FloatingActionButton.extended(
              onPressed: () async {
                final viewModel =
                    scaffoldContext.read<CustomerSupportViewModel>();
                await Navigator.of(scaffoldContext).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileComplaintsScreen(),
                  ),
                );
                unawaited(viewModel.loadIssues());
              },
              backgroundColor: color.primary,
              foregroundColor: color.onPrimary,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                locale.customer_support_new_general_issue,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onPrimary,
                ),
              ),
            );
          },
        ),
        body: BlocBuilder<CustomerSupportViewModel, CustomerSupportState>(
          buildWhen: (previous, current) =>
              previous.issues != current.issues ||
              previous.loading != current.loading ||
              previous.errorMessage != current.errorMessage,
          builder: (context, state) {
            if (state.loading && state.issues.isEmpty) {
              return _buildShimmerList(context);
            }

            if (state.errorMessage != null && state.issues.isEmpty) {
              return Center(
                child: TextButton(
                  onPressed: () =>
                      context.read<CustomerSupportViewModel>().loadIssues(),
                  child: Text(locale.customer_support_retry),
                ),
              );
            }

            if (state.issues.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Spacing.avatarLg,
                        height: Spacing.avatarLg,
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: Spacing.iconLg,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.base),
                      Text(
                        locale.customer_support_no_issues,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size15,
                          color: color.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.customer_support_no_issues_subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final allIssues = state.issues;
            final resolvedIssues = allIssues.where(_isIssueResolved).toList();
            final inProgressIssues = allIssues.where((i) => !_isIssueResolved(i)).toList();

            final displayedIssues = switch (_selectedFilter) {
              _IssueFilter.all => allIssues,
              _IssueFilter.inProgress => inProgressIssues,
              _IssueFilter.resolved => resolvedIssues,
            };

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<CustomerSupportViewModel>().loadIssues(),
              child: Column(
                children: [
                  _buildTabBar(context),
                  Expanded(
                    child: displayedIssues.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(Spacing.xl),
                              child: Text(
                                locale.customer_support_no_issues,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.screenH,
                            ).copyWith(
                              top: Spacing.md,
                              bottom: Spacing.xxxl * 2.5,
                            ),
                            itemCount: displayedIssues.length +
                                (state.issues.length < state.issuesTotal &&
                                        _selectedFilter == _IssueFilter.all
                                    ? 1
                                    : 0),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: Spacing.md),
                            itemBuilder: (context, index) {
                              if (index == displayedIssues.length) {
                                return TextButton(
                                  onPressed: state.loading
                                      ? null
                                      : () => context
                                            .read<CustomerSupportViewModel>()
                                            .loadIssues(next: true),
                                  child:
                                      Text(locale.customer_support_load_more),
                                );
                              }
                              final issue = displayedIssues[index];
                              return CustomerIssueCard(
                                issue: issue,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => CustomerIssueDetailsScreen(
                                      caseId: issue.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
