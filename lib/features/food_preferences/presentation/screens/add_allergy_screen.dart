import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/food_preferences/data/add_allergy_fake_data_source.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_common_list.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_option_tile.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_summary_card.dart';

class AddAllergyScreen extends StatefulWidget {
  const AddAllergyScreen({super.key});

  @override
  State<AddAllergyScreen> createState() => _AddAllergyScreenState();
}

class _AddAllergyScreenState extends State<AddAllergyScreen> {
  static const _dataSource = AddAllergyFakeDataSource();
  String _query = '';
  late Set<String> _selectedAllergies;
  bool _hasInitialSelections = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitialSelections) return;

    final locale = context.localization;
    _selectedAllergies = _dataSource.getInitialSelectedAllergies(locale);
    _hasInitialSelections = true;
  }

  void _toggleAllergy(String value) {
    setState(() {
      if (_selectedAllergies.contains(value)) {
        _selectedAllergies.remove(value);
      } else {
        _selectedAllergies.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final gridOptions = _dataSource.getGridOptions(locale);
    final filteredGridOptions = gridOptions
        .where((option) => option.$1.contains(_query))
        .toList();
    final commonOptions = _dataSource.getCommonOptions(locale);

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.add_allergy_title,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.addAllergyScreenHorizontalPadding,
            vertical: Spacing.addAllergyContentTopPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                locale.add_allergy_subtitle,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.md),
              AddAllergySummaryCard(
                selectedAllergies: _selectedAllergies.toList(),
              ),
              const SizedBox(height: Spacing.addAllergySectionGap),
              SizedBox(
                height: Spacing.addAllergySearchHeight,
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: locale.add_allergy_search_hint,
                    hintStyle: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.addAllergySearchRadius,
                      ),
                      borderSide: BorderSide(color: color.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.addAllergySearchRadius,
                      ),
                      borderSide: BorderSide(color: color.outlineVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.addAllergySectionGap),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredGridOptions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: Spacing.addAllergyGridTileHeight,
                  mainAxisSpacing: Spacing.addAllergyGridGap,
                  crossAxisSpacing: Spacing.addAllergyGridGap,
                ),
                itemBuilder: (context, index) {
                  final option = filteredGridOptions[index];
                  return AddAllergyOptionTile(
                    label: option.$1,
                    iconAsset: option.$2,
                    isSelected: _selectedAllergies.contains(option.$1),
                    onTap: () => _toggleAllergy(option.$1),
                  );
                },
              ),
              const SizedBox(height: Spacing.addAllergySectionGap),
              AddAllergyCommonList(
                options: commonOptions,
                selectedOptions: _selectedAllergies,
                onToggle: _toggleAllergy,
              ),
              const SizedBox(height: Spacing.addAllergySectionGap),
              CustomWarningWidget(
                messageFontSize: FontSize.size10,
                icon: Icons.warning_rounded,
                title: locale.add_allergy_note_title,
                message: locale.add_allergy_note_message,
                isWarning: true,
                height: Spacing.addAllergyNoticeHeight,
                backgroundColor: color.secondaryContainer,
                borderColor: color.outlineVariant,
                horizontalPadding: Spacing.sm,
                iconTextSpacing: Spacing.xs,
                borderRadius: Spacing.addAllergyNoticeRadius,
              ),
              const SizedBox(height: Spacing.md),
              AppButton.filled(
                text: locale.add_allergy_save,
                onPressed: () => Navigator.of(context).maybePop(),
                height: Spacing.addAllergyButtonHeight,
                borderRadius: Spacing.addAllergyButtonRadius,

                textColor: color.onPrimary,
                fontSize: FontSize.size12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
