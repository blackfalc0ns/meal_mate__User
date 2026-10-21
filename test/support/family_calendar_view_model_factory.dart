import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';

FamilyCalendarViewModel createFamilyCalendarViewModel({
  GetFamilyMembersUseCase? members,
  GetCalendarUseCase? calendar,
  GetCalendarDayUseCase? day,
  List<FamilyMemberSummaryEntity> membersData = const [],
}) {
  final calendarRepository = _EmptyCalendarRepository();
  return FamilyCalendarViewModel(
    members ??
        GetFamilyMembersUseCase(_EmptyFamilyOverviewRepository(membersData)),
    calendar ?? GetCalendarUseCase(calendarRepository),
    day ?? GetCalendarDayUseCase(calendarRepository),
    getIt.isRegistered<FamilyContextViewModel>()
        ? getIt<FamilyContextViewModel>()
        : FamilyContextViewModel(_UnusedContextUseCase()),
  );
}

class _EmptyFamilyOverviewRepository implements FamilyOverviewRepository {
  _EmptyFamilyOverviewRepository(this.members);

  final List<FamilyMemberSummaryEntity> members;

  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilyMembers({
    String locale = 'ar',
  }) async => ApiSuccessResult(data: members);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _EmptyCalendarRepository implements CalendarRepository {
  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) async => ApiSuccessResult(
    data: CalendarSubscriptionEntity(
      subscriptionId: subscriptionId,
      days: const [],
    ),
  );

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async => ApiSuccessResult(
    data: CalendarDayEntity(
      dayNumber: DateTime.parse(date).day,
      weekday: '',
      date: DateTime.parse(date),
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedContextUseCase implements GetMyFamilyContextsUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
