import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/family_day_details_entity.dart';

class FamilyDayDetailsFakeDataSource {
  const FamilyDayDetailsFakeDataSource();

  FamilyDayDetailsEntity getDetails() {
    return const FamilyDayDetailsEntity(
      title: 'تفاصيل يوم',
      reviewButtonLabel: 'مراجعة وجبات اليوم',
      selectedMealsLabel: 'تم اختيار جميع الوجبات',
      member: FamilyDayMemberEntity(
        name: 'أحمد',
        ageLabel: '14 سنة',
        statusLabel: 'نشط',
        imageAsset: AssetsFake.familyDayMemberAhmed,
      ),
      meals: [
        FamilyDayMealEntity(
          mealType: 'الإفطار',
          restaurantName: 'مطعم بيت هاريس',
          mealName: 'دجاج بالأعشاب مع أرز أبيض',
          actionLabel: 'تعديل',
          imageAsset: AssetsFake.familyDayBreakfast,
          iconType: FamilyDayMealIconType.breakfast,
        ),
        FamilyDayMealEntity(
          mealType: 'الغداء',
          restaurantName: 'مطعم بيت هاريس',
          mealName: 'سلمون مشوي مع خضروات',
          actionLabel: 'تعديل',
          imageAsset: AssetsFake.familyDaySalmon,
          iconType: FamilyDayMealIconType.lunch,
        ),
        FamilyDayMealEntity(
          mealType: 'العشاء',
          restaurantName: 'مطعم بيت هاريس',
          mealName: 'سلمون مشوي مع خضروات',
          actionLabel: 'تعديل',
          imageAsset: AssetsFake.familyDaySalmon,
          iconType: FamilyDayMealIconType.dinner,
        ),
        FamilyDayMealEntity(
          mealType: 'سناك',
          restaurantName: 'مطعم بيت هاريس',
          mealName: 'زبادي يوناني مع توت',
          actionLabel: 'تعديل',
          imageAsset: AssetsFake.familyDaySnack,
          iconType: FamilyDayMealIconType.snack,
        ),
      ],
    );
  }
}
