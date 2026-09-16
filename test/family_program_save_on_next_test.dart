import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';
import 'package:meal_meat_user/features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';
import 'package:meal_meat_user/features/family_programs/domain/usecase/get_family_programs_usecase.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

void main() {
  test('choosing a program updates the selection without saving it', () async {
    final planRepository = _PlanRepository();
    final viewModel = FamilyProgramsViewModel(
      GetFamilyFlowCurrentUseCase(_FlowRepository()),
      GetFamilyProgramsUseCase(_ProgramsRepository()),
      SaveFamilyMemberPlanUseCase(planRepository),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const GetFamilySubscriptionCurrentEvent());
    viewModel.doIntent(const GetFamilyProgramsEvent());
    await viewModel.stream.firstWhere(
      (state) => state.currentFlow != null && state.programs.isNotEmpty,
    );

    viewModel.doIntent(const SelectFamilyProgramEvent(0));

    expect(viewModel.state.selectedMember?.programId, 'program-1');
    expect(planRepository.requests, isEmpty);
    expect(viewModel.state.isPlanSaving, isFalse);
  });

  test('continuing starts the save without waiting for its response', () async {
    final planRepository = _PlanRepository();
    final viewModel = FamilyProgramsViewModel(
      GetFamilyFlowCurrentUseCase(_FlowRepository()),
      GetFamilyProgramsUseCase(_ProgramsRepository()),
      SaveFamilyMemberPlanUseCase(planRepository),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const GetFamilySubscriptionCurrentEvent());
    viewModel.doIntent(const GetFamilyProgramsEvent());
    await viewModel.stream.firstWhere(
      (state) => state.currentFlow != null && state.programs.isNotEmpty,
    );
    viewModel.doIntent(const SelectFamilyProgramEvent(0));

    viewModel.doIntent(const SaveFamilyProgramsEvent());

    expect(planRepository.requests, [('member-1', 'program-1')]);
    expect(viewModel.state.isPlanSaving, isTrue);

    planRepository.response.complete(
      ApiSuccessResult(
        data: const FamilyFlowCurrentEntity(
          members: [
            FamilyMemberEntity(
              memberId: 'member-1',
              role: 1,
              displayName: 'Member',
              relationshipCode: 'self',
              gender: 1,
              ageYears: 25,
              setupStatus: 1,
              programId: 'program-1',
              includeFriday: false,
              isCurrentUser: true,
            ),
          ],
        ),
      ),
    );
    await viewModel.stream.firstWhere((state) => !state.isPlanSaving);
    expect(viewModel.state.selectedMember?.programId, 'program-1');
  });

  test('continuing saves selections made for both family members', () async {
    final planRepository = _PlanRepository();
    final secondResponse = Completer<ApiResult<FamilyFlowCurrentEntity>>();
    planRepository.responses.add(secondResponse);
    final viewModel = FamilyProgramsViewModel(
      GetFamilyFlowCurrentUseCase(_FlowRepository(includeSecondMember: true)),
      GetFamilyProgramsUseCase(_ProgramsRepository()),
      SaveFamilyMemberPlanUseCase(planRepository),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const GetFamilySubscriptionCurrentEvent());
    viewModel.doIntent(const GetFamilyProgramsEvent());
    await viewModel.stream.firstWhere(
      (state) => state.currentFlow != null && state.programs.isNotEmpty,
    );
    viewModel.doIntent(const SelectFamilyProgramEvent(0));
    viewModel.doIntent(const SelectFamilyMemberEvent(1));
    viewModel.doIntent(const SelectFamilyProgramEvent(1));
    expect(planRepository.requests, isEmpty);

    viewModel.doIntent(const SaveFamilyProgramsEvent());
    expect(planRepository.requests, [('member-1', 'program-1')]);
    planRepository.response.complete(
      ApiSuccessResult(
        data: const FamilyFlowCurrentEntity(
          members: [
            FamilyMemberEntity(
              memberId: 'member-1',
              role: 1,
              displayName: 'Member',
              relationshipCode: 'self',
              gender: 1,
              ageYears: 25,
              setupStatus: 1,
              programId: 'program-1',
              includeFriday: false,
              isCurrentUser: true,
            ),
            FamilyMemberEntity(
              memberId: 'member-2',
              role: 2,
              displayName: 'Dependent',
              relationshipCode: 'child',
              gender: 1,
              ageYears: 18,
              setupStatus: 1,
              includeFriday: false,
              isCurrentUser: false,
            ),
          ],
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(viewModel.state.members[1].programId, 'program-2');
    expect(planRepository.requests, [
      ('member-1', 'program-1'),
      ('member-2', 'program-2'),
    ]);

    secondResponse.complete(
      ApiSuccessResult(data: viewModel.state.currentFlow!),
    );
    await viewModel.stream.firstWhere((state) => !state.isPlanSaving);
  });
}

class _FlowRepository implements FamilySubscriptionSetupRepository {
  _FlowRepository({this.includeSecondMember = false});

  final bool includeSecondMember;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async => ApiSuccessResult(
    data: FamilyFlowCurrentEntity(
      members: [
        const FamilyMemberEntity(
          memberId: 'member-1',
          role: 1,
          displayName: 'Member',
          relationshipCode: 'self',
          gender: 1,
          ageYears: 25,
          setupStatus: 1,
          includeFriday: false,
          isCurrentUser: true,
        ),
        if (includeSecondMember)
          const FamilyMemberEntity(
            memberId: 'member-2',
            role: 2,
            displayName: 'Dependent',
            relationshipCode: 'child',
            gender: 1,
            ageYears: 18,
            setupStatus: 1,
            includeFriday: false,
            isCurrentUser: false,
          ),
      ],
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ProgramsRepository implements FamilyProgramsRepository {
  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>>
  getFamilyPrograms() async => ApiSuccessResult(
    data: const [
      SubscriptionProgramEntity(
        programId: 'program-1',
        code: 'one',
        shortCode: 'one',
        nameAr: 'برنامج',
        nameEn: 'Program',
        descriptionAr: '',
        descriptionEn: '',
        keywordsAr: [],
        keywordsEn: [],
        imageUrl: null,
        bundleCount: 1,
        supportedSlots: [],
        fallbackImageAsset: '',
      ),
      SubscriptionProgramEntity(
        programId: 'program-2',
        code: 'two',
        shortCode: 'two',
        nameAr: 'برنامج ثاني',
        nameEn: 'Second program',
        descriptionAr: '',
        descriptionEn: '',
        keywordsAr: [],
        keywordsEn: [],
        imageUrl: null,
        bundleCount: 1,
        supportedSlots: [],
        fallbackImageAsset: '',
      ),
    ],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PlanRepository implements FamilyPackageDaysRepository {
  final requests = <(String, String?)>[];
  final response = Completer<ApiResult<FamilyFlowCurrentEntity>>();
  late final responses = <Completer<ApiResult<FamilyFlowCurrentEntity>>>[
    response,
  ];

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) {
    requests.add((memberId, programId));
    return responses[requests.length - 1].future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
