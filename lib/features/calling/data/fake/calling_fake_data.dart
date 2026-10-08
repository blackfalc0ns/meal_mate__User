import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/calling/data/models/call_driver_model.dart';

class CallingFakeData {
  CallingFakeData._();

  static const CallDriverModel defaultDriver = CallDriverModel(
    name: 'محمد علي',
    role: 'مندوب التوصيل',
    avatarAsset: AssetsFake.callingDriverAvatar,
    addressTitle: 'طلب توصيل',
    addressDetails: 'شارع الخليج العربي ، قطعة 12 ، منزل 45.\nالسلمانية',
  );
}
