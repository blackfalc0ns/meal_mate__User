import 'package:meal_meat_user/core/constants/assets_fake.dart';

class FamilyProgramSetupFakeDataSource {
  const FamilyProgramSetupFakeDataSource();

  List<FamilyProgramSetupMemberFakeData> getMembers() {
    return const [
      FamilyProgramSetupMemberFakeData(
        name: 'أحمد',
        imageAsset: AssetsFake.familyMemberAhmed,
        status: 'قيد الإعداد',
        isSelected: true,
        isInProgress: true,
      ),
      FamilyProgramSetupMemberFakeData(
        name: 'سارة',
        imageAsset: AssetsFake.familyMemberSarah,
        status: 'لم يبدأ',
      ),
      FamilyProgramSetupMemberFakeData(
        name: 'يوسف',
        imageAsset: AssetsFake.familyMemberYousef,
        status: 'لم يبدأ',
      ),
      FamilyProgramSetupMemberFakeData(
        name: 'مريم',
        imageAsset: AssetsFake.familyMemberMariam,
        status: 'لم يبدأ',
      ),
    ];
  }

  FamilyProgramSetupMemberDetailsFakeData getSelectedMemberDetails() {
    return const FamilyProgramSetupMemberDetailsFakeData(
      name: 'أحمد',
      imageAsset: AssetsFake.familyMemberAhmed,
      age: '24 سنة',
      gender: 'ذكر',
      goal: 'متوازن',
      activityLevel: 'مـــتوســـط',
    );
  }

  List<FamilyProgramSetupProgramFakeData> getPrograms() {
    return const [
      FamilyProgramSetupProgramFakeData(
        title: 'متوازن',
        description: 'نظام غذائي متوازن لطعام وصحة أفضل',
        imageAsset: AssetsFake.familySetupProgramBalanced,
        isSelected: true,
      ),
      FamilyProgramSetupProgramFakeData(
        title: 'خسارة وزن',
        description: 'سعرات أقل لدعم فقدان الوزن',
        imageAsset: AssetsFake.familySetupProgramWeightLoss,
      ),
      FamilyProgramSetupProgramFakeData(
        title: 'بناء عضلات',
        description: 'غني بالبروتين لدعم بناء العضلات',
        imageAsset: AssetsFake.familySetupProgramMuscle,
      ),
      FamilyProgramSetupProgramFakeData(
        title: 'كيتو',
        description: 'منخفض الكربوهيدرات وعالي الدهون',
        imageAsset: AssetsFake.familySetupProgramKeto,
      ),
    ];
  }

  List<FamilyPackageOptionFakeData> getPackageOptions() {
    return const [
      FamilyPackageOptionFakeData(
        title: '4 وجبات + سناك',
        description: 'تشمل الإفطار وسناك الغداء وسناك العشاء',
        icon: FamilyPackageOptionIcon.appleCutlery,
        isSelected: true,
      ),
      FamilyPackageOptionFakeData(
        title: '3 وجبات يومياً',
        description: 'تشمل الإفطار والغداء والعشاء',
        icon: FamilyPackageOptionIcon.cutlery,
      ),
      FamilyPackageOptionFakeData(
        title: 'وجبتين يومياً',
        description: 'تشمل الغداء والعشاء',
        icon: FamilyPackageOptionIcon.cutlery,
      ),
    ];
  }

  List<FamilyDayOptionFakeData> getDayOptions() {
    return const [
      FamilyDayOptionFakeData(label: '7 أيام', isSelected: true),
      FamilyDayOptionFakeData(label: '14 أيام'),
      FamilyDayOptionFakeData(label: '30 أيام'),
    ];
  }

  FamilySelectionSummaryFakeData getSelectionSummary() {
    return const FamilySelectionSummaryFakeData(
      title: 'ملخص اختيار أحمد',
      rows: [
        FamilySelectionSummaryRowFakeData(
          label: 'البرنامج',
          value: 'متوازن',
          icon: FamilySelectionSummaryIcon.balance,
        ),
        FamilySelectionSummaryRowFakeData(
          label: 'الباقة',
          value: '4 وجبات + سناك',
          icon: FamilySelectionSummaryIcon.cutlery,
        ),
        FamilySelectionSummaryRowFakeData(
          label: 'عدد الأيام',
          value: '7 أيام',
          icon: FamilySelectionSummaryIcon.calendar,
        ),
        FamilySelectionSummaryRowFakeData(
          label: 'إضافة يوم الجمعة',
          value: 'مضاف',
          icon: FamilySelectionSummaryIcon.check,
        ),
        FamilySelectionSummaryRowFakeData(
          label: 'السعر الأسبوعي',
          value: '245 KWD',
          icon: FamilySelectionSummaryIcon.receipt,
          isPrice: true,
        ),
        FamilySelectionSummaryRowFakeData(
          label: 'السعر الشهري',
          value: '980 KWD',
          icon: FamilySelectionSummaryIcon.calendar,
          isPrice: true,
        ),
      ],
    );
  }
}

class FamilyProgramSetupMemberFakeData {
  const FamilyProgramSetupMemberFakeData({
    required this.name,
    required this.imageAsset,
    required this.status,
    this.isSelected = false,
    this.isInProgress = false,
  });

  final String name;
  final String imageAsset;
  final String status;
  final bool isSelected;
  final bool isInProgress;
}

class FamilyProgramSetupProgramFakeData {
  const FamilyProgramSetupProgramFakeData({
    required this.title,
    required this.description,
    required this.imageAsset,
    this.isSelected = false,
  });

  final String title;
  final String description;
  final String imageAsset;
  final bool isSelected;
}

class FamilyProgramSetupMemberDetailsFakeData {
  const FamilyProgramSetupMemberDetailsFakeData({
    required this.name,
    required this.imageAsset,
    required this.age,
    required this.gender,
    required this.goal,
    required this.activityLevel,
  });

  final String name;
  final String imageAsset;
  final String age;
  final String gender;
  final String goal;
  final String activityLevel;
}

enum FamilyPackageOptionIcon { cutlery, appleCutlery }

class FamilyPackageOptionFakeData {
  const FamilyPackageOptionFakeData({
    required this.title,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final String description;
  final FamilyPackageOptionIcon icon;
  final bool isSelected;
}

class FamilyDayOptionFakeData {
  const FamilyDayOptionFakeData({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;
}

enum FamilySelectionSummaryIcon { balance, cutlery, calendar, check, receipt }

class FamilySelectionSummaryFakeData {
  const FamilySelectionSummaryFakeData({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<FamilySelectionSummaryRowFakeData> rows;
}

class FamilySelectionSummaryRowFakeData {
  const FamilySelectionSummaryRowFakeData({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrice = false,
  });

  final String label;
  final String value;
  final FamilySelectionSummaryIcon icon;
  final bool isPrice;
}
