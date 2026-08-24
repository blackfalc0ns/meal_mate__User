import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_add_member_dialog.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_subscription_setup_loading_skeleton.dart';

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
    if (name.isNotEmpty) {
      context.read<FamilySubscriptionSetupViewModel>().doIntent(
        UpdateFamilyGroupEvent(
          name: name,
          familyPackageId: widget.selectedPackage?.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilySubscriptionSetupViewModel>(
      create: (_) {
        final vm = getIt<FamilySubscriptionSetupViewModel>();
        if (widget.selectedPackage != null) {
          vm.doIntent(SelectFamilySizePackageEvent(widget.selectedPackage!));
        }
        vm.doIntent(const GetFamilySubscriptionCurrentEvent());
        vm.doIntent(const GetFamilyRelationshipsEvent());
        vm.doIntent(const GetFamilyAddressesEvent());
        return vm;
      },
      child: Scaffold(
        backgroundColor: color.surface,
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
          child: BlocConsumer<FamilySubscriptionSetupViewModel, FamilyPlanState>(
            listener: (context, state) {
              if (state.currentFlow != null) {
                if (_familyNameController.text.isEmpty &&
                    state.currentFlow?.name != null &&
                    state.currentFlow!.name!.isNotEmpty) {
                  _familyNameController.text = state.currentFlow!.name!;
                }

                // If package was passed from previous screen and not set in group yet, update
                if (!_didSyncInitialPackage &&
                    widget.selectedPackage != null &&
                    state.currentFlow?.selectedFamilyPackageId !=
                        widget.selectedPackage?.id) {
                  _didSyncInitialPackage = true;
                  final currentName = _familyNameController.text.isNotEmpty
                      ? _familyNameController.text
                      : (state.currentFlow?.name ?? 'عائلتي');
                  context.read<FamilySubscriptionSetupViewModel>().doIntent(
                    UpdateFamilyGroupEvent(
                      name: currentName,
                      familyPackageId: widget.selectedPackage!.id,
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state.isCurrentFlowLoading && state.currentFlow == null) {
                return const FamilySubscriptionSetupLoadingSkeleton();
              }

              if (state.failure != null && state.currentFlow == null) {
                return ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () {
                    context.read<FamilySubscriptionSetupViewModel>().doIntent(
                      const GetFamilySubscriptionCurrentEvent(),
                    );
                  },
                );
              }

              return _buildSetupContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSetupContent(BuildContext context, FamilyPlanState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = state.members;
    final maxMembers = state.maxMembers;
    final isMaxReached = members.length >= maxMembers;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.md),
          const FamilyProgramStepper(
            currentStep: 0,
            completedSteps: 1,
            includeFamilyCreationStep: true,
          ),
          const SizedBox(height: Spacing.lg),

          // Selected package summary banner
          _buildPackageBanner(context, state),
          const SizedBox(height: Spacing.md),

          // Family Name Field
          Text(
            locale.family_name,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          AppTextField(
            controller: _familyNameController,
            hint: locale.family_name_hint,
            prefixIcon: Icon(
              Icons.groups_2_rounded,
              color: color.onSurfaceVariant,
              size: Spacing.iconSm,
            ),
            onSubmitted: (_) => _onSaveFamilyName(context),
          ),
          const SizedBox(height: Spacing.lg),

          // Members Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.family_members_count_label,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isMaxReached
                      ? color.error.withValues(alpha: 0.1)
                      : color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Text(
                  locale.family_members_count_indicator(
                    members.length,
                    maxMembers,
                  ),
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: isMaxReached ? color.error : color.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),

          // Members List
          ...members.map((member) => _buildMemberTile(context, member, state)),

          // Add Member Button (Outlined card)
          if (!isMaxReached) ...[
            const SizedBox(height: Spacing.xs),
            OutlinedButton.icon(
              onPressed: () => _openAddMemberDialog(context, state),
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: color.primary,
              ),
              label: Text(
                locale.family_add_member,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(color: color.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: Spacing.xs),
            Text(
              locale.family_members_max_reached,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: Spacing.xl),

          // Next Button
          AppButton.filled(
            text: locale.family_next_program,
            onPressed: () {
              _onSaveFamilyName(context);
              context.pushNamed(AppRoutes.familyProgramSetup);
            },
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size12,
            iconWidget: Icon(
              Icons.chevron_right_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
            ),
          ),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }

  Widget _buildPackageBanner(BuildContext context, FamilyPlanState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final pkg = state.selectedPackage;
    final pkgName =
        pkg?.name(locale.localeName) ??
        state.currentFlow?.packageName(locale.localeName) ??
        '';

    if (pkgName.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, color: color.primary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkgName,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
                Text(
                  locale.family_package_members_range(
                    state.minMembers,
                    state.maxMembers,
                  ),
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                context.pushNamed(AppRoutes.familyPackageSelection),
            child: Text(
              locale.family_change_package,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(
    BuildContext context,
    FamilyMemberEntity member,
    FamilyPlanState state,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.primary.withValues(alpha: 0.1),
            child: Icon(
              member.gender == 2 ? Icons.female_rounded : Icons.male_rounded,
              color: color.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                    if (member.isManager) ...[
                      const SizedBox(width: Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                        ),
                        child: Text(
                          locale.family_owner,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${member.ageYears} ${locale.family_year} · ${member.relationshipCode}',
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!member.isManager) ...[
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: color.onSurfaceVariant,
                size: 18,
              ),
              onPressed: () => _openEditMemberDialog(context, member, state),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: color.error,
                size: 18,
              ),
              onPressed: () {
                context.read<FamilySubscriptionSetupViewModel>().doIntent(
                  DeleteFamilyMemberEvent(member.memberId),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _openAddMemberDialog(BuildContext context, FamilyPlanState state) {
    FamilyAddMemberDialog.show(
      context: context,
      relationships: state.relationships,
      addresses: state.addresses,
      onSubmit:
          ({
            required String displayName,
            required String relationshipCode,
            required int gender,
            required int ageYears,
            String? deliveryAddressId,
          }) {
            context.read<FamilySubscriptionSetupViewModel>().doIntent(
              AddFamilyMemberEvent(
                displayName: displayName,
                relationshipCode: relationshipCode,
                gender: gender,
                ageYears: ageYears,
                deliveryAddressId: deliveryAddressId,
              ),
            );
          },
    );
  }

  void _openEditMemberDialog(
    BuildContext context,
    FamilyMemberEntity member,
    FamilyPlanState state,
  ) {
    FamilyAddMemberDialog.show(
      context: context,
      member: member,
      relationships: state.relationships,
      addresses: state.addresses,
      onSubmit:
          ({
            required String displayName,
            required String relationshipCode,
            required int gender,
            required int ageYears,
            String? deliveryAddressId,
          }) {
            context.read<FamilySubscriptionSetupViewModel>().doIntent(
              UpdateFamilyMemberEvent(
                memberId: member.memberId,
                displayName: displayName,
                relationshipCode: relationshipCode,
                gender: gender,
                ageYears: ageYears,
                deliveryAddressId: deliveryAddressId,
              ),
            );
          },
    );
  }
}
