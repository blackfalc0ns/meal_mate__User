import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_convert_from_individual_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_lookup_response_dto.dart';

abstract class FamilySubscriptionSetupRemoteDataSource {
  Future<List<FamilyRelationshipResponseDto>> getFamilyRelationships();
  Future<FamilyFlowCurrentResponseDto> getFamilySubscriptionCurrent();
  Future<FamilyFlowCurrentResponseDto> convertFromIndividual(
    FamilyConvertFromIndividualRequestDto request,
  );
  Future<void> abandonFamilyDraft();
  Future<FamilyFlowCurrentResponseDto> updateFamilyGroup(
    FamilyGroupWriteRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> addFamilyMember(
    FamilyMemberWriteRequestDto request,
  );
  Future<FamilyMemberLookupResponseDto> lookupFamilyMember(
    FamilyMemberLookupRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> updateFamilyMember(
    String memberId,
    FamilyMemberWriteRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> deleteFamilyMember(String memberId);
}
