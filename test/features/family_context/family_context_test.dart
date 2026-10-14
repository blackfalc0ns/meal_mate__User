import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_context/data/data_source/family_context_remote_data_source.dart';
import 'package:meal_meat_user/features/family_context/data/mapper/family_context_mapper.dart';
import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';
import 'package:meal_meat_user/features/family_context/data/repo/family_context_repository_impl.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_event.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';

class _FakeFamilyContextRemoteDataSource extends Fake
    implements FamilyContextRemoteDataSource {
  List<FamilyContextResponseDto>? response;
  Exception? exception;

  @override
  Future<List<FamilyContextResponseDto>> getMyFamilyContexts() async {
    if (exception != null) throw exception!;
    return response ?? [];
  }
}

void main() {
  group('FamilyContext DTO to Entity Mapping', () {
    test('maps complete DTO with capabilities correctly', () {
      const dto = FamilyContextResponseDto(
        groupId: 'grp_123',
        isManager: true,
        memberId: 'mem_456',
        memberSubscriptionId: 'sub_789',
        capabilities: [
          FamilyCapabilityResponseDto(
            action: 'manage_members',
            allowed: true,
            reasonCode: 'is_manager',
            requiredPermission: 'admin',
          ),
          FamilyCapabilityResponseDto(
            action: 'edit_meals',
            allowed: false,
            reasonCode: 'locked',
            requiredPermission: 'meal_planner',
          ),
        ],
      );

      final entity = dto.toEntity();

      expect(entity.groupId, 'grp_123');
      expect(entity.isManager, isTrue);
      expect(entity.memberId, 'mem_456');
      expect(entity.memberSubscriptionId, 'sub_789');
      expect(entity.capabilities.length, 2);
      expect(entity.canPerform('manage_members'), isTrue);
      expect(entity.canPerform('edit_meals'), isFalse);
      expect(entity.canPerform('unknown_action'), isFalse);
    });

    test('maps nullable fields defensively', () {
      const dto = FamilyContextResponseDto(
        groupId: null,
        isManager: null,
        memberId: null,
        memberSubscriptionId: null,
        capabilities: null,
      );

      final entity = dto.toEntity();

      expect(entity.groupId, '');
      expect(entity.isManager, isFalse);
      expect(entity.memberId, isNull);
      expect(entity.memberSubscriptionId, isNull);
      expect(entity.capabilities, isEmpty);
    });
  });

  group('FamilyContextRepositoryImpl', () {
    test('returns mapped entity list on success', () async {
      final remoteDataSource = _FakeFamilyContextRemoteDataSource();
      remoteDataSource.response = const [
        FamilyContextResponseDto(
          groupId: 'grp_1',
          isManager: false,
          memberId: 'mem_1',
        ),
      ];

      final repository = FamilyContextRepositoryImpl(remoteDataSource);
      final result = await repository.getMyFamilyContexts();

      expect(result, isA<ApiSuccessResult<List<FamilyContextEntity>>>());
      final data = (result as ApiSuccessResult<List<FamilyContextEntity>>).data;
      expect(data.length, 1);
      expect(data.first.groupId, 'grp_1');
      expect(data.first.isManager, isFalse);
    });

    test('returns empty list for ordinary customer without families', () async {
      final remoteDataSource = _FakeFamilyContextRemoteDataSource();
      remoteDataSource.response = const [];

      final repository = FamilyContextRepositoryImpl(remoteDataSource);
      final result = await repository.getMyFamilyContexts();

      expect(result, isA<ApiSuccessResult<List<FamilyContextEntity>>>());
      final data = (result as ApiSuccessResult<List<FamilyContextEntity>>).data;
      expect(data, isEmpty);
    });
  });

  group('FamilyContextViewModel', () {
    test('LoadFamilyContextsEvent loads contexts successfully', () async {
      final remoteDataSource = _FakeFamilyContextRemoteDataSource();
      remoteDataSource.response = const [
        FamilyContextResponseDto(groupId: 'grp_abc', isManager: true),
      ];

      final repository = FamilyContextRepositoryImpl(remoteDataSource);
      final useCase = GetMyFamilyContextsUseCase(repository);
      final viewModel = FamilyContextViewModel(useCase);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.contexts, isEmpty);

      viewModel.doIntent(const LoadFamilyContextsEvent());
      await pumpEventQueue();

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.contexts.length, 1);
      expect(viewModel.state.hasContexts, isTrue);
      expect(viewModel.state.hasManagerContext, isTrue);

      viewModel.doIntent(const ClearFamilyContextsEvent());
      expect(viewModel.state.contexts, isEmpty);
      expect(viewModel.state.hasContexts, isFalse);

      viewModel.close();
    });
  });
}
