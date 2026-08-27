import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_entity.dart';

class FamilyMemberCalendarFakeDataSource {
  const FamilyMemberCalendarFakeDataSource();

  FamilyMemberCalendarEntity getCalendar() {
    return FamilyMemberCalendarEntity(
      title: 'تقويم أحمد',
      month: DateTime(2026, 9),
      selectedDay: 20,
      detailsButtonLabel: 'عرض تفاصيل اليوم',
      selectedMealsTitle: 'الوجبات المختارة',
      selectedMealsSubtitle: 'الوجبات المختارة لأحمد يوم 20 سبتمبر',
      selectedMealsCountLabel: '3 وجبات مختارة',
      members: [
        FamilyDayMemberEntity(
          name: 'مريم',
          ageLabel: '12 سنة',
          statusLabel: 'نشط',
          imageAsset: AssetsFake.familyMemberMariam,
        ),
        FamilyDayMemberEntity(
          name: 'يوسف',
          ageLabel: '10 سنوات',
          statusLabel: 'نشط',
          imageAsset: AssetsFake.familyMemberYousef,
        ),
        FamilyDayMemberEntity(
          name: 'سارة',
          ageLabel: '8 سنوات',
          statusLabel: 'نشط',
          imageAsset: AssetsFake.familyMemberSarah,
        ),
        FamilyDayMemberEntity(
          name: 'أحمد',
          ageLabel: '14 سنة',
          statusLabel: 'نشط',
          imageAsset: AssetsFake.familyMemberAhmed,
        ),
      ],
      daySummary: FamilyCalendarDaySummaryEntity(
        title: 'الأحد 20 سبتمبر',
        subtitle: '3 وجبات مختارة لهذا اليوم',
      ),
      selectedMeals: [
        FamilyCalendarSelectedMealEntity(
          typeLabel: 'فطور',
          name: 'أومليت خضار',
          description: 'وجبة خفيفة ومتوازنة لبداية اليوم',
          chosenLabel: 'تم الاختيار',
          imageAsset: AssetsFake.familyCalendarOmelet,
        ),
        FamilyCalendarSelectedMealEntity(
          typeLabel: 'غداء',
          name: 'دجاج مشوي مع أرز',
          description: 'وجبة مشبعة وغنية بالبروتين',
          chosenLabel: 'تم الاختيار',
          imageAsset: AssetsFake.familyCalendarChickenRice,
        ),
        FamilyCalendarSelectedMealEntity(
          typeLabel: 'عشاء',
          name: 'سلطة تونة',
          description: 'وجبة خفيفة وغنية بالبروتين',
          chosenLabel: 'تم الاختيار',
          imageAsset: AssetsFake.familyCalendarTunaSalad,
        ),
      ],
    );
  }
}
