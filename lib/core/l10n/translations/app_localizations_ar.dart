// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get error_no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_internet_connection_desc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال';

  @override
  String get error_connection_timeout_desc =>
      'استغرق الاتصال وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get error_receive_timeout => 'انتهت مهلة الاستقبال';

  @override
  String get error_receive_timeout_desc =>
      'استغرق الخادم وقتاً طويلاً للرد. يرجى المحاولة مرة أخرى';

  @override
  String get error_send_timeout => 'انتهت مهلة الإرسال';

  @override
  String get error_send_timeout_desc =>
      'فشل في إرسال البيانات إلى الخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_server_error => 'خطأ في الخادم';

  @override
  String get error_server_error_desc =>
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get error_internal_server_error => 'خطأ داخلي في الخادم';

  @override
  String get error_internal_server_error_desc =>
      'واجه الخادم خطأ داخلي. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_gateway => 'حدث خطأ مؤقت';

  @override
  String get error_bad_gateway_desc =>
      'حدث خطأ أثناء الاتصال بالخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة لاحقاً';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc =>
      'انتهت مهلة البوابة. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_request => 'طلب خاطئ';

  @override
  String get properties_empty_message_favourite =>
      'لم تقم بإضافة أي عقارات للمفضلة.';

  @override
  String get reviewsFor => 'مراجعات ل';

  @override
  String get error_bad_request_desc =>
      'يحتوي الطلب على بيانات غير صالحة. يرجى التحقق من المدخلات';

  @override
  String get error_unauthorized => 'غير مصرح للوصول';

  @override
  String get error_unauthorized_desc =>
      'أنت غير مصرح للوصول إلى هذا المورد. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden => 'الوصول مرفوض';

  @override
  String get error_forbidden_desc => 'ليس لديك إذن للوصول إلى هذا المورد';

  @override
  String get error_not_found => 'غير موجود';

  @override
  String get error_not_found_desc => 'المورد المطلوب غير موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc =>
      'هذه الطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';

  @override
  String get error_conflict => 'تعارض';

  @override
  String get error_conflict_desc => 'يوجد تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب لم يعد متاحاً';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'يجب أن يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حمولة الطلب كبيرة جداً';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل جداً';

  @override
  String get lead_send_error => 'حدث خطأ أثناء إرسال طلب التواصل';

  @override
  String get lead_info_collected => 'تم جمع معلومات العميل المحتمل بنجاح';

  @override
  String get lead_offline_mode => 'تم حفظ معلومات التواصل محلياً';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'لا يمكن تحقيق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'لا يمكن تلبية التوقع المحدد في حقل رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'لقد أرسلت طلبات كثيرة جداً. يرجى المحاولة لاحقاً';

  @override
  String get error_unknown => 'خطأ غير معروف';

  @override
  String get error_unknown_desc => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى';

  @override
  String get error_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_cancelled_desc => 'تم إلغاء الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'حدث خطأ. يرجى المحاولة مرة أخرى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get contact_support => 'تواصل مع الدعم';

  @override
  String get go_back => 'العودة';

  @override
  String get refresh => 'تحديث';

  @override
  String get check_connection => 'فحص الاتصال';

  @override
  String get login => 'تسجيل دخول';

  @override
  String get continue_as_guest => 'الدخول كزائر';

  @override
  String get name_is_required => 'الاسم مطلوب!';

  @override
  String get name_is_not_valid => 'الاسم مو صحيح';

  @override
  String get email_is_required => 'الإيميل مطلوب!';

  @override
  String get email_is_not_valid => 'الإيميل مو صحيح';

  @override
  String get password_is_required => 'كلمة المرور مطلوبة!';

  @override
  String get password_is_not_valid => 'كلمة المرور مو صحيحة';

  @override
  String get password_must_be_at_least_6_characters =>
      'كلمة المرور لازم تكون 6 أحرف على الأقل';

  @override
  String get passwords_do_not_match => 'كلمات المرور مو نفس الشي';

  @override
  String get confirm_password_is_required => 'تأكيد كلمة المرور مطلوب!';

  @override
  String get confirm_password_is_not_valid => 'تأكيد كلمة المرور مو صحيح';

  @override
  String get password_and_confirm_password_must_be_same =>
      'كلمة المرور وتأكيدها لازم يكونون نفس الشي';

  @override
  String get phone_number_is_required => 'رقم الجوال مطلوب!';

  @override
  String get phone_number_is_not_valid => 'رقم الجوال مو صحيح';

  @override
  String get this_field_is_required => 'هذا الحقل مطلوب';

  @override
  String get error => 'صار خطأ';

  @override
  String get error_bad_certificate => 'خطأ في شهادة الأمان';

  @override
  String get error_request_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_no_internet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_response => 'لا يوجد رد من الخادم';

  @override
  String get error_validation => 'خطأ في التحقق من البيانات';

  @override
  String get error_server => 'خطأ في الخادم';

  @override
  String get location_service_disabled => 'خدمات الموقع غير مفعّلة';

  @override
  String get location_permission_denied => 'تم رفض إذن الموقع';

  @override
  String get location_permission_denied_forever =>
      'تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات';

  @override
  String get location_service_disabled_message =>
      'يرجى تفعيل خدمات الموقع للمتابعة';

  @override
  String get location_permission_denied_message =>
      'يرجى منح إذن الموقع للمتابعة';

  @override
  String get location_permission_denied_forever_message =>
      'تم رفض إذن الموقع نهائياً. يرجى تفعيله من إعدادات الجهاز';

  @override
  String get verification_code_required => 'كود التحقق مطلوب';

  @override
  String get verification_code_invalid => 'كود التحقق غير صحيح';

  @override
  String get start_button => 'ابدأ الحين';

  @override
  String get welcome_back => 'مرحباً بك في';

  @override
  String get login_subtitle =>
      'سجل دخولك للوصول الى خطتك الغذائية ومتابعة أهدافك الصحية';

  @override
  String get login_title => 'تسجيل الدخول';

  @override
  String get phone_number => 'رقم الجوال';

  @override
  String get phone_hint => '000 000 00 00';

  @override
  String get password => 'كلمة المرور';

  @override
  String get password_hint => 'أدخل كلمة المرور';

  @override
  String get remember_me => 'تذكرني';

  @override
  String get forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get login_button => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get login_with_google => 'التسجيل بواسطة جوجل';

  @override
  String get dont_have_account => 'ليس لديك حساب؟';

  @override
  String get sign_up => 'اشتراك';

  @override
  String get auth_welcome_title => 'مرحباً بك في';

  @override
  String get auth_welcome_subtitle =>
      'سجل دخولك للوصول الى خطتك الغذائية ومتابعة أهدافك الصحية.';

  @override
  String get auth_sign_in_title => 'تسجيل الدخول';

  @override
  String get auth_sign_in_button => 'تسجيل الدخول';

  @override
  String get auth_no_account => 'ليس لديك حساب؟';

  @override
  String get auth_create_account_link => 'إنشاء حساب';

  @override
  String get auth_have_account_prompt => 'لديك حساب؟';

  @override
  String get auth_sign_in_link => 'تسجيل الدخول';

  @override
  String get auth_create_account_title => 'إنشاء حساب';

  @override
  String get auth_create_account_subtitle =>
      'انضم إلى MealMate وابدأ رحلتك الصحية.';

  @override
  String get auth_name_label => 'الاسم';

  @override
  String get auth_name_hint => 'أدخل الاسم';

  @override
  String get auth_confirm_password_label => 'تأكيد كلمة المرور';

  @override
  String get auth_confirm_password_hint => 'أعد إدخال كلمة المرور';

  @override
  String get auth_terms_label => 'الموافقة على الشروط والأحكام';

  @override
  String get auth_create_account_button => 'إنشاء حساب';

  @override
  String get auth_reset_password_title => 'تعيين كلمة مرور';

  @override
  String get auth_reset_password_subtitle =>
      'أدخل رقم الجوال لإرسال رمز OTP لإعادة التعيين.';

  @override
  String get auth_reset_password_hint => 'سنرسل رمز OTP إلى رقم جوالك.';

  @override
  String get auth_send_otp_button => 'إعادة تعيين كلمة المرور';

  @override
  String get auth_otp_title => 'أعد تعيين كلمة المرور الخاصة بك.';

  @override
  String get auth_otp_subtitle =>
      'أدخل رمز OTP المكون من 6 أرقام لإعادة التعيين.';

  @override
  String get auth_otp_hint => 'أدخل رمز OTP المكون من 6 أرقام للمتابعة.';

  @override
  String get auth_verify_code_button => 'إعادة تعيين كلمة المرور';

  @override
  String get auth_no_code_title => 'ألم تستلم الرمز؟';

  @override
  String get auth_resend_code => 'أعد إرسال الرمز';

  @override
  String get auth_resend_code_in => 'أعد إرسال الرمز خلال';

  @override
  String get auth_seconds_label => 'ثانية';

  @override
  String get auth_new_password_title => 'أعد تعيين كلمة المرور الخاصة بك.';

  @override
  String get auth_new_password_subtitle => 'أدخل كلمة المرور الجديدة.';

  @override
  String get auth_new_password_hint => 'أدخل كلمة المرور الجديدة';

  @override
  String get auth_new_password_label => 'كلمة المرور';

  @override
  String get auth_new_password_hint_field => 'أدخل كلمة المرور الجديدة';

  @override
  String get auth_new_password_button => 'إعادة تعيين كلمة المرور';

  @override
  String get onboarding_first_subtitle => 'رفيقك الصحي كل يوم.';

  @override
  String get onboarding_second_title => 'وجباتك الصحية واللذيذة';

  @override
  String get onboarding_second_subtitle => 'توصلك لباب بيتك...';

  @override
  String get onboarding_third_title => 'الاكل الصحي';

  @override
  String get onboarding_third_subtitle => 'يضبط المزاج!';

  @override
  String get skip => 'تخطي';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_meals => 'الوجبات';

  @override
  String get nav_offers => 'العروض';

  @override
  String get nav_subscription => 'الاشتراك';

  @override
  String get nav_profile => 'الملف الشخصي';

  @override
  String get coming_soon_subtitle =>
      'هذا القسم قيد التجهيز وسيكون متاحًا قريبًا.';

  @override
  String get offers_title => 'العروض';

  @override
  String get offers_hero_badge => 'لفترة محدودة';

  @override
  String get offers_hero_discount => '20%';

  @override
  String get offers_hero_title => 'خصم على الباقات الشهرية';

  @override
  String get offers_hero_subtitle => 'باقات طازجة تناسب روتينك اليومي';

  @override
  String get offers_hero_description =>
      'اختر الباقة المناسبة ليومك واستمتع بوجبات صحية مع توفير أكبر.';

  @override
  String get offers_hero_button => 'استفد الآن';

  @override
  String get offers_filter_all => 'الكل';

  @override
  String get offers_filter_offers => 'العروض';

  @override
  String get offers_filter_restaurants => 'المطاعم';

  @override
  String get offers_filter_meals => 'الوجبات';

  @override
  String get offers_featured_section_title => 'عروض مميزة';

  @override
  String get offers_view_all => 'عرض الكل';

  @override
  String get offers_restaurants_section_title => 'مطاعم رائجة';

  @override
  String get offers_invite_title => 'ادعُ أصدقاءك واربح';

  @override
  String get offers_invite_subtitle =>
      'شارك أصدقاءك عرضًا لذيذًا واحصل على مكافأتك الخاصة.';

  @override
  String get offers_invite_button => 'ادعُ الآن';

  @override
  String get offers_featured_button => 'احصل على العرض';

  @override
  String get offers_featured_burger_title => 'باقة برجر كينج';

  @override
  String get offers_featured_burger_subtitle =>
      'وجبة عائلية كبيرة مع البطاطس والمشروبات.';

  @override
  String get offers_featured_burger_discount => 'وفّر 15%';

  @override
  String get offers_featured_burger_badge => 'الأكثر مبيعًا';

  @override
  String get offers_featured_burger_delivery => 'التوصيل خلال 15 دقيقة';

  @override
  String get offers_featured_burger_reviews => '4.9';

  @override
  String get offers_featured_salad_title => 'وعاء البروتين';

  @override
  String get offers_featured_salad_subtitle => 'وجبات غنية بالبروتين ليوم أخف.';

  @override
  String get offers_featured_salad_discount => 'وفّر 12%';

  @override
  String get offers_featured_salad_badge => 'اختيار صحي';

  @override
  String get offers_featured_salad_delivery => 'التوصيل خلال 20 دقيقة';

  @override
  String get offers_featured_salad_reviews => '4.8';

  @override
  String get offers_featured_gift_title => 'عرض صندوق الهدايا';

  @override
  String get offers_featured_gift_subtitle =>
      'مثالي لإهداء أسبوع كامل من الوجبات.';

  @override
  String get offers_featured_gift_discount => 'وفّر 25%';

  @override
  String get offers_featured_gift_badge => 'جاهز للإهداء';

  @override
  String get offers_featured_gift_delivery => 'التوصيل خلال 30 دقيقة';

  @override
  String get offers_featured_gift_reviews => '5.0';

  @override
  String get offers_restaurant_burger_title => 'عرض برجر كينج';

  @override
  String get offers_restaurant_burger_subtitle =>
      'عرض خاص على الوجبات الكلاسيكية المفضلة.';

  @override
  String get offers_restaurant_burger_discount => 'خصم 30%';

  @override
  String get offers_restaurant_burger_badge => 'عرض سريع';

  @override
  String get offers_restaurant_burger_delivery => 'التوصيل خلال 15 دقيقة';

  @override
  String get offers_restaurant_burger_reviews => '4.9';

  @override
  String get offers_restaurant_mcdonalds_title => 'ماكدونالدز';

  @override
  String get offers_restaurant_mcdonalds_subtitle => 'خصم على جميع الأصناف.';

  @override
  String get offers_restaurant_mcdonalds_discount => 'خصم 30%';

  @override
  String get offers_restaurant_mcdonalds_badge => 'شائع';

  @override
  String get offers_restaurant_mcdonalds_delivery => 'التوصيل خلال 20 دقيقة';

  @override
  String get offers_restaurant_mcdonalds_reviews => '4.0';

  @override
  String get offers_restaurant_starbucks_title => 'ستاربكس';

  @override
  String get offers_restaurant_starbucks_subtitle =>
      'عرض خاص على المشروبات والوجبات الخفيفة.';

  @override
  String get offers_restaurant_starbucks_discount => 'خصم 30%';

  @override
  String get offers_restaurant_starbucks_badge => 'اختيار جديد';

  @override
  String get offers_restaurant_starbucks_delivery => 'التوصيل خلال 25 دقيقة';

  @override
  String get offers_restaurant_starbucks_reviews => '4.8';

  @override
  String get offers_restaurant_bowls_title => 'أوعية خضراء';

  @override
  String get offers_restaurant_bowls_subtitle => 'أطباق متوازنة بمكونات طازجة.';

  @override
  String get offers_restaurant_bowls_discount => 'خصم 20%';

  @override
  String get offers_restaurant_bowls_badge => 'الأعلى تقييمًا';

  @override
  String get offers_restaurant_bowls_delivery => 'التوصيل خلال 18 دقيقة';

  @override
  String get offers_restaurant_bowls_reviews => '4.8';

  @override
  String get offer_details_title => 'استرداد العرض';

  @override
  String get offer_details_hero_heading => 'خصم 20% على الباقات الشهرية';

  @override
  String get offer_details_hero_subtitle => 'خطط غذائية متكاملة';

  @override
  String get offer_details_hero_description => 'تساعدك على تحقيق أهدافك';

  @override
  String get offer_details_hero_timer_label => 'ينتهي خلال';

  @override
  String get offer_details_info_title => 'تفاصيل العرض';

  @override
  String get offer_details_info_summary => 'خصم 20% على جميع الباقات الشهرية';

  @override
  String get offer_details_info_duration_label => 'مدة العرض';

  @override
  String get offer_details_info_coupon_label => 'رمز الخصم';

  @override
  String get offer_details_info_terms_label => 'الشروط والأحكام';

  @override
  String get offer_details_info_terms_description =>
      'يسري العرض على الباقات الشهرية فقط ولا يمكن دمجه مع عروض أخرى.';

  @override
  String get offer_details_info_copy_code => 'نسخ الرمز';

  @override
  String get offer_details_plan_section_title => 'اختر الباقة المناسبة';

  @override
  String get offer_details_plan_month_title => 'باقة شهر';

  @override
  String get offer_details_plan_half_month_title => 'باقة نصف شهر';

  @override
  String get offer_details_plan_week_title => 'باقة أسبوع';

  @override
  String get offer_details_plan_duration_month => '26 يوم';

  @override
  String get offer_details_plan_duration_half_month => '12 يوم';

  @override
  String get offer_details_plan_duration_week => '6 أيام';

  @override
  String get offer_details_plan_meals => '4 وجبات يومياً';

  @override
  String get offer_details_summary_title => 'الإجمالي بعد الخصم';

  @override
  String get offer_details_summary_button => 'استكمال الشراء';

  @override
  String get offer_details_summary_secure_payment => 'عملية دفع آمنة';

  @override
  String get offer_details_open_plans_button => 'اختيار الباقة';
}
