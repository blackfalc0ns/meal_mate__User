import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_state.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_view_model.dart';

class CustomerIssueDetailsScreen extends StatefulWidget {
  const CustomerIssueDetailsScreen({super.key, required this.caseId});
  final String caseId;

  @override
  State<CustomerIssueDetailsScreen> createState() =>
      _CustomerIssueDetailsScreenState();
}

class _CustomerIssueDetailsScreenState
    extends State<CustomerIssueDetailsScreen> {
  final _reply = TextEditingController();

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  (String label, Color color, IconData icon) _resolveStatus(
    BuildContext context,
    String rawStatus,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final status = rawStatus.toLowerCase().trim();

    if (status.contains('resolved') ||
        status.contains('تم') ||
        status.contains('محلول')) {
      return (
        locale.customer_support_status_resolved,
        color.primary,
        Icons.check_circle_rounded,
      );
    }
    if (status.contains('inprogress') ||
        status.contains('in_progress') ||
        status.contains('pending') ||
        status.contains('معالجة')) {
      return (
        locale.customer_support_status_in_progress,
        color.tertiary,
        Icons.hourglass_top_rounded,
      );
    }
    if (status.contains('closed') || status.contains('مغلق')) {
      return (
        locale.customer_support_status_closed,
        color.outline,
        Icons.lock_outline_rounded,
      );
    }
    if (status.contains('cancel') ||
        status.contains('reject') ||
        status.contains('ملغ')) {
      return (
        locale.customer_support_status_cancelled,
        color.error,
        Icons.cancel_outlined,
      );
    }
    if (status.contains('open') ||
        status.contains('new') ||
        status.contains('جديد')) {
      return (
        locale.customer_support_status_open,
        color.secondary,
        Icons.mark_chat_unread_outlined,
      );
    }

    return (rawStatus, color.tertiary, Icons.info_outline_rounded);
  }

  (String label, IconData icon) _resolveCategory(
    BuildContext context,
    String? typeCode,
  ) {
    final locale = context.localization;
    final code = typeCode?.toLowerCase().trim() ?? '';

    if (code.contains('account')) {
      return (
        locale.customer_support_category_account,
        Icons.person_outline_rounded,
      );
    }
    if (code.contains('wrongitem')) {
      return (
        locale.customer_support_category_wrong_items,
        Icons.takeout_dining_outlined,
      );
    }
    if (code.contains('foodquality') || code.contains('quality')) {
      return (
        locale.customer_support_category_food_quality,
        Icons.restaurant_rounded,
      );
    }
    if (code.contains('latedelivery') || code.contains('delay')) {
      return (
        locale.customer_support_category_late_delivery,
        Icons.schedule_rounded,
      );
    }
    if (code.contains('packaging')) {
      return (
        locale.customer_support_category_packaging,
        Icons.inventory_2_outlined,
      );
    }
    if (code.contains('missingitem')) {
      return (
        locale.customer_support_category_missing_items,
        Icons.remove_shopping_cart_outlined,
      );
    }

    return (
      locale.customer_support_category_other,
      Icons.support_agent_rounded,
    );
  }

  String? _formatDate(BuildContext context, String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    final parsed = DateTime.tryParse(rawDate)?.toLocal();
    if (parsed == null) return null;
    final locale = context.localization;
    return intl.DateFormat('d MMMM yyyy • hh:mm a', locale.localeName)
        .format(parsed);
  }

  Widget _buildShimmer(BuildContext context) {
    final color = context.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        ShimmerWidget(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                ),
                const SizedBox(height: Spacing.md),
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
                      width: 110,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.radiusXs),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.xl),
        ShimmerWidget(
          child: Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: color.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        ShimmerWidget(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        ShimmerWidget(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required BuildContext context,
    required CustomerIssueEntity issue,
  }) {
    final color = context.colorScheme;
    final (statusLabel, statusColor, statusIcon) =
        _resolveStatus(context, issue.status);
    final (categoryLabel, categoryIcon) =
        _resolveCategory(context, issue.typeCode ?? issue.category);
    final formattedDate = _formatDate(context, issue.createdAtUtc);
    final shortId = issue.id.length > 8 ? issue.id.substring(0, 8) : issue.id;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.md,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category icon & title + Status pill
            Row(
              children: [
                Container(
                  width: Spacing.avatarSm,
                  height: Spacing.avatarSm,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    categoryIcon,
                    size: Spacing.iconSm,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    categoryLabel,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: Spacing.iconXs,
                        color: statusColor,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        statusLabel,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.sm),

            // Subject
            Text(
              issue.subject?.trim().isNotEmpty == true
                  ? issue.subject!
                  : categoryLabel,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size15,
                color: color.onSurface,
              ),
            ),

            // Description Box
            if (issue.description?.trim().isNotEmpty == true) ...[
              const SizedBox(height: Spacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Text(
                  issue.description!,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],

            const SizedBox(height: Spacing.sm),
            Divider(
              height: 1,
              thickness: 1,
              color: color.outlineVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: Spacing.sm),

            // Footer metadata: Ticket ID & Created Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          color.surfaceContainerHighest.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                    child: Text(
                      '#$shortId',
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                if (formattedDate != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: Spacing.iconXs,
                        color: color.onSurfaceVariant,
                      ),
                      const SizedBox(width: Spacing.xxs),
                      Text(
                        formattedDate,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required BuildContext context,
    required CustomerIssueMessageEntity message,
    required String? requesterUserId,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isFromUser = message.authorUserId != null &&
        requesterUserId != null &&
        message.authorUserId == requesterUserId;

    final senderName = isFromUser
        ? locale.customer_support_sender_you
        : locale.customer_support_sender_support;
    final senderIcon =
        isFromUser ? Icons.person_rounded : Icons.support_agent_rounded;
    final formattedTime = _formatDate(context, message.createdAtUtc);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isFromUser
            ? color.primary.withValues(alpha: 0.07)
            : color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: isFromUser
              ? color.primary.withValues(alpha: 0.25)
              : color.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.02),
            blurRadius: Spacing.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: Spacing.iconLg,
                  height: Spacing.iconLg,
                  decoration: BoxDecoration(
                    color: (isFromUser ? color.primary : color.secondary)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    senderIcon,
                    size: Spacing.iconXs,
                    color: isFromUser ? color.primary : color.secondary,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  senderName,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const Spacer(),
                if (formattedTime != null)
                  Text(
                    formattedTime,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              message.body,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
          ],
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
        unawaited(viewModel.loadIssue(widget.caseId));
        return viewModel;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: locale.customer_support_issue_details_title,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocBuilder<CustomerSupportViewModel, CustomerSupportState>(
          buildWhen: (previous, current) =>
              previous.currentIssue != current.currentIssue ||
              previous.loading != current.loading ||
              previous.submitting != current.submitting ||
              previous.errorMessage != current.errorMessage,
          builder: (context, state) {
            final issue = state.currentIssue;

            if (state.loading && issue == null) {
              return _buildShimmer(context);
            }

            if (issue == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: Spacing.avatarMd,
                        color: color.error,
                      ),
                      const SizedBox(height: Spacing.base),
                      Text(
                        state.errorMessage ?? locale.customer_support_load_error,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppButton.outlined(
                        text: locale.customer_support_retry,
                        onPressed: () => context
                            .read<CustomerSupportViewModel>()
                            .loadIssue(widget.caseId),
                      ),
                    ],
                  ),
                ),
              );
            }

            final isClosed = issue.status.toLowerCase().contains('resolved') ||
                issue.status.toLowerCase().contains('closed') ||
                issue.status.contains('تم') ||
                issue.status.contains('محلول') ||
                issue.status.contains('مغلق');

            return RefreshIndicator(
              onRefresh: () => context
                  .read<CustomerSupportViewModel>()
                  .loadIssue(widget.caseId),
              child: ListView(
                padding: const EdgeInsets.all(Spacing.screenH).copyWith(
                  bottom: Spacing.xxxl * 2,
                ),
                children: [
                  // 1. Overview Header Card
                  _buildOverviewCard(context: context, issue: issue),

                  const SizedBox(height: Spacing.lg),

                  // 2. Replies / Updates Section Header
                  Row(
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        locale.customer_support_replies_title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ),
                      ),
                      if (issue.messages.isNotEmpty) ...[
                        const SizedBox(width: Spacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusSm),
                          ),
                          child: Text(
                            '${issue.messages.length}',
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: Spacing.sm),

                  // 3. Messages List or Empty Indicator
                  if (issue.messages.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        borderRadius:
                            BorderRadius.circular(Spacing.cardRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: Spacing.iconMd,
                            color: color.onSurfaceVariant,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Text(
                              locale.customer_support_no_replies,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...issue.messages.map(
                      (msg) => Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.sm),
                        child: _buildMessageItem(
                          context: context,
                          message: msg,
                          requesterUserId: issue.requesterUserId,
                        ),
                      ),
                    ),

                  const SizedBox(height: Spacing.md),

                  // 4. Closed Banner or Reply Input
                  if (isClosed)
                    Container(
                      padding: const EdgeInsets.all(Spacing.base),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(Spacing.cardRadius),
                        border: Border.all(
                          color: color.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: Spacing.iconMd,
                            color: color.primary,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Text(
                              locale.customer_support_issue_closed_banner,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius:
                            BorderRadius.circular(Spacing.cardRadius),
                        border: Border.all(
                          color: color.outlineVariant.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.shadow.withValues(alpha: 0.03),
                            blurRadius: Spacing.md,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.base),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _reply,
                              hint: locale.customer_support_reply_hint,
                              maxLines: 3,
                              enabled: !state.submitting,
                            ),
                            if (state.errorMessage != null) ...[
                              const SizedBox(height: Spacing.xs),
                              Text(
                                state.errorMessage!,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: Spacing.sm),
                            AppButton.filled(
                              text: locale.customer_support_reply,
                              isLoading: state.submitting,
                              color: color.primary,
                              textColor: color.onPrimary,
                              onPressed: state.submitting
                                  ? null
                                  : () async {
                                      final body = _reply.text.trim();
                                      if (body.isEmpty) return;
                                      final success = await context
                                          .read<CustomerSupportViewModel>()
                                          .reply(body);
                                      if (!context.mounted) return;
                                      if (success) {
                                        _reply.clear();
                                        CustomSnackbar.showSuccess(
                                          context: context,
                                          message: locale
                                              .customer_support_reply_sent,
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
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
