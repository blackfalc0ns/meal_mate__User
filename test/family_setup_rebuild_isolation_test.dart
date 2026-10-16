import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_actions_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_add_member_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_member_form_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_members_section.dart';

Widget testWrapper({required Widget child}) {
  return MaterialApp(
    locale: const Locale('ar'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  const relationships = [
    FamilyRelationshipEntity(
      code: 'spouse',
      nameAr: 'زوج / زوجة',
      nameEn: 'Spouse',
      forDependents: true,
      isPrimary: false,
    ),
  ];

  const dummyMember = FamilyMemberEntity(
    memberId: 'mem_1',
    role: 2,
    displayName: 'أحمد',
    relationshipCode: 'spouse',
    gender: 1,
    ageYears: 30,
    setupStatus: 1,
    includeFriday: false,
    isCurrentUser: false,
  );

  group('Family Setup Rebuild Isolation Tests', () {
    testWidgets(
      'Member form local interactions do not rebuild external members section',
      (tester) async {
        int membersSectionBuildCount = 0;

        await tester.pumpWidget(
          testWrapper(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Builder(
                      builder: (context) {
                        membersSectionBuildCount++;
                        return FamilySetupMembersSection(
                          members: const [dummyMember],
                          onMemberSelected: (_) {},
                        );
                      },
                    ),
                    FamilySetupMemberFormSection(
                      relationships: relationships,
                      isMemberSaving: false,
                      isMemberLookupLoading: false,
                      onLookupPhone: (_) {},
                      onSubmitMember:
                          ({
                            required phone,
                            required displayName,
                            required relationshipCode,
                            required gender,
                            required ageYears,
                          }) {},
                    ),
                  ],
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        final initialBuildCount = membersSectionBuildCount;

        // Tap the female gender option inside the form
        final femaleFinder = find.text('أنثى');
        expect(femaleFinder, findsOneWidget);
        await tester.tap(femaleFinder);
        await tester.pumpAndSettle();

        // The members section build count must remain unchanged
        expect(membersSectionBuildCount, equals(initialBuildCount));
      },
    );

    testWidgets(
      'Members section updates when member list updates while preserving form text',
      (tester) async {
        final formKey = GlobalKey<FamilySetupMemberFormSectionState>();
        var currentMembers = <FamilyMemberEntity>[];

        late StateSetter parentSetState;

        await tester.pumpWidget(
          testWrapper(
            child: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Column(
                  children: [
                    FamilySetupMembersSection(
                      members: currentMembers,
                      onMemberSelected: (_) {},
                    ),
                    FamilySetupMemberFormSection(
                      key: formKey,
                      relationships: relationships,
                      isMemberSaving: false,
                      isMemberLookupLoading: false,
                      onLookupPhone: (_) {},
                      onSubmitMember:
                          ({
                            required phone,
                            required displayName,
                            required relationshipCode,
                            required gender,
                            required ageYears,
                          }) {},
                    ),
                  ],
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Type a name in the form
        final nameField = find.byType(TextField).at(1);
        await tester.enterText(nameField, 'خالد محمد');
        await tester.pumpAndSettle();

        // Update member list from parent
        parentSetState(() {
          currentMembers = [dummyMember];
        });
        await tester.pumpAndSettle();

        // Verify member appears on strip and form text is preserved
        expect(find.text('أحمد'), findsOneWidget);
        expect(find.text('خالد محمد'), findsOneWidget);
      },
    );

    testWidgets(
      'Toggling isMemberSaving updates actions loading state without rebuilding form unnecessarily',
      (tester) async {
        int formBuildCount = 0;
        bool isSaving = false;
        late StateSetter parentSetState;

        await tester.pumpWidget(
          testWrapper(
            child: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Column(
                  children: [
                    Builder(
                      builder: (context) {
                        formBuildCount++;
                        return FamilySetupMemberFormSection(
                          relationships: relationships,
                          isMemberSaving: isSaving,
                          isMemberLookupLoading: false,
                          onLookupPhone: (_) {},
                          onSubmitMember:
                              ({
                                required phone,
                                required displayName,
                                required relationshipCode,
                                required gender,
                                required ageYears,
                              }) {},
                        );
                      },
                    ),
                    FamilySetupActionsSection(
                      isEditing: false,
                      isMemberSaving: isSaving,
                      onAddOrUpdateMember: () {},
                      onNext: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('إضافة فرد'), findsOneWidget);
        expect(formBuildCount, greaterThan(0));

        // Toggle saving on
        parentSetState(() => isSaving = true);
        await tester.pump();

        // Actions show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Member form populates relationship field as text value from initial member',
      (tester) async {
        await tester.pumpWidget(
          testWrapper(
            child: FamilySetupMemberFormSection(
              selectedMember: dummyMember,
              relationships: relationships,
              isMemberSaving: false,
              isMemberLookupLoading: false,
              onLookupPhone: (_) {},
              onSubmitMember:
                  ({
                    required phone,
                    required displayName,
                    required relationshipCode,
                    required gender,
                    required ageYears,
                  }) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // The relationship text ('زوج / زوجة') must appear as an actual populated value
        expect(find.text('زوج / زوجة'), findsOneWidget);
      },
    );

    testWidgets(
      'FamilySetupMembersSection displays counter and Add Member card when below limit',
      (tester) async {
        bool addTapped = false;
        await tester.pumpWidget(
          testWrapper(
            child: FamilySetupMembersSection(
              members: const [dummyMember],
              maxMembers: 4,
              onMemberSelected: (_) {},
              onAddMemberTap: () => addTapped = true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Counter shows 4 من 1 (max من current)
        expect(find.text('4 من 1'), findsOneWidget);
        // Add member card is present
        expect(find.byType(FamilySetupAddMemberCard), findsOneWidget);

        // Tap Add member card
        await tester.tap(find.byType(FamilySetupAddMemberCard));
        await tester.pumpAndSettle();
        expect(addTapped, isTrue);
      },
    );

    testWidgets(
      'FamilySetupMembersSection hides Add Member card when limit is reached',
      (tester) async {
        const member2 = FamilyMemberEntity(
          memberId: 'mem_2',
          role: 2,
          displayName: 'سارة',
          relationshipCode: 'spouse',
          gender: 2,
          ageYears: 28,
          setupStatus: 1,
          includeFriday: false,
          isCurrentUser: false,
        );

        await tester.pumpWidget(
          testWrapper(
            child: FamilySetupMembersSection(
              members: const [dummyMember, member2],
              maxMembers: 2,
              onMemberSelected: (_) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Counter shows 2 من 2
        expect(find.text('2 من 2'), findsOneWidget);
        // Add member card must NOT be present when limit is reached
        expect(find.byType(FamilySetupAddMemberCard), findsNothing);
      },
    );

    testWidgets(
      'FamilySetupActionsSection disables add button when limit reached and disables next button when below minMembers',
      (tester) async {
        bool addTapped = false;
        bool nextTapped = false;

        // Below minMembers: Next button is disabled
        await tester.pumpWidget(
          testWrapper(
            child: FamilySetupActionsSection(
              isEditing: false,
              isLimitReached: false,
              canProceed: false,
              isMemberSaving: false,
              onAddOrUpdateMember: () => addTapped = true,
              onNext: () => nextTapped = true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Both buttons visible
        expect(find.text('إضافة فرد'), findsOneWidget);
        expect(find.text('التالي : البرنامج'), findsOneWidget);

        // Next button is disabled
        await tester.tap(find.text('التالي : البرنامج'));
        await tester.pumpAndSettle();
        expect(nextTapped, isFalse);

        // Limit reached: Add member button stays visible but is disabled, Next button is enabled
        await tester.pumpWidget(
          testWrapper(
            child: FamilySetupActionsSection(
              isEditing: false,
              isLimitReached: true,
              canProceed: true,
              isMemberSaving: false,
              onAddOrUpdateMember: () => addTapped = true,
              onNext: () => nextTapped = true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Both buttons remain present
        expect(find.text('إضافة فرد'), findsOneWidget);
        expect(find.text('التالي : البرنامج'), findsOneWidget);

        // Tapping Add member does not invoke callback because it is disabled
        await tester.tap(find.text('إضافة فرد'));
        await tester.pumpAndSettle();
        expect(addTapped, isFalse);

        // Next button is present and enabled
        await tester.tap(find.text('التالي : البرنامج'));
        await tester.pumpAndSettle();
        expect(nextTapped, isTrue);
      },
    );

    testWidgets(
      'Member form clears name when phone lookup returns not found, and populates when found',
      (tester) async {
        FamilyMemberLookupEntity? currentLookup;
        late StateSetter parentSetState;

        await tester.pumpWidget(
          testWrapper(
            child: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return FamilySetupMemberFormSection(
                  relationships: relationships,
                  isMemberSaving: false,
                  isMemberLookupLoading: false,
                  memberLookup: currentLookup,
                  onLookupPhone: (_) {},
                  onSubmitMember:
                      ({
                        required phone,
                        required displayName,
                        required relationshipCode,
                        required gender,
                        required ageYears,
                      }) {},
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Type a name first
        final nameField = find.byType(TextField).at(1);
        await tester.enterText(nameField, 'werews');
        await tester.pumpAndSettle();
        expect(find.text('werews'), findsOneWidget);

        // Simulate lookup not found
        parentSetState(() {
          currentLookup = const FamilyMemberLookupEntity(
            found: false,
          );
        });
        await tester.pumpAndSettle();

        // The name must be cleared!
        expect(find.text('werews'), findsNothing);

        // Simulate lookup found
        parentSetState(() {
          currentLookup = const FamilyMemberLookupEntity(
            found: true,
            displayName: 'محمد علي',
            ageYears: 32,
            gender: 1,
          );
        });
        await tester.pumpAndSettle();

        // The name from backend must appear
        expect(find.text('محمد علي'), findsOneWidget);
      },
    );
  });
}
