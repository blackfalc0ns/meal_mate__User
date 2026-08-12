// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_brand_name => 'MealMate';

  @override
  String get app_brand_tagline => 'Your Daily Meal Mate';

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
      'انضم إلى MealMate وإبدأ رحلتك الصحية.';

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
  String get auth_register_success =>
      'تم إنشاء الحساب بنجاح وتم إرسال رمز OTP.';

  @override
  String get auth_login_success => 'تم تسجيل الدخول بنجاح.';

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
  String get auth_otp_sent_success => 'تم إرسال رمز OTP بنجاح.';

  @override
  String get auth_otp_title => 'تحقق من رقم هاتفك';

  @override
  String get auth_otp_subtitle =>
      'أدخل رمز OTP المكون من 6 أرقام المرسل إلى هاتفك.';

  @override
  String get auth_otp_hint => 'أدخل رمز OTP المكون من 6 أرقام للمتابعة.';

  @override
  String get auth_verify_code_button => 'تأكيد الرمز';

  @override
  String get auth_reset_password_otp_title => 'تأكيد رمز إعادة التعيين';

  @override
  String get auth_reset_password_otp_subtitle =>
      'أدخل رمز OTP المرسل إلى رقم جوالك.';

  @override
  String get auth_reset_password_otp_hint =>
      'أدخل الرمز للمتابعة إلى تعيين كلمة المرور الجديدة.';

  @override
  String get auth_reset_password_otp_button => 'متابعة';

  @override
  String get auth_no_code_title => 'ألم تستلم الرمز؟';

  @override
  String get auth_resend_code => 'أعد إرسال الرمز';

  @override
  String get auth_otp_resent_success => 'تم إعادة إرسال رمز OTP بنجاح.';

  @override
  String get auth_resend_code_in => 'أعد إرسال الرمز خلال';

  @override
  String get auth_seconds_label => 'ثانية';

  @override
  String get auth_new_password_title => 'تعيين كلمة مرور جديدة';

  @override
  String get auth_new_password_subtitle => 'أدخل كلمة مرور جديدة لحسابك.';

  @override
  String get auth_new_password_hint =>
      'اكتب كلمة المرور الجديدة لتتمكن من تسجيل الدخول';

  @override
  String get auth_new_password_label => 'كلمة المرور الجديدة';

  @override
  String get auth_new_password_hint_field => 'أدخل كلمة المرور الجديدة';

  @override
  String get auth_new_password_button => 'حفظ كلمة المرور';

  @override
  String get auth_reset_password_success => 'تم تغيير كلمة المرور بنجاح.';

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
  String get nav_meals => 'وجباتي';

  @override
  String get nav_offers => 'العروض';

  @override
  String get nav_subscription => 'الاشتراك';

  @override
  String get nav_profile => 'البروفايل';

  @override
  String get profile_user_name => 'أحمد محمد';

  @override
  String get profile_user_email => 'ahmed.mohamed@gemil.com';

  @override
  String get profile_premium_member => 'عضو مميز';

  @override
  String get profile_change_photo => 'تغيير صورة البروفايل';

  @override
  String get profile_photo_source_title => 'اختر صورة البروفايل';

  @override
  String get profile_photo_source_camera => 'الكاميرا';

  @override
  String get profile_photo_source_gallery => 'المعرض';

  @override
  String get profile_photo_upload_success => 'تم تحديث صورة البروفايل بنجاح.';

  @override
  String get profile_photo_upload_error =>
      'تعذر تحديث صورة البروفايل. حاول مرة أخرى.';

  @override
  String get profile_photo_permission_error =>
      'يرجى السماح للكاميرا أو الصور لتحديث صورة البروفايل.';

  @override
  String get profile_completed_plans => 'الخطط المكتملة';

  @override
  String get profile_streak_days => 'أيام متتالية';

  @override
  String get profile_points => 'نقاطك';

  @override
  String get profile_weight_lost => 'كجم فقدت';

  @override
  String get profile_personal_info => 'معلوماتي الشخصية';

  @override
  String get profile_personal_info_subtitle => 'تعديل بياناتك الشخصية';

  @override
  String get profile_personal_info_save => 'حفظ التغييرات';

  @override
  String get profile_personal_info_update_success =>
      'تم تحديث المعلومات الشخصية بنجاح.';

  @override
  String get profile_personal_info_update_error =>
      'تعذر تحديث المعلومات الشخصية. حاول مرة أخرى.';

  @override
  String get profile_goals => 'أهدافي';

  @override
  String get profile_goals_subtitle => 'إدارة أهدافك الصحية';

  @override
  String get profile_dietary_preferences => 'تفضيلاتي الغذائية';

  @override
  String get profile_dietary_preferences_subtitle => 'إدارة تفضيلاتك وحساسيتك';

  @override
  String get dietary_preferences_diet_title => 'النظام الغذائي';

  @override
  String get dietary_preferences_diet_balanced => 'متوازن';

  @override
  String get dietary_preferences_diet_vegetarian => 'نباتي';

  @override
  String get dietary_preferences_diet_vegan => 'نباتي صرف';

  @override
  String get dietary_preferences_diet_keto => 'كيتو';

  @override
  String get dietary_preferences_diet_high_protein => 'عالي البروتين';

  @override
  String get dietary_preferences_dislikes_title => 'الأطعمة غير المفضلة';

  @override
  String get dietary_preferences_dislike_onion => 'بصل';

  @override
  String get dietary_preferences_dislike_mushroom => 'فطر';

  @override
  String get dietary_preferences_dislike_olives => 'زيتون';

  @override
  String get dietary_preferences_dislike_coriander => 'كزبرة';

  @override
  String get dietary_preferences_allergies_title => 'الحساسية';

  @override
  String get dietary_preferences_allergy_nuts => 'مكسرات';

  @override
  String get dietary_preferences_allergy_lactose => 'لاكتوز';

  @override
  String get dietary_preferences_manage_allergies => 'إدارة الحساسية';

  @override
  String get dietary_preferences_notes_title => 'ملاحظات غذائية';

  @override
  String get dietary_preferences_notes_hint =>
      'مثال: أريد وجبات قليلة الصوديوم...';

  @override
  String get dietary_preferences_allergy_notice_title => 'معلومات حساسية مهمة';

  @override
  String get dietary_preferences_allergy_notice_message =>
      'تساعدنا معلومات الحساسية على تخصيص أطعمة آمنة لك وتجنب أي مكونات قد تؤثر على صحتك.';

  @override
  String get dietary_preferences_save => 'حفظ التفضيلات';

  @override
  String get add_allergy_title => 'إضافة الحساسية';

  @override
  String get add_allergy_subtitle =>
      'اختر الحساسية التي تعاني منها لتجنب عرض الوجبات غير المناسبة لك';

  @override
  String get add_allergy_selected => 'مختارة';

  @override
  String get add_allergy_current_allergies => 'حساسياتك الحالية';

  @override
  String get add_allergy_search_hint => 'ابحث عن مكون أو حساسية';

  @override
  String get add_allergy_sesame => 'سمسم';

  @override
  String get add_allergy_eggs => 'بيض';

  @override
  String get add_allergy_gluten => 'جلوتين';

  @override
  String get add_allergy_peanuts => 'فول سوداني';

  @override
  String get add_allergy_seafood => 'مأكولات بحرية';

  @override
  String get add_allergy_soy => 'صويا';

  @override
  String get add_allergy_wheat => 'قمح';

  @override
  String get add_allergy_fish => 'سمك';

  @override
  String get add_allergy_shellfish => 'قشريات';

  @override
  String get add_allergy_common_allergies => 'الحساسيات الشائعة';

  @override
  String get add_allergy_celery => 'كرفس';

  @override
  String get add_allergy_mustard => 'خردل';

  @override
  String get add_allergy_lupin => 'ترمس';

  @override
  String get add_allergy_note_title => 'ملاحظة مهمة';

  @override
  String get add_allergy_note_message =>
      'نعتمد على معلومات من المكونات المقدمة من شركائنا قد تحدث تغييرات في الوصفات';

  @override
  String get add_allergy_save => 'حفظ الحساسية';

  @override
  String get add_allergy_update_success => 'تم تحديث الحساسية بنجاح.';

  @override
  String get add_allergy_update_error => 'تعذر تحديث الحساسية. حاول مرة أخرى.';

  @override
  String get profile_billing => 'الاشتراكات والفواتير';

  @override
  String get profile_billing_subtitle => 'إدارة اشتراكك وتفاصيل الدفع';

  @override
  String get billing_plan_name => 'باقة اللياقة';

  @override
  String get billing_plan_tier => 'بلاتينيوم';

  @override
  String get billing_active => 'نشط';

  @override
  String get billing_renewal_date => 'تاريخ التجديد القادم: 15 يونيو 2025';

  @override
  String get billing_days_remaining => 'متبقي 18 يوم';

  @override
  String get billing_plan_usage => 'استخدام الخطة هذا الشهر';

  @override
  String get billing_plan_usage_value => '22 من 30 يوم';

  @override
  String get billing_plan_usage_current => '22';

  @override
  String get billing_plan_usage_remaining => 'من 30 يوم';

  @override
  String get billing_renew => 'تجديد';

  @override
  String get billing_freeze => 'تجميد';

  @override
  String get billing_cancel => 'إلغاء';

  @override
  String get billing_default_payment_method => 'وسيلة الدفع الافتراضية';

  @override
  String get billing_expiration_date => 'تاريخ الانتهاء';

  @override
  String get billing_invoices => 'الفواتير';

  @override
  String get billing_paid => 'مدفوع';

  @override
  String get billing_invoice_date => '15 مايو 2025';

  @override
  String get billing_manage_subscription => 'إدارة الاشتراك';

  @override
  String get billing_notice =>
      'يمكنك تجميد اشتراكك حتى 30 يوماً مرة واحدة كل 6 أشهر. عند الإلغاء، ستظل تتمتع بالمزايا حتى نهاية دورة الفوترة الحالية.';

  @override
  String get profile_addresses => 'العناوين';

  @override
  String get profile_addresses_subtitle => 'إدارة عناوين التوصيل';

  @override
  String get addresses_default => 'افتراضي';

  @override
  String get addresses_access_instructions => 'تعليمات الوصول';

  @override
  String get addresses_current_home => 'المنزل';

  @override
  String get addresses_current_home_details =>
      'شقة رقم 525\nشارع أحمد محمد\nالفيوم - مصر';

  @override
  String get addresses_saved_section => 'العناوين المحفوظة';

  @override
  String get addresses_home_address => '1174 طريق روي ألي، كولورادو 80205';

  @override
  String get addresses_work => 'العمل';

  @override
  String get addresses_work_address =>
      '1801 شارع كاليفورنيا، دنفر، كولورادو 80202';

  @override
  String get addresses_other => 'عنوان آخر';

  @override
  String get addresses_other_address =>
      '3200 شارع تشيري كريك الجنوبي، دنفر 80209';

  @override
  String get addresses_delivery_preferences => 'تفضيلات التوصيل';

  @override
  String get addresses_contact_on_arrival => 'التواصل عند الوصول';

  @override
  String get addresses_contact_on_arrival_description =>
      'سنرسل لك إشعاراً عند وصول المندوب';

  @override
  String get addresses_leave_at_door => 'اترك الطلب عند الباب';

  @override
  String get addresses_leave_at_door_description =>
      'ضع الطلب في مكان آمن عند الباب';

  @override
  String get addresses_add_new => 'إضافة عنوان جديد';

  @override
  String get addresses_availability_notice =>
      'قد تختلف الوجبات والمطاعم المتاحة بناءً على منطقة التوصيل';

  @override
  String get addresses_save => 'حفظ العنوان';

  @override
  String get addresses_choose_location_title => 'اختيار موقع البيت';

  @override
  String get addresses_choose_location_subtitle =>
      'اختر موقع التوصيل الأساسي للمنزل';

  @override
  String get addresses_confirm_location => 'تأكــــيـد المــوقـــع';

  @override
  String get addresses_home_address_title => 'عنوان المنزل';

  @override
  String get addresses_home_address_subtitle =>
      'أدخل عنوان منزلك لتحديد موقع التوصيل الأساسي';

  @override
  String get addresses_governorate_label => 'المحافظة';

  @override
  String get addresses_governorate_hint => 'اختر المحافظة';

  @override
  String get addresses_area_label => 'المنطقة';

  @override
  String get addresses_area_hint => 'اختر المنطقة';

  @override
  String get addresses_block_label => 'القطعة';

  @override
  String get addresses_block_hint => 'اختر القطعة';

  @override
  String get addresses_street_label => 'الشارع';

  @override
  String get addresses_street_hint => 'اكتب اسم الشارع';

  @override
  String get addresses_avenue_label => 'الجادة';

  @override
  String get addresses_avenue_hint => 'اكتب اسم الجادة';

  @override
  String get addresses_optional => '(اختياري)';

  @override
  String get addresses_building_type_label => 'نوع المبنى';

  @override
  String get addresses_building_type_home => 'منزل';

  @override
  String get addresses_building_type_building => 'بناية';

  @override
  String get addresses_floor_label => 'الدور';

  @override
  String get addresses_floor_hint => 'اختر الدور';

  @override
  String get addresses_building_number_label => 'رقم المنزل / البناية';

  @override
  String get addresses_building_number_hint => 'اكتب الرقم';

  @override
  String get addresses_apartment_number_label => 'رقم الشقة';

  @override
  String get addresses_apartment_number_hint => 'اكتب رقم الشقة';

  @override
  String get addresses_use_current_location => 'استخدام موقعي الحالي';

  @override
  String get addresses_use_current_location_subtitle =>
      'حدد موقعي الحالي كعنوان للبيت';

  @override
  String get profile_security => 'الأمان والخصوصية';

  @override
  String get profile_security_subtitle => 'تغيير كلمة المرور وإعدادات الخصوصية';

  @override
  String get profile_privacy_security_section => 'الأمان';

  @override
  String get profile_privacy_section => 'الخصوصية';

  @override
  String get profile_privacy_change_password => 'تغيير كلمة المرور';

  @override
  String get profile_privacy_change_password_subtitle =>
      'قم بتحديث كلمة المرور الخاصة بحسابك';

  @override
  String get profile_privacy_phone_verification => 'التحقق من رقم الجوال';

  @override
  String get profile_privacy_phone_verification_subtitle =>
      'تحقق من رقم جوالك لضمان أمان حسابك';

  @override
  String get profile_privacy_email_verification =>
      'التحقق من البريد الإلكتروني';

  @override
  String get profile_privacy_email_verification_subtitle =>
      'تحقق من بريدك الإلكتروني لتأمين حسابك';

  @override
  String get profile_privacy_location_permission => 'صلاحية الموقع';

  @override
  String get profile_privacy_location_permission_subtitle =>
      'إدارة الوصول إلى موقعك لتحسين الخدمات';

  @override
  String get profile_privacy_notifications => 'الإشعارات';

  @override
  String get profile_privacy_notifications_subtitle =>
      'تخصيص الإشعارات والتنبيهات';

  @override
  String get profile_privacy_policy => 'سياسة الخصوصية';

  @override
  String get profile_privacy_policy_subtitle =>
      'تعرّف على كيفية جمع واستخدام بياناتك';

  @override
  String get profile_privacy_terms => 'الشروط والأحكام';

  @override
  String get profile_privacy_terms_subtitle =>
      'اطلع على الشروط والأحكام الخاصة بالخدمة';

  @override
  String get profile_privacy_permissions_title =>
      'فعّل الأذونات لتحصل على تجربة أفضل';

  @override
  String get profile_privacy_permissions_message =>
      'تساعدنا الأذونات على تقديم خدمات أدق وتوصيات أكثر ملاءمة لك';

  @override
  String get profile_privacy_password_reminder_title =>
      'نوصي بتحديث كلمة المرور بانتظام';

  @override
  String get profile_privacy_password_reminder_message =>
      'تحديث كلمة المرور بشكل منتظم يزيد من أمان حسابك ويحمي بياناتك الشخصية';

  @override
  String get profile_privacy_manage_security => 'إدارة الأمان';

  @override
  String get coming_soon_subtitle =>
      'هذا القسم قيد التجهيز وسيكون متاحًا قريبًا.';

  @override
  String get drawer_guest_name => 'أحمد محمد';

  @override
  String get drawer_welcome => 'مرحباً بك ,';

  @override
  String get drawer_weight_loss_program => 'برنامج خسارة الوزن';

  @override
  String get drawer_month_package => 'باقة الشهر';

  @override
  String get drawer_account => 'الحساب';

  @override
  String get drawer_my_account => 'حسابي';

  @override
  String get drawer_payment_methods => 'وسائل الدفع';

  @override
  String get drawer_notifications => 'الإشعارات';

  @override
  String get drawer_subscription => 'الاشتراك';

  @override
  String get drawer_current_subscription => 'اشتراكي الحالي';

  @override
  String get drawer_family_members => 'أفراد العائلة';

  @override
  String get drawer_orders => 'الطلبات';

  @override
  String get drawer_previous_orders => 'الطلبات السابقة';

  @override
  String get drawer_track_current_order => 'تتبع الطلب الحالي';

  @override
  String get drawer_rewards_offers => 'المكافآت والعروض';

  @override
  String get drawer_points_rewards => 'النقاط والمكافآت';

  @override
  String get drawer_invite_friends => 'دعوة الأصدقاء';

  @override
  String get drawer_special_offers => 'العروض الخاصة';

  @override
  String get drawer_support_help => 'الدعم و المساعدة';

  @override
  String get drawer_technical_support => 'الدعم الفني';

  @override
  String get drawer_faq => 'الأسئلة الشائعة';

  @override
  String get drawer_contact_us => 'تواصل معنا';

  @override
  String get drawer_settings => 'الإعدادات';

  @override
  String get drawer_language => 'اللغة';

  @override
  String get drawer_logout => 'تسجيل الخروج';

  @override
  String get offers_title => 'العروض';

  @override
  String get offers_hero_badge => 'خصم';

  @override
  String get offers_hero_discount => '30%';

  @override
  String get offers_hero_title => 'خصم 30%';

  @override
  String get offers_hero_subtitle => 'على جميع الباقات';

  @override
  String get offers_hero_description => 'ابدأ رحلتك الصحية اليوم';

  @override
  String get offers_hero_button => 'اشترك الآن';

  @override
  String get offers_filter_all => 'الكل';

  @override
  String get offers_filter_offers => 'اشتراكات';

  @override
  String get offers_filter_restaurants => 'الكوبونات';

  @override
  String get offers_filter_meals => 'لفترة محدودة';

  @override
  String get offers_filter_gifts => 'الهدايا';

  @override
  String get offers_featured_section_title => 'عروض مميزة';

  @override
  String get offers_view_all => 'عرض الكل';

  @override
  String get offers_restaurants_section_title => 'مطاعم رائجة';

  @override
  String get offers_invite_title => 'ادع أصدقائك واحصل على';

  @override
  String get offers_invite_subtitle => 'خصم 30%';

  @override
  String get offers_invite_button => 'دعوة الأصدقاء';

  @override
  String get offers_coupon_prefix => 'استخدم ';

  @override
  String get offers_coupon_highlight => 'كود الخصم';

  @override
  String get offers_coupon_suffix => ' للحصول';

  @override
  String get offers_coupon_second_line => 'على خصم على اشتراكك';

  @override
  String get offers_coupon_button => 'استفد الآن';

  @override
  String get offers_countdown_label => 'ينتهي خلال';

  @override
  String get offers_countdown_value => '10:18:24';

  @override
  String get offers_featured_button => 'اشترك الآن';

  @override
  String get offers_featured_burger_title => 'الباقة الشهرية';

  @override
  String get offers_featured_burger_subtitle => 'وجبات متوازنة طول الشهر';

  @override
  String get offers_featured_burger_discount => '-20%';

  @override
  String get offers_featured_burger_badge => '-20%';

  @override
  String get offers_featured_burger_delivery => '10:18:24';

  @override
  String get offers_featured_burger_reviews => '4.9';

  @override
  String get offers_featured_salad_title => 'باقة البروتين';

  @override
  String get offers_featured_salad_subtitle => '20 وجبة غنية بالبروتين';

  @override
  String get offers_featured_salad_discount => 'الأكثر فائدة';

  @override
  String get offers_featured_salad_badge => 'اختيار صحي';

  @override
  String get offers_featured_salad_delivery => '10:18:24';

  @override
  String get offers_featured_salad_reviews => '4.8';

  @override
  String get offers_featured_gift_title => 'اشتراك 3 أشهر';

  @override
  String get offers_featured_gift_subtitle =>
      'توفير أكبر مع خطة غذائية متكاملة لثلاثة أشهر';

  @override
  String get offers_featured_gift_discount => '-15%';

  @override
  String get offers_featured_gift_badge => '-15%';

  @override
  String get offers_featured_gift_delivery => '10:18:24';

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
  String get offer_details_title => 'تفاصيل العرض';

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
  String get offer_details_info_coupon_label => 'كود الخصم للمستخدم';

  @override
  String get offer_details_info_terms_label => 'الشروط والأحكام';

  @override
  String get offer_details_info_terms_description =>
      'يسري العرض على الباقات الشهرية فقط ولا يمكن دمجه مع عروض أخرى.';

  @override
  String get offer_details_info_copy_code => 'نسخ';

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

  @override
  String get currency => 'د.ك';

  @override
  String get payment_title => 'الدفع';

  @override
  String get payment_order_summary_title => 'ملخص طلبك';

  @override
  String get payment_plan_month => 'باقة شهر';

  @override
  String get payment_plan_duration => '26 يوم';

  @override
  String get payment_plan_meals => '4 وجبات يومياً';

  @override
  String get payment_base_price_label => 'السعر الأساسي';

  @override
  String get payment_discount_label => 'الخصم(20%)';

  @override
  String get payment_total_after_discount => 'الإجمالي بعد الخصم';

  @override
  String get payment_coupon_hint => 'كود الخصم للمستخدم';

  @override
  String get payment_method_section_title => 'اختر طريقة الدفع';

  @override
  String get payment_method_mada => 'بطاقة مدى';

  @override
  String get payment_method_mada_subtitle => 'ادفع باستخدام بطاقات مدى';

  @override
  String get payment_method_visa => 'بطاقة ائتمانية / خصم مباشر';

  @override
  String get payment_method_visa_subtitle => 'Visa, Mastercard';

  @override
  String get payment_method_apple => 'Apple Pay';

  @override
  String get payment_method_apple_subtitle => 'ادفع باستخدام Apple pay';

  @override
  String get payment_method_wallet => 'محفظة MealMate';

  @override
  String get payment_method_wallet_balance => 'الرصيد المتاح :';

  @override
  String get payment_card_details_title => 'تفاصيل البطاقة';

  @override
  String get payment_card_number_label => 'رقم البطاقة';

  @override
  String get payment_card_number_hint => '•••• •••• •••• ••••';

  @override
  String get payment_expiry_hint => 'يوم / شهر';

  @override
  String get payment_cvv_hint => '•••';

  @override
  String get payment_expiry_label => 'تاريخ الانتهاء';

  @override
  String get payment_cvv_label => 'رمز التحقق';

  @override
  String get payment_card_holder_hint => 'الاسم كما هو على البطاقة';

  @override
  String get payment_card_holder_label => 'اسم حامل البطاقة';

  @override
  String get payment_total_label => 'الإجمالي المطلوب دفعه';

  @override
  String get payment_total_includes_tax => 'شامل الضريبة';

  @override
  String get payment_pay_now_button => 'ادفع الآن';

  @override
  String get payment_secure_label => 'عملية دفع آمنة';

  @override
  String get payment_success_title => 'تم الدفع بنجاح!';

  @override
  String get payment_success_subtitle =>
      'تم تفعيل اشتراكك. استمتع بوجباتك الصحية.';

  @override
  String get payment_success_button => 'العودة للرئيسية';

  @override
  String get subscription_screen_title => 'الباقات والاشتراكات';

  @override
  String get subscription_hero_title => 'وفر أكثر مع الباقات';

  @override
  String get subscription_hero_subtitle =>
      'اختر الباقة المناسبة لأسلوب حياتك واستمتع بوجبات صحية كل يوم';

  @override
  String get subscription_choose_plan_title => 'اختر الباقة التي تناسبك';

  @override
  String get subscription_choose_plan_button => 'اختر الباقة';

  @override
  String get subscription_individual_packages => 'الباقات الفردية';

  @override
  String get subscription_family_packages => 'الباقات العائلية';

  @override
  String get subscription_best_value => 'الأفضل قيمة';

  @override
  String get subscription_view_family_package => 'عرض الباقة العائلية';

  @override
  String get subscription_selected_program_label => 'البرنامج المختار :';

  @override
  String get subscription_weight_loss_title => 'خسارة الوزن';

  @override
  String get subscription_weight_loss_description =>
      'برنامج منخفض السعرات لمساعدتك على خسارة الوزن بطريقة صحية و آمنة';

  @override
  String get subscription_less_calories => 'سعرات أقل';

  @override
  String get subscription_effective_results => 'نتائج فعالة';

  @override
  String get subscription_four_meals_package => 'باقة 4 وجبات';

  @override
  String get subscription_four_meals_details => 'افطار - غداء - عشاء - سناك';

  @override
  String get subscription_three_meals_package => 'باقة 3 وجبات';

  @override
  String get subscription_three_meals_details => '14 يوم - 3 وجبات يومياً';

  @override
  String get subscription_two_meals_package => 'باقة وجبتين';

  @override
  String get subscription_two_meals_details => '7 يوم - وجبتين يومياً';

  @override
  String get subscription_month_plan_title => 'باقة شهر';

  @override
  String get subscription_month_package_prefix => 'باقة';

  @override
  String get subscription_month_package_highlight => 'الشهر';

  @override
  String get subscription_half_month_plan_title => 'باقة نصف شهر';

  @override
  String get subscription_week_plan_title => 'الأسبوع';

  @override
  String get subscription_week_plan_price => '930';

  @override
  String get subscription_month_duration => '26 أيام';

  @override
  String get subscription_duration_title => 'مدة الاشتراك';

  @override
  String get subscription_custom_duration => 'مخصص';

  @override
  String get subscription_add_friday => 'إضافة يوم الجمعة';

  @override
  String get subscription_days_range_hint =>
      'يمكنك إدخال أي عدد من الأيام (1-30 يوم)';

  @override
  String get subscription_day => 'يوم';

  @override
  String get subscription_half_month_duration => '12 أيام';

  @override
  String get subscription_week_duration => '7 أيام';

  @override
  String get subscription_meals_per_day => '4 وجبات يومياً';

  @override
  String get subscription_healthy_balanced => 'وجبات صحية ومتوازنة';

  @override
  String get subscription_free_delivery => 'توصيل مجاني';

  @override
  String get subscription_month_period => 'شهرياً';

  @override
  String get subscription_half_month_period => 'نصف شهر';

  @override
  String get subscription_week_period => 'أسبوعياً';

  @override
  String get subscription_discount_20 => 'خصم 20%';

  @override
  String get subscription_limited_discount => 'خصم 20% لفترة محدودة';

  @override
  String get subscription_note =>
      'كل الباقات تشمل خصم 20% على جميع الطلبات يمكنك الإيقاف المؤقت أو تعديل الباقة في أي وقت';

  @override
  String get subscription_program_title => 'اختر برنامجك';

  @override
  String get subscription_program_subtitle =>
      'اختر الهدف الذي يناسبك لنقدم لك الباقات المناسبة';

  @override
  String get subscription_type_title => 'اختر نوع الاشتراك';

  @override
  String get subscription_type_subtitle =>
      'ابدأ بتحديد ما إذا كنت تريد اشتراك فردي أو اشتراك عائلي';

  @override
  String get subscription_type_hero_label => 'أكل صحي ، حياة أفضل';

  @override
  String get subscription_type_individual_label => 'اشتراك فردي';

  @override
  String get subscription_type_individual_description =>
      'لشخص واحد مع برنامج غذائي يناسب هدفك';

  @override
  String get subscription_type_individual_restaurants => 'مطاعم متنوعة';

  @override
  String get subscription_type_individual_meal_flexibility =>
      'مرونة في عدد الوجبات';

  @override
  String get subscription_type_individual_customization => 'تخصيص البرنامج';

  @override
  String get subscription_type_family_label => 'اشتراك عائلي';

  @override
  String get subscription_type_family_description =>
      'أضف أفراد العائلة وحدد برنامجاً مناسبا لكل فرد';

  @override
  String get subscription_type_family_members => 'حتى 6 أفراد';

  @override
  String get subscription_type_family_customization => 'تخصيص لكل فرد';

  @override
  String get subscription_type_family_management => 'إدارة عائلية سهلة';

  @override
  String get subscription_type_notice_label =>
      'بعد اختيار نوع الاشتراك ستنتقل إلى الخطوة التالية';

  @override
  String get subscription_details_view_mode => 'طريقة العرض';

  @override
  String get subscription_details_explore_meals => 'استكشف وجبات الباقة';

  @override
  String get subscription_details_meals_count =>
      'أكثر من 120 وجبة متنوعة وصحية';

  @override
  String get subscription_details_popular_meals => 'أشهر الوجبات';

  @override
  String get subscription_details_features_title => 'مميزات الباقة';

  @override
  String get subscription_details_meal_suffix => 'وجبة';

  @override
  String get subscription_details_meals_in_plan => 'وجبة في الباقة';

  @override
  String get subscription_details_most_selected => 'الأكثر اختياراً';

  @override
  String get subscription_details_subscribe_now => 'اشترك الآن';

  @override
  String get subscription_restaurant_categories_title => 'استعراض التصنيفات';

  @override
  String get subscription_restaurant_categories_subtitle =>
      'كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.';

  @override
  String get subscription_tier_elite => 'سيليكت';

  @override
  String get subscription_tier_plus => 'بلس';

  @override
  String get subscription_tier_max => 'ماكس';

  @override
  String get subscription_summary_title => 'ملخص الاشتراك';

  @override
  String get subscription_summary_duration_label => 'المدة';

  @override
  String get subscription_summary_duration_value => 'شهر واحد';

  @override
  String get subscription_summary_package_label => 'الباقة';

  @override
  String get subscription_summary_restaurant_tier_label => 'تصنيف المطاعم';

  @override
  String get subscription_summary_restaurant_tier_value => 'بلاتينيوم';

  @override
  String get subscription_summary_includes_label => 'يشمل اشتراكك';

  @override
  String get subscription_summary_daily_meals =>
      '4 وجبات يومياً (إفطار - غداء - عشاء - سناك)';

  @override
  String get subscription_summary_restaurants => 'أكثر من 100 مطعم';

  @override
  String get subscription_summary_quality => 'مكونات عالية الجودة';

  @override
  String get subscription_summary_variety => 'تنوع يومي في الوجبات';

  @override
  String get subscription_summary_total_price_label => 'السعر الإجمالي';

  @override
  String get family_details_title => 'تفاصيل الباقة العائلية';

  @override
  String get family_plan_title => 'الباقة العائلية';

  @override
  String get family_plan_subtitle => 'خطة متكاملة حتى 6 أفراد';

  @override
  String get family_plan_new => 'جديد';

  @override
  String get family_manage_title => 'إدارة الباقة العائلية';

  @override
  String get family_manage_active => 'نشط';

  @override
  String get family_manage_instead_of => 'بدلا من';

  @override
  String get family_manage_ends_on => 'ينتهي في 26 مايو 2024';

  @override
  String get family_manage_family_members => 'أفراد العائلة';

  @override
  String get family_manage_show_all => 'عرض الكل';

  @override
  String get family_manage_quick_access => 'الوصول السريع';

  @override
  String get family_manage_meals => 'الوجبات';

  @override
  String get family_manage_subscription => 'الاشتراك';

  @override
  String get family_manage_invoice => 'الفاتورة';

  @override
  String get family_manage_permissions => 'الصلاحيات';

  @override
  String get family_manage_missing_selection => 'اختيار ناقص';

  @override
  String get family_manage_today_meals_status => 'حالة وجبات اليوم';

  @override
  String get family_manage_today_date => 'الاثنين 26 مايو';

  @override
  String get family_manage_meal_count_4 => '4/4 وجبات';

  @override
  String get family_manage_meal_count_2 => '2/4 وجبات';

  @override
  String get family_manage_meal_count_0 => '0/4 وجبة';

  @override
  String get family_manage_completed_status => 'مكتملة';

  @override
  String get family_manage_selected_status => 'تم الاختيار';

  @override
  String get family_manage_not_started_status => 'لم يبدأ';

  @override
  String get family_manage_complete_missing_meals => 'إكمال الوجبات الناقصة';

  @override
  String get family_manage_warning_title => 'يوجد أفراد لم يتم اختيار وجباتهم';

  @override
  String get family_manage_warning_message =>
      'يرجى اختيار وجبات اليوم للفرد : أحمد';

  @override
  String family_member_permissions_title(String memberName) {
    return 'الصلاحيات لـ $memberName';
  }

  @override
  String family_member_permissions_subtitle(String memberName) {
    return 'حدد ما يمكن لـ $memberName القيام به داخل حسابه';
  }

  @override
  String get family_member_permissions_note =>
      'يظل المدير العائلي هو المتحكم الأساسي في إعدادات\nالباقة العائلية ويمكنه تعديل الصلاحيات في أي وقت';

  @override
  String get family_member_permissions_save => 'حفظ';

  @override
  String get family_member_permissions_meals_section => 'الوجبات';

  @override
  String get family_member_permissions_program_section => 'البرنامج';

  @override
  String get family_member_permissions_settings_section => 'الحساب والإعدادات';

  @override
  String get family_member_permission_choose_daily_meals =>
      'اختيار وجباته اليومية';

  @override
  String get family_member_permission_edit_meals_before_lock =>
      'تعديل وجباته قبل وقت القفل';

  @override
  String get family_member_permission_view_meal_details => 'عرض تفاصيل الوجبات';

  @override
  String get family_member_permission_view_nutrition_program =>
      'عرض البرنامج الغذائي';

  @override
  String get family_member_permission_change_nutrition_program =>
      'تغيير البرنامج الغذائي';

  @override
  String get family_member_permission_edit_meals_and_days_count =>
      'تعديل عدد الوجبات والأيام';

  @override
  String get family_member_permission_edit_address => 'تعديل العنوان';

  @override
  String get family_member_permission_replace_meal => 'استبدال وجبة';

  @override
  String get family_member_permission_view_reports_and_payments =>
      'عرض التقارير والمدفوعات';

  @override
  String get family_member_permission_leave_family_plan =>
      'مغادرة الباقة العائلية';

  @override
  String get family_members_title => 'الأفراد';

  @override
  String get family_members_search_hint => 'ابحث عن فرد';

  @override
  String get family_members_add_member => 'إضافة فرد';

  @override
  String get family_plan_feature_group_delivery => 'توصيل مجمع';

  @override
  String get family_plan_feature_one_invoice => 'فاتورة واحدة';

  @override
  String get family_plan_feature_group_discount => 'خصم جماعي مميز';

  @override
  String get family_plan_feature_all_meals => 'وجبات تناسب الجميع';

  @override
  String get family_plan_feature_individual_plan => 'خطة لكل فرد';

  @override
  String get family_add_member => 'إضافة فرد جديد';

  @override
  String get family_add_member_subtitle => 'خصص خطة غذائية لكل فرد من عائلتك';

  @override
  String get family_edit_member => 'تعديل';

  @override
  String get family_owner => 'المالك';

  @override
  String get family_member_ahmed => 'أحمد';

  @override
  String get family_member_sarah => 'سارة';

  @override
  String get family_member_yousef => 'يوسف';

  @override
  String get family_member_mariam => 'مريم';

  @override
  String get family_member_laila => 'ليلى';

  @override
  String get family_member_omar => 'عمر';

  @override
  String get family_member_hana => 'هنا';

  @override
  String get family_member_khaled => 'خالد';

  @override
  String get family_summary_title => 'ملخص الباقة العائلية';

  @override
  String get family_current_members => 'عدد الأفراد الحالي';

  @override
  String get family_max_members => 'الحد الأقصى لأفراد الباقة';

  @override
  String get family_total_daily_meals => 'إجمالي الوجبات اليومية';

  @override
  String get family_total_daily_calories => 'إجمالي السعرات اليومية';

  @override
  String get family_one_delivery => 'توصيل واحد لكل أفراد العائلة';

  @override
  String get family_group_delivery => 'توصيل مجمع';

  @override
  String get family_meals_each_member => 'وجبات كل فرد';

  @override
  String get family_table_member => 'الفرد';

  @override
  String get family_table_breakfast => 'الإفطار';

  @override
  String get family_table_lunch => 'الغداء';

  @override
  String get family_table_snack => 'سناك';

  @override
  String get family_table_dinner => 'العشاء';

  @override
  String get family_table_meals_count => 'عدد الوجبات';

  @override
  String get family_meals_3 => '3 وجبات';

  @override
  String get family_meals_4 => '4 وجبات';

  @override
  String get family_meals_5 => '5 وجبات';

  @override
  String get family_price_details => 'تفاصيل السعر';

  @override
  String get family_base_price_two_members => 'السعر الأساسي (لـ 2 أفراد)';

  @override
  String get family_extra_members_price => 'أفراد إضافيون (2 x 7.500 KWD)';

  @override
  String get family_total => 'الإجمالي:';

  @override
  String get family_confirm_plan => 'تأكيد الباقة';

  @override
  String get family_add_member_dialog_subtitle =>
      'أدخل بيانات الفرد لإضافته إلى الباقة العائلية';

  @override
  String get family_full_name => 'الاسم الكامل';

  @override
  String get family_full_name_hint => 'اكتب الاسم هنا';

  @override
  String get family_relation => 'صلة القرابة';

  @override
  String get family_relation_hint => 'اختر صلة القرابة';

  @override
  String get family_age => 'العمر';

  @override
  String get family_age_hint => 'ادخل العمر';

  @override
  String get family_year => 'سنة';

  @override
  String get family_nutrition_goal => 'الهدف الغذائي';

  @override
  String get family_nutrition_goal_hint => 'اختر الهدف';

  @override
  String get family_activity_level => 'مستوى النشاط';

  @override
  String get family_activity_low => 'قليل النشاط';

  @override
  String get family_activity_medium => 'متوسط';

  @override
  String get family_activity_high => 'نشط';

  @override
  String get family_daily_meals_count => 'عدد الوجبات يومياً';

  @override
  String get family_info => 'معلومة';

  @override
  String get family_info_message =>
      'يمكنك تعديل البيانات في أي وقت من إعدادات الفرد';

  @override
  String get family_add_member_button => 'إضافة فرد';

  @override
  String get family_cancel => 'إلغاء';

  @override
  String get family_setup_title => 'إعداد اشتراك العائلة';

  @override
  String get family_setup_subtitle => 'خصص البرنامج المثالي لكل فرد في العائلة';

  @override
  String get family_name => 'اسم العائلة';

  @override
  String get family_name_hint => 'اكتب اسم العائلة هنا';

  @override
  String get family_location => 'الموقع';

  @override
  String get family_location_hint => 'اختر موقع الفرد';

  @override
  String get family_member_completed => 'مكتمل';

  @override
  String get family_next_program => 'التالي : البرنامج';

  @override
  String get family_header_badge => 'عائلة أحمد';

  @override
  String get family_setup_step_one => '1';

  @override
  String get family_setup_step_two => '2';

  @override
  String get family_setup_step_three => '3';

  @override
  String get family_step_create_family => 'انشاء العائلة';

  @override
  String get family_step_program => 'البرنامج';

  @override
  String get family_step_package_days => 'الباقة والأيام';

  @override
  String get family_step_payment => 'الدفع';

  @override
  String get family_member_not_started => 'لم يبدأ';

  @override
  String get family_member_in_progress => 'قيد الإعداد';

  @override
  String get family_selected_member_age => '24 سنة';

  @override
  String get family_selected_member_gender => 'ذكر';

  @override
  String get family_selected_member_goal_label => 'الـهـــــــدف';

  @override
  String get family_program_choose_title => 'اختر البرنامج المناسب';

  @override
  String get family_program_balanced_title => 'متوازن';

  @override
  String get family_program_balanced_description =>
      'نظام غذائي متوازن لطعام وصحة أفضل';

  @override
  String get family_program_weight_loss_title => 'خسارة وزن';

  @override
  String get family_program_weight_loss_description =>
      'سعرات أقل لدعم فقدان الوزن';

  @override
  String get family_program_muscle_title => 'بناء عضلات';

  @override
  String get family_program_muscle_description =>
      'غني بالبروتين لدعم بناء العضلات';

  @override
  String get family_program_keto_title => 'كيتو';

  @override
  String get family_program_keto_description =>
      'منخفض الكربوهيدرات وعالي الدهون';

  @override
  String get family_next_package_days => 'التالي : الباقة والأيام';

  @override
  String get family_previous_program => 'السابق : البرنامج';

  @override
  String get family_package_choose_title => '2. اختر الباقة وعدد الأيام';

  @override
  String get family_package_choose_subtitle => 'اختر الباقة المناسبة';

  @override
  String get family_package_three_meals_title => '3 وجبات يومياً';

  @override
  String get family_package_three_meals_description =>
      'تشمل الإفطار والغداء والعشاء';

  @override
  String get family_package_two_meals_title => 'وجبتين يومياً';

  @override
  String get family_package_two_meals_description => 'تشمل الغداء والعشاء';

  @override
  String get family_days_choose_title => 'اختر عدد الأيام في الأسبوع';

  @override
  String get family_days_7 => '7 أيام';

  @override
  String get family_days_14 => '14 أيام';

  @override
  String get family_days_30 => '30 أيام';

  @override
  String get family_friday_delivery_title => 'إضافة يوم الجمعة';

  @override
  String get family_friday_delivery_subtitle => 'أضف توصيل الجمعة لهذا الفرد';

  @override
  String get family_friday_delivery_added => 'مضاف';

  @override
  String get family_weekly_price => 'السعر الأسبوعي';

  @override
  String get family_weekly_price_value => '245 KWD';

  @override
  String get family_monthly_price => 'السعر الشهري';

  @override
  String get family_monthly_price_value => '980 KWD';

  @override
  String get family_member_selection_summary => 'ملخص اختيار أحمد';

  @override
  String get family_payment_note =>
      'بعد إتمام الدفع ، سيتمكن كل فرد من اختيار مطاعمه ووجباته المفضلة من قائمة المطاعم المتاحة لكل مدينة';

  @override
  String get family_payment_confirm_title => '3. الدفع وتأكيد الاشتراك';

  @override
  String get family_subscription_summary => 'ملخص الاشتراك';

  @override
  String get family_primary_member => 'عضو رئيسي';

  @override
  String get family_subscription_program_label => 'البرنامج';

  @override
  String get family_subscription_package_label => 'الباقة';

  @override
  String get family_subscription_days_label => 'عدد الأيام';

  @override
  String get family_subscription_program_value => 'متوازن';

  @override
  String get family_subscription_package_value => '4 وجبات + سناك';

  @override
  String get family_subscription_days_value => '7 أيام في الأسبوع';

  @override
  String get family_price_duration_total => 'إجمالي المدة';

  @override
  String get family_price_discount => 'خصم العائلة (10%)';

  @override
  String get family_price_tax_total => 'الإجمالي شامل الضريبة (15)';

  @override
  String get family_monthly_total_label => 'الإجمالي الشهري (4 أسابيع)';

  @override
  String get family_payment_method_title => 'طريقة الدفع';

  @override
  String get family_payment_card_label => 'بطاقة ائتمانية';

  @override
  String get family_payment_apple_pay_label => 'Apple Pay';

  @override
  String get family_payment_mada_label => 'مدى';

  @override
  String get family_overview_title => 'نظرة عامة على العائلة';

  @override
  String get family_confirm_payment => 'تأكيد الدفع';

  @override
  String get family_next_payment => 'التالي : الدفع';

  @override
  String get calendar_title => 'تقويم الوجبات';

  @override
  String get calendar_month_progress => 'تقدم الشهر';

  @override
  String get calendar_month_progress_value => 'أكملت 30 يوماً من أصل 30';

  @override
  String get calendar_commitment => 'التزام ممتاز 👏';

  @override
  String get calendar_change_meal => 'تغيير وجبة';

  @override
  String get calendar_pause => 'إيقاف مؤقت';

  @override
  String get calendar_add_meal => 'إضافة وجبة';

  @override
  String get calendar_reschedule => 'تأجيل الوجبة';

  @override
  String get calendar_full_plan => 'الخطة الكاملة';

  @override
  String get calendar_week => 'الأسبوع';

  @override
  String get calendar_today => 'اليوم';

  @override
  String get calendar_day_plan => 'خطة يوم 25 سبتمبر';

  @override
  String calendar_day_plan_date(String date) {
    return 'خطة يوم $date';
  }

  @override
  String get calendar_scheduled_count => '4 وجبات مجدولة لهذا اليوم';

  @override
  String get calendar_completed => 'مكتملة';

  @override
  String get calendar_current => 'الحالية';

  @override
  String get calendar_upcoming => 'قادمة';

  @override
  String get calendar_breakfast_time => 'الإفطار • 07:30 ص';

  @override
  String get calendar_breakfast_meal => 'شوفان بالفواكه والعسل';

  @override
  String get calendar_breakfast_calories => '450 سعرة حرارية';

  @override
  String get calendar_lunch_time => 'الغداء • 01:00 م';

  @override
  String get calendar_lunch_meal => 'دجاج مشوي مع أرز بني';

  @override
  String get calendar_lunch_calories => '550 سعرة';

  @override
  String get calendar_lunch_protein => '32g بروتين';

  @override
  String get calendar_dinner_time => 'العشاء • 07:00 م';

  @override
  String get calendar_dinner_meal => 'ساندويتش دجاج صحي';

  @override
  String get calendar_dinner_calories => '420 سعرة';

  @override
  String get calendar_snack_time => 'وجبة خفيفة • 09:00 م';

  @override
  String get calendar_snack_meal => 'وجبة فواكه طازجة';

  @override
  String get calendar_snack_calories => '180 سعرة';

  @override
  String get calendar_friday => 'الجمعة';

  @override
  String get calendar_saturday => 'السبت';

  @override
  String get calendar_sunday => 'الأحد';

  @override
  String get calendar_monday => 'الإثنين';

  @override
  String get calendar_tuesday => 'الثلاثاء';

  @override
  String get calendar_wednesday => 'الأربعاء';

  @override
  String get calendar_thursday => 'الخميس';

  @override
  String get calendar_weekday_sat_short => 'سبت';

  @override
  String get calendar_weekday_sun_short => 'احد';

  @override
  String get calendar_weekday_mon_short => 'اثنين';

  @override
  String get calendar_weekday_tue_short => 'ثلاثاء';

  @override
  String get calendar_weekday_wed_short => 'اربعاء';

  @override
  String get calendar_weekday_thu_short => 'خميس';

  @override
  String get calendar_weekday_fri_short => 'جمعة';

  @override
  String get calendar_ingredients => 'المكونات';

  @override
  String get calendar_calories => 'سعرة حرارية';

  @override
  String get calendar_protein => 'بروتين';

  @override
  String get calendar_carbs => 'كربوهيدرات';

  @override
  String get calendar_fat => 'دهون';

  @override
  String get calendar_breakfast => 'الإفطار';

  @override
  String get calendar_lunch => 'الغداء';

  @override
  String get calendar_dinner => 'العشاء';

  @override
  String calendar_meals_for(String mealType) {
    return 'وجبات $mealType';
  }

  @override
  String get calendar_restaurant_name => 'اسم المطعم';

  @override
  String get calendar_restaurant_description =>
      'نقدم وجبات صحية عالية الجودة باستخدام مكونات طازجة\nوطبيعية لمساعدتك على تحقيق أهدافك الغذائية والرياضية.';

  @override
  String get calendar_ingredient_origin_title => 'بلد المنشأ للمكونات الأساسية';

  @override
  String get calendar_meat => 'اللحوم';

  @override
  String get calendar_poultry => 'الدواجن';

  @override
  String get calendar_fish => 'الأسماك';

  @override
  String get calendar_oils => 'الزيوت';

  @override
  String get calendar_imported => 'مستوردة';

  @override
  String get calendar_fresh_local => 'طازجة محلية';

  @override
  String get calendar_australia => 'أستراليا';

  @override
  String get calendar_local => 'محلي';

  @override
  String get calendar_norway => 'النرويج';

  @override
  String get calendar_spain => 'إسبانيا';

  @override
  String get calendar_meal_name => 'اسم الوجبة';

  @override
  String get calendar_meal_overnight_oats => 'شوفان بالتوت والمكسرات';

  @override
  String get calendar_meal_egg_avocado_toast => 'توست البيض والأفوكادو';

  @override
  String get calendar_meal_greek_yogurt_parfait => 'زبادي يوناني بالفواكه';

  @override
  String get calendar_meal_turkey_cheese_wrap => 'راب تركي بالجبن';

  @override
  String get calendar_meal_banana_protein_pancakes => 'بان كيك بروتين بالموز';

  @override
  String get calendar_meal_smoked_salmon_bagel => 'بيجل السلمون المدخن';

  @override
  String get calendar_meal_grilled_chicken_bowl => 'بول دجاج مشوي بالكينوا';

  @override
  String get calendar_meal_salmon_rice_plate => 'طبق سلمون مع أرز';

  @override
  String get calendar_meal_beef_vegetable_box => 'بوكس لحم وخضار';

  @override
  String get calendar_meal_shrimp_noodle_bowl => 'بول نودلز بالجمبري';

  @override
  String get calendar_meal_chicken_caesar_wrap => 'راب سيزر بالدجاج';

  @override
  String get calendar_meal_veggie_pasta_box => 'بوكس باستا بالخضار';

  @override
  String get calendar_meal_lemon_chicken_salad => 'سلطة دجاج بالليمون';

  @override
  String get calendar_meal_tuna_potato_plate => 'طبق تونة وبطاطس';

  @override
  String get calendar_meal_steak_mushroom_plate => 'ستيك بالمشروم';

  @override
  String get calendar_meal_chicken_soup_box => 'بوكس شوربة الدجاج';

  @override
  String get calendar_meal_halloumi_salad => 'سلطة حلومي';

  @override
  String get calendar_meal_light_fajita_bowl => 'بول فاهيتا لايت';

  @override
  String get calendar_grilled_chicken => 'دجاج مشوي';

  @override
  String get calendar_brown_rice => 'أرز بني';

  @override
  String get calendar_broccoli => 'بروكلي';

  @override
  String get calendar_carrot => 'جزر';

  @override
  String get calendar_more => 'المزيد ..';

  @override
  String get calendar_browse_restaurants => 'استعراض المطاعم';

  @override
  String get calendar_choose_restaurant_for_day =>
      'اختر المطعم الذي تفضله ليوم ';

  @override
  String get calendar_restaurant_picker_date => 'السبت 20 سبتمبر';

  @override
  String get calendar_search_restaurant_hint => 'ابحث عن مطعم أو نوع مطبخ...';

  @override
  String get calendar_meal_suffix => ' وجبة';

  @override
  String get calendar_change_restaurant => 'تغيير المطعم';

  @override
  String get calendar_pick_restaurant_first => 'اختيار ';

  @override
  String get calendar_pick_restaurant_second => 'مطعم';

  @override
  String get meal_details_optional_notes_title => 'ملاحظات اختيارية';

  @override
  String get meal_details_optional_notes_hint =>
      'مثال: بدون بصل، بدون ثوم، زيادة خضار...';

  @override
  String get meal_details_select_meal_button => 'اختيار هذه الوجبة';

  @override
  String get meal_details_select_meal_hint =>
      'سيتم تثبيت هذه الوجبة لليوم المختار';

  @override
  String get profile_settings_title => 'إعدادات التطبيق';

  @override
  String get profile_settings_application_section => 'التطبيق';

  @override
  String get profile_settings_notifications => 'الإشعارات';

  @override
  String get profile_settings_notifications_subtitle =>
      'إدارة تفضيلات الإشعارات والتنبيهات';

  @override
  String get profile_settings_language => 'اللغة';

  @override
  String get profile_settings_language_subtitle => 'اختر لغة التطبيق المفضلة';

  @override
  String get profile_settings_appearance => 'المظهر';

  @override
  String get profile_settings_appearance_subtitle =>
      'اختر نمط العرض الذي يناسبك';

  @override
  String get profile_settings_support_section => 'الدعم';

  @override
  String get profile_settings_help_center => 'مركز المساعدة';

  @override
  String get profile_settings_help_center_subtitle =>
      'ابحث عن إجابات الأسئلة الشائعة';

  @override
  String get profile_settings_contact_us => 'تواصل معنا';

  @override
  String get profile_settings_contact_us_subtitle => 'راسل فريق دعم MealMate';

  @override
  String get profile_settings_complaints => 'الشكاوى';

  @override
  String get profile_settings_complaints_subtitle =>
      'قدّم شكواك وسنراجعها في أقرب وقت';

  @override
  String get profile_settings_information_section => 'معلومات';

  @override
  String get profile_settings_about => 'عن MealMate';

  @override
  String get profile_settings_about_subtitle => 'تعرّف على رؤيتنا ومهمتنا';

  @override
  String get profile_settings_privacy_policy => 'سياسة الخصوصية';

  @override
  String get profile_settings_privacy_policy_subtitle =>
      'تعرّف على كيفية حماية بياناتك';

  @override
  String get profile_settings_terms => 'الشروط والأحكام';

  @override
  String get profile_settings_terms_subtitle =>
      'الشروط والأحكام الخاصة باستخدام التطبيق';

  @override
  String get profile_settings_version => 'إصدار التطبيق';

  @override
  String get profile_settings_version_subtitle => 'أنت تستخدم أحدث إصدار';

  @override
  String get profile_settings_version_label => 'الإصدار 2.4.0';

  @override
  String get health_goals_title => 'أهدافي الصحية';

  @override
  String get health_goals_current_goal => 'هدفك الحالي';

  @override
  String get health_goals_weight_loss => 'خسارة الوزن';

  @override
  String get health_goals_current_weight => 'الوزن الحالي';

  @override
  String get health_goals_target_weight => 'الوزن المستهدف';

  @override
  String get health_goals_progress => 'التقدم';

  @override
  String get health_goals_body_data => 'بيانات الجسم';

  @override
  String get health_goals_height => 'الطول';

  @override
  String get health_goals_activity_level => 'مستوى النشاط';

  @override
  String get health_goals_activity_low => 'منخفض';

  @override
  String get health_goals_activity_medium => 'متوسط';

  @override
  String get health_goals_activity_active => 'نشيط';

  @override
  String get health_goals_activity_high => 'نشاط عالي';

  @override
  String get health_goals_weekly_summary => 'ملخص هذا الأسبوع';

  @override
  String get health_goals_decrease => 'انخفاض';

  @override
  String get health_goals_since_plan_start => 'منذ بداية خطتك';

  @override
  String get health_goals_days => '45 يوم';

  @override
  String get health_goals_continuous => 'متتالي';

  @override
  String get health_goals_keep_progress => 'استمر على هذا التقدم الرائع';

  @override
  String get health_goals_save => 'حفظ الأهداف';

  @override
  String get health_goals_weight_value => '78 كجم';

  @override
  String get health_goals_target_weight_value => '72 كجم';

  @override
  String get health_goals_height_value => '175 سم';

  @override
  String get health_goals_progress_value => '60%';

  @override
  String get health_goals_decrease_value => '4.2 كجم';

  @override
  String get search_hint => 'ابحث عن وجبة، مطعم، أو خطة صحية';

  @override
  String get search_cancel => 'إلغاء';

  @override
  String get search_recent => 'عمليات البحث الأخيرة';

  @override
  String get search_popular => 'الأكثر بحثاً';

  @override
  String get search_categories => 'فئات سريعة';

  @override
  String get search_recommended => 'مقترح لك';

  @override
  String get search_quick_results => 'نتائج سريعة';

  @override
  String get search_suggestions_all => 'عرض جميع الاقتراحات';

  @override
  String get search_filter_all => 'الكل';

  @override
  String get search_filter_meals => 'وجبات';

  @override
  String get search_filter_restaurants => 'مطاعم';

  @override
  String get search_filter_plans => 'خطط';

  @override
  String get search_filter_title => 'تصفية النتائج';

  @override
  String get search_filter_programs => 'البرامج';

  @override
  String get search_filter_weight_gain => 'زيادة الوزن';

  @override
  String get search_filter_muscle_gain => 'زيادة العضلات';

  @override
  String get search_filter_allergy_suitable => 'مناسب للحساسية';

  @override
  String get search_filter_apply => 'تطبيق الفلتر';

  @override
  String get search_filter_reset => 'إعادة التعيين';

  @override
  String get search_filter_calories_unit => 'كالوري';

  @override
  String get search_filter_grams_unit => 'غ';

  @override
  String get search_recent_grilled_chicken => 'دجاج مشوي';

  @override
  String get search_recent_healthy_restaurants => 'مطاعم دجاج صحية';

  @override
  String get search_recent_high_protein => 'وجبات عالية البروتين';

  @override
  String get search_category_salad => 'سلطات صحية';

  @override
  String get search_category_protein => 'وجبات بروتين';

  @override
  String get search_category_juice => 'عصائر ومشروبات';

  @override
  String get search_category_snack => 'وجبات منخفضة';

  @override
  String get search_category_salad_subtitle => 'خيارات خفيفة';

  @override
  String get search_category_protein_subtitle => 'مشبعة ومتوازنة';

  @override
  String get search_category_juice_subtitle => 'طبيعية ومنعشة';

  @override
  String get search_category_snack_subtitle => 'سعرات حرارية';

  @override
  String get search_meal_badge => 'وجبة مميزة';

  @override
  String get search_restaurant_badge => 'مطعم صحي';

  @override
  String get search_meal_title => 'دجاج مشوي مع كينوا';

  @override
  String get search_meal_description => 'وجبة متوازنة غنية بالبروتين والألياف';

  @override
  String get search_restaurant_title => 'جرين لايت كيتشن';

  @override
  String get search_restaurant_description => 'خيارات صحية طبيعية ومغذية';

  @override
  String get search_show_details => 'عرض التفاصيل';

  @override
  String get search_show_restaurant => 'عرض المطعم';

  @override
  String get search_calories => '550 سعرة حرارية';

  @override
  String get search_protein => '35 جم بروتين';

  @override
  String get search_carbs => '55 جم كربوهيدرات';

  @override
  String get search_fat => '18 جم دهون';

  @override
  String get search_open => 'مفتوح';

  @override
  String get search_empty_query => 'سوشي كيتو';

  @override
  String get search_empty_title => 'لم نعثر على نتائج مناسبة';

  @override
  String get search_empty_message_prefix => 'لم نجد أي نتائج ل “ ';

  @override
  String get search_empty_message_suffix => ' ”';

  @override
  String get search_empty_description =>
      'جرب كلمة مفتاحية أخرى أو استكشف الخيارات المتاحة';

  @override
  String get search_empty_suggestions_title => 'اقتراحات قد تهمك';

  @override
  String get search_empty_nearby_restaurants => 'مطاعم قريبة';

  @override
  String get search_empty_explore => 'العودة للاستكشاف';

  @override
  String get search_empty_clear => 'مسح البحث';

  @override
  String get search_cuisine_fast_food => 'الوجبات السريعة';

  @override
  String get search_cuisine_chicken => 'فرخة';

  @override
  String get search_cuisine_rice => 'أرز';

  @override
  String get search_minutes => '15-20 دقيقة';

  @override
  String get search_rating => '4.0';

  @override
  String get home_greeting => 'مرحبًا محمد';

  @override
  String get home_greeting_subtitle => 'جاهز ليوم صحي رائع؟';

  @override
  String get home_main_nutrients => 'المغذيات الرئيسية';

  @override
  String get nutrition_details_title => 'تفاصيل المغذيات الرئيسية';

  @override
  String get nutrition_details_date_prefix => 'اليوم - السبت ';

  @override
  String get nutrition_details_date_day => '24';

  @override
  String get nutrition_details_date_suffix => ' مايو';

  @override
  String get nutrition_details_burned => 'أحرقت';

  @override
  String get nutrition_details_goal => 'الهدف';

  @override
  String get nutrition_details_remaining => 'المتبقي';

  @override
  String get nutrition_details_calorie_unit => 'سعرة';

  @override
  String get nutrition_details_fiber => 'الألياف';

  @override
  String get nutrition_details_sugar => 'السكر';

  @override
  String get nutrition_details_macro_separator => ' / ';

  @override
  String get nutrition_details_gram_suffix => ' جم';

  @override
  String nutrition_details_percent_value(int percent) {
    return '%$percent';
  }

  @override
  String get nutrition_details_tip_title => 'نصيحة اليوم';

  @override
  String get nutrition_details_tip_message =>
      'أنت على الطريق الصحيح! حاول زيادة البروتين\nوشرب المزيد من الماء لتحقيق هدفك اليومي.';

  @override
  String get home_protein => 'البروتين';

  @override
  String get home_protein_value => '89';

  @override
  String get home_protein_goal => '120 جم';

  @override
  String get home_carbs => 'الكربوهيدرات';

  @override
  String get home_carbs_value => '210';

  @override
  String get home_carbs_goal => '260 جم';

  @override
  String get home_fat => 'الدهون';

  @override
  String get home_fat_value => '58';

  @override
  String get home_fat_goal => '70 جم';

  @override
  String get home_remaining_calories => 'السعرات المتبقية';

  @override
  String get home_remaining_calories_value => '560';

  @override
  String get home_calories_of_goal => 'من 2000 سعرة';

  @override
  String get home_details => 'عرض التفاصيل';

  @override
  String get home_search_hint => 'ابحث عن وجبات أو مطاعم';

  @override
  String get home_subscribe_now => 'اشترك الآن';

  @override
  String get home_today_meals => 'وجبات اليوم';

  @override
  String get home_restaurants => 'المطاعم';

  @override
  String get home_view_calendar => 'عرض التقويم';

  @override
  String get home_next_box => 'الصندوق القادم';

  @override
  String get home_delivery_time => 'الساعة 11 ص - 3 م';

  @override
  String get home_edit_meals => 'تعديل الوجبات';

  @override
  String get home_next_week_meals => 'يمكنك تعديل وجبات الأسبوع القادم';

  @override
  String get home_reminder => 'تذكير مهم';

  @override
  String get home_reminder_copy => 'لديك 72 ساعة قبل تجهيز صندوقك القادم.';

  @override
  String get home_promo_discount => 'خصم 30%';

  @override
  String get home_promo_all_subscriptions => 'على جميع الاشتراكات';

  @override
  String get home_shortcut_offers => 'العروض';

  @override
  String get home_shortcut_allergy => 'الحساسية';

  @override
  String get home_shortcut_subscription => 'اشتراكي';

  @override
  String get home_shortcut_my_meals => 'وجباتي';

  @override
  String get home_meal_omelet_vegetables => 'أومليت بالخضار';

  @override
  String get home_meal_omelet_calories => '430 سعرة';

  @override
  String get home_meal_chicken_calories => '650 سعرة';

  @override
  String get home_meal_herb_salmon => 'سلمون بالأعشاب';

  @override
  String get home_meal_salmon_calories => '520 سعرة';

  @override
  String get home_restaurant_protein_kitchen => 'بروتين كيتشن';

  @override
  String get home_restaurant_healthy_bite => 'هيلثي بايت';

  @override
  String get home_restaurant_diet_house => 'دايت هاوس';

  @override
  String get home_restaurant_balanced_meals => 'وجبات صحية متوازنة';

  @override
  String get home_restaurant_browse => 'استعراض';

  @override
  String get home_calendar_card_title => 'التقويم';

  @override
  String get home_calendar_card_subtitle => 'استعرض وجباتك القادمة';

  @override
  String get home_subscription_tab => 'الاشتراك';

  @override
  String get home_nutrition_tab => 'التغذية';

  @override
  String get home_current_plan => 'الخطة الحالية';

  @override
  String get home_weight_loss_program => 'برنامج خسارة الوزن';

  @override
  String get home_renewal_date => 'تتجدد في 24 يونيو 2026';

  @override
  String get home_average_calories => 'متوسط السعرات';

  @override
  String get home_average_calories_value => '612';

  @override
  String get home_calories_per_meal => 'سعرة / وجبة';

  @override
  String get home_completed_meals => 'الوجبات المكتملة';

  @override
  String get home_completed_meals_value => '18';

  @override
  String get home_completed_meals_total => 'من 30 وجبة';

  @override
  String get home_subscription_days_value => '12';

  @override
  String get home_days_remaining_label => 'يوماً متبقية';

  @override
  String get home_subscription_days_total => 'من 30 يوم';

  @override
  String get home_subscription_days_total_alt => 'من 30 يوماً';

  @override
  String get home_subscription_details => 'تفاصيل الاشتراك';

  @override
  String get home_next_delivery => 'التوصيل القادم';

  @override
  String get home_tomorrow => 'غداً';

  @override
  String get home_before_noon => 'قبل 12:00 م';

  @override
  String get home_commitment => 'الالتزام';

  @override
  String get home_commitment_value => '%86';

  @override
  String get home_excellent_performance => 'أداء ممتاز';

  @override
  String get home_selected_meals => 'وجبات مختارة';

  @override
  String get home_selected_meals_value => '30/ 18';

  @override
  String get home_meal => 'وجبة';

  @override
  String get home_remaining_days => 'أيام متبقية';

  @override
  String get home_on_track =>
      'أنت على الطريق الصحيح! استمر في اختياراتك الصحية.';

  @override
  String get search_suggestion_chicken_protein => 'دجاج بروتين';

  @override
  String get search_suggestion_chicken_rice => 'دجاج مع أرز بني';

  @override
  String get search_suggestion_chicken_healthy => 'مطاعم دجاج صحية';

  @override
  String get search_suggestion_chicken_vegetables => 'دجاج مع خضار مشوية';
}
