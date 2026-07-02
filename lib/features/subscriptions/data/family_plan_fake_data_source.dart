import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanFakeDataSource {
  const FamilyPlanFakeDataSource();

  static const String _mealsCount = '4 وجبات';
  static const String _editLabel = 'تعديل';
  static const List<String> _memberDetailLines = [
    'تناول متوازن',
    '1500 سعرة',
    '4 وجبات يومياً',
  ];

  FamilyPlanEntity getPlan() {
    return FamilyPlanEntity(
      title: 'الباقة العائلية',
      subtitle: 'خطة متكاملة حتى 6 أفراد',
      badge: 'خصم 20%',
      statusLabel: 'جديد',
      originalPrice: '72.000',
      discountedPrice: '57.600',
      currency: '',
      features: [
        'توصيل مجمع',
        'فاتورة واحدة',
        'خصم جماعي مميز',
        'وجبات تناسب الجميع',
        'خطة لكل فرد',
      ],
      members: [
        FamilyMemberEntity(
          name: 'مريم',
          imageAsset: Assets.familyMemberMariam,
          detailLines: _memberDetailLines,
          actionLabel: _editLabel,
          mealsCount: _mealsCount,
          mealChecks: const [false, true, true, false],
          badgeColor: const Color(0xFFEBE3F5),
          badgeTextColor: const Color(0xFF7643BB),
        ),
        FamilyMemberEntity(
          name: 'يوسف',
          imageAsset: Assets.familyMemberYousef,
          detailLines: _memberDetailLines,
          actionLabel: _editLabel,
          mealsCount: _mealsCount,
          mealChecks: const [true, true, true, true],
        ),
        FamilyMemberEntity(
          name: 'سارة',
          imageAsset: Assets.familyMemberSarah,
          detailLines: _memberDetailLines,
          actionLabel: _editLabel,
          mealsCount: _mealsCount,
          mealChecks: const [true, false, true, true],
          badgeColor: const Color(0xFFFFEAD5),
          badgeTextColor: const Color(0xFFFE6713),
        ),
        FamilyMemberEntity(
          name: 'أحمد',
          imageAsset: Assets.familyMemberAhmed,
          detailLines: _memberDetailLines,
          actionLabel: _editLabel,
          mealsCount: _mealsCount,
          mealChecks: const [true, true, true, true],
          isOwner: true,
        ),
      ],
      summaryStats: [
        FamilySummaryStatEntity(
          value: '4',
          label: 'عدد الأفراد الحالي',
          iconName: 'users',
        ),
        FamilySummaryStatEntity(
          value: '4',
          label: 'الحد الأقصى لأفراد الباقة',
          iconName: 'users',
        ),
        FamilySummaryStatEntity(
          value: '16',
          label: 'إجمالي الوجبات اليومية',
          iconName: 'meals',
        ),
        FamilySummaryStatEntity(
          value: '7.500',
          label: 'إجمالي السعرات اليومية',
          iconName: 'fire',
        ),
        FamilySummaryStatEntity(
          value: 'توصيل مجمع',
          label: 'توصيل واحد لكل أفراد العائلة',
          iconName: 'delivery',
        ),
      ],
      priceRows: const [
        FamilyPriceRowEntity(
          label: 'السعر الأساسي (لـ 2 أفراد)',
          value: '42.600',
        ),
        FamilyPriceRowEntity(
          label: 'أفراد إضافيون (2 x 7.500)',
          value: '15.000',
        ),
      ],
      totalLabel: 'الإجمالي:',
      totalPrice: '57.600',
    );
  }
}
