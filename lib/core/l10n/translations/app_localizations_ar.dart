// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get meal_details_restaurant_rating => 'تقييم المطعم';

  @override
  String get meal_details_meal_type => 'نوع الوجبة';

  @override
  String get meal_details_delivery_time => 'وقت التوصيل';

  @override
  String get meal_details_nutrition_facts => 'القيم الغذائية';

  @override
  String get meal_details_macro_distribution => 'توزيع العناصر الغذائية';

  @override
  String get meal_details_allergens => 'مسببات الحساسية';

  @override
  String meal_details_gram_value(String value) {
    return '$value جم';
  }

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
  String get dietary_preferences_update_success => 'تم حفظ التفضيلات بنجاح.';

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
  String billing_renewal_date_value(String date) {
    return 'تاريخ التجديد القادم: $date';
  }

  @override
  String get billing_days_remaining => 'متبقي 18 يوم';

  @override
  String billing_days_remaining_value(int days) {
    return 'متبقي $days يوم';
  }

  @override
  String get billing_plan_usage => 'استخدام الخطة هذا الشهر';

  @override
  String get billing_plan_usage_value => '22 من 30 يوم';

  @override
  String get billing_plan_usage_current => '22';

  @override
  String get billing_plan_usage_remaining => 'من 30 يوم';

  @override
  String billing_plan_usage_remaining_value(int days) {
    return 'من $days يوم';
  }

  @override
  String get billing_renew => 'تجديد';

  @override
  String get billing_freeze => 'تجميد';

  @override
  String get billing_upgrade_tier => 'ترقية التصنيف';

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
  String get billing_no_subscription_title => 'لا يوجد اشتراك حالي';

  @override
  String get billing_no_subscription_description =>
      'ستظهر تفاصيل اشتراكك هنا بعد الاشتراك.';

  @override
  String get billing_no_active_subscription_title => 'لا يوجد اشتراك نشط';

  @override
  String get billing_no_active_subscription_desc =>
      'لم تشترك في أي باقة حتى الآن.\nاختر الباقة المناسبة لك وابدأ رحلتك الصحية.';

  @override
  String get billing_browse_subscriptions => 'استعرض الاشتراكات';

  @override
  String get billing_no_invoices_title => 'لا يوجد فواتير بعد';

  @override
  String get billing_no_invoices_desc =>
      'ستظهر فواتير اشتراكك هنا بعد إتمام أول عملية دفع.';

  @override
  String get billing_manage_subscription => 'إدارة الاشتراك';

  @override
  String get billing_notice =>
      'يمكنك تجميد اشتراكك حتى 30 يوماً مرة واحدة كل 6 أشهر. عند الإلغاء، ستظل تتمتع بالمزايا حتى نهاية دورة الفوترة الحالية.';

  @override
  String get billing_pending_upgrade_notice =>
      'يوجد طلب ترقية معلق قيد المتابعة حالياً.';

  @override
  String get billing_action_unavailable => 'هذا الإجراء غير متاح حالياً.';

  @override
  String get billing_renew_confirm_title => 'تجديد الاشتراك';

  @override
  String get billing_renew_confirm_message =>
      'هل تريد إرسال طلب تجديد لهذا الاشتراك؟';

  @override
  String get billing_freeze_confirm_title => 'تجميد الاشتراك';

  @override
  String get billing_freeze_confirm_message =>
      'اختر تواريخ التجميد، ثم أكد الطلب.';

  @override
  String get billing_pick_freeze_dates => 'اختيار تواريخ التجميد';

  @override
  String billing_selected_freeze_dates(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get billing_optional_reason => 'السبب (اختياري)';

  @override
  String billing_freeze_range_too_long(int days) {
    return 'لا يمكن أن تتجاوز مدة التجميد $days أيام.';
  }

  @override
  String get billing_freeze_locked_days_cannot_be_frozen =>
      'لا يمكن تجميد الأيام المقفولة. اختر تواريخ لاحقة.';

  @override
  String get billing_cancel_quote_title => 'إلغاء الاشتراك';

  @override
  String billing_cancel_quote_message(
    int days,
    String amount,
    String currency,
  ) {
    return 'الأيام المستردة: $days\nالمبلغ المسترد: $amount $currency';
  }

  @override
  String get billing_confirm => 'تأكيد';

  @override
  String get billing_dismiss => 'إغلاق';

  @override
  String get billing_renew_success => 'تم إرسال طلب التجديد.';

  @override
  String get billing_freeze_success => 'تم إرسال طلب التجميد.';

  @override
  String get billing_cancel_success => 'تم إرسال طلب الإلغاء.';

  @override
  String get billing_action_failed => 'تعذر تنفيذ الطلب. حاول مرة أخرى.';

  @override
  String get profile_addresses => 'العناوين';

  @override
  String get profile_addresses_subtitle => 'إدارة عناوين التوصيل';

  @override
  String get addresses_default => 'افتراضي';

  @override
  String get addresses_active_delivery => 'عنوان التوصيل';

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
  String get addresses_save_success => 'تم حفظ العنوان بنجاح.';

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
  String get addresses_area_required => 'اختر المنطقة من القائمة.';

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
  String get addresses_search_hint => 'ابحث عن عنوان أو منطقة أو شارع';

  @override
  String get addresses_choose_from_map => 'اختيار من الخريطة';

  @override
  String get addresses_choose_from_map_subtitle => 'حدد موقعك من الخريطة';

  @override
  String get addresses_use_current_location_desc =>
      'يحدد موقعك الحالي تلقائياً';

  @override
  String get address_active_delivery_cannot_delete =>
      'هذا العنوان مستخدم حاليًا للتوصيل. عيّن عنوانًا افتراضيًا آخر وانتظر 72 ساعة حتى يتم تفعيله قبل حذف هذا العنوان.';

  @override
  String get addresses_out_of_kuwait_bounds =>
      'يجب أن يكون الموقع المحدد داخل حدود دولة الكويت.';

  @override
  String get addresses_delivery_notice_title => 'تحديث عنوان التوصيل';

  @override
  String get addresses_delivery_notice_action => 'فهمت';

  @override
  String get addresses_edit => 'تعديل';

  @override
  String get addresses_set_default => 'تعيين كافتراضي';

  @override
  String get addresses_delete => 'حذف';

  @override
  String get addresses_delete_confirmation_title => 'حذف العنوان؟';

  @override
  String get addresses_delete_confirmation_message =>
      'هل أنت متأكد من حذف هذا العنوان؟';

  @override
  String get addresses_delete_confirmation_cancel => 'إلغاء';

  @override
  String get addresses_delete_confirmation_action => 'حذف';

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
  String get profile_logout_confirmation_message =>
      'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get profile_logout_cancel => 'إلغاء';

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
  String get payment_calendar_preparing => 'جاري تجهيز أيام اشتراكك...';

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
  String get subscription_packages_empty_title => 'لا توجد باقات متاحة حاليًا';

  @override
  String get subscription_packages_empty_description =>
      'لا توجد باقات لهذا البرنامج الآن. جرّب برنامجًا آخر أو أعد المحاولة لاحقًا.';

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
  String subscription_days_range_hint(int minDays, int maxDays) {
    return 'يمكنك إدخال أي عدد من الأيام ($minDays-$maxDays يوم)';
  }

  @override
  String get subscription_custom_duration_input_hint => 'اكتب عدد الأيام';

  @override
  String subscription_custom_duration_invalid_error(int minDays, int maxDays) {
    return 'ادخل رقم من $minDays إلى $maxDays';
  }

  @override
  String get subscription_custom_duration_duplicate_error =>
      'هذه المدة متاحة بالفعل كاختيار جاهز';

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
  String get subscription_programs_empty_title => 'لا توجد برامج متاحة حالياً';

  @override
  String get subscription_programs_empty_description =>
      'لا توجد برامج اشتراك متاحة حالياً، يرجى المحاولة في وقت لاحق';

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
  String get subscription_conversion_title => 'اختر طريقة التحويل';

  @override
  String get subscription_conversion_subtitle =>
      'يمكن تحويل اشتراكك الفردي الحالي قبل بدء إعداد اشتراك العائلة.';

  @override
  String get subscription_conversion_create_family_manager =>
      'أعمل عائلة وأبقى مدير';

  @override
  String get subscription_conversion_create_family_manager_subtitle =>
      'حوّل اشتراكك الحالي ثم أكمل إعداد أفراد العائلة.';

  @override
  String get subscription_conversion_change_individual_plan =>
      'أغيّر خطتي الفردية';

  @override
  String get subscription_conversion_coming_soon => 'قريبًا';

  @override
  String get subscription_conversion_unavailable => 'هذا الخيار غير متاح الآن.';

  @override
  String get subscription_conversion_option_available => 'خيار متاح';

  @override
  String get subscription_conversion_option_unavailable => 'خيار غير متاح';

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
  String get subscription_until_end_of_subscription => 'حتى نهاية الاشتراك';

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
  String get subscription_summary_show_more => 'عرض المزيد';

  @override
  String get subscription_summary_all_restaurants => 'المطاعم المتاحة';

  @override
  String get subscription_summary_no_restaurants_for_address =>
      'لا يوجد مطعم يغطي عنوان التوصيل الحالي.';

  @override
  String get subscription_no_restaurants_for_area => 'لا تتوفر مطاعم لمنطقتك.';

  @override
  String get subscription_change_address => 'تغيير العنوان';

  @override
  String get subscription_summary_quality => 'مكونات عالية الجودة';

  @override
  String get subscription_summary_variety => 'تنوع يومي في الوجبات';

  @override
  String get subscription_summary_total_price_label => 'السعر الإجمالي';

  @override
  String get subscription_participating_restaurants => 'المطاعم المشاركة';

  @override
  String get subscription_view_all => 'استعراض الكل';

  @override
  String get subscription_payment_date => 'تاريخ الدفع';

  @override
  String get subscription_start_date => 'تاريخ بدء الاشتراك';

  @override
  String get subscription_end_date => 'تاريخ انتهاء الاشتراك';

  @override
  String get subscription_with_friday => '(مع يوم جمعة)';

  @override
  String get subscription_without_friday => '(بدون يوم جمعة)';

  @override
  String get subscription_certified_meals => 'وجبات معتمدة للاختيار';

  @override
  String get subscription_address_title => 'العنوان';

  @override
  String get subscription_meals_count_daily => '4 وجبات يومياً';

  @override
  String get subscription_meals_breakdown => 'إفطار - غداء - عشاء - سناك';

  @override
  String get subscription_start_date_picker_label => 'يبدأ الاشتراك من';

  @override
  String get subscription_chosen_start_date_label => 'يوم البداية/الدفع';

  @override
  String get subscription_first_delivery_date_label => 'أول يوم توصيل';

  @override
  String get subscription_restaurant_repetition_label => 'تكرار المطعم';

  @override
  String subscription_restaurant_repetition_message(int limit) {
    return 'يمكنك اختيار نفس المطعم حتى $limit يوم خلال الاشتراك.';
  }

  @override
  String get subscription_payment_confirmation_title => 'تأكيد تواريخ الاشتراك';

  @override
  String get subscription_continue_to_payment => 'المتابعة للدفع';

  @override
  String get checkout_start_date_required => 'اختر تاريخ بداية الاشتراك.';

  @override
  String get checkout_start_date_invalid =>
      'التاريخ المختار في الماضي. اختر تاريخًا آخر.';

  @override
  String get subscription_flow_profile_incomplete =>
      'أكمل بيانات ملفك الشخصي قبل الدفع.';

  @override
  String get checkout_address_required => 'أضف عنوان توصيل قبل الدفع.';

  @override
  String get checkout_allergies_required => 'أكد تفضيلات الحساسية قبل الدفع.';

  @override
  String get checkout_dietary_preferences_required =>
      'أكد التفضيلات الغذائية قبل الدفع.';

  @override
  String get checkout_existing_subscription => 'لديك اشتراك فردي نشط بالفعل.';

  @override
  String get checkout_restaurant_not_eligible =>
      'هذا العنوان غير مغطى من المطاعم المختارة. غيّر العنوان أو المنطقة.';

  @override
  String get checkout_redirect_url_not_allowed =>
      'رابط الرجوع من الدفع غير مسموح. حاول مرة أخرى لاحقًا.';

  @override
  String get family_restaurants_date_label => 'الإثنين 26 مايو';

  @override
  String get family_restaurants_search_hint => 'ابحث عن مطعم أو وجبة';

  @override
  String get family_restaurants_title_prefix => 'اختر المطاعم';

  @override
  String get family_restaurants_subtitle =>
      'تم ترشيح هذه المطاعم بناءً على هدفك وتفضيلاتك';

  @override
  String get family_restaurants_summary_selected_meals_value => '4';

  @override
  String get family_restaurants_summary_selected_meals_total => '/2';

  @override
  String get family_restaurants_summary_selected_meals_label => 'مختارة';

  @override
  String get family_restaurants_summary_daily_meals_value => '4';

  @override
  String get family_restaurants_summary_daily_meals_label => 'وجبات يومياً';

  @override
  String get family_restaurants_summary_calories_value => '1500';

  @override
  String get family_restaurants_summary_calories_label => 'سعرة يومياً';

  @override
  String get family_restaurants_filter_balanced => 'متوازن';

  @override
  String get family_restaurants_filter_dinner => 'عشاء';

  @override
  String get family_restaurants_filter_lunch => 'غداء';

  @override
  String get family_restaurants_filter_breakfast => 'فطور';

  @override
  String get family_restaurants_filter_high_protein => 'عالي البروتين';

  @override
  String get family_restaurants_filter_all => 'الكل';

  @override
  String get family_restaurants_diet_house => 'دايت هاوس';

  @override
  String get family_restaurants_card_subtitle => 'وجبات دايت لذيذة ومتكاملة';

  @override
  String get family_restaurants_logo_diet_house_line1 => 'DIET';

  @override
  String get family_restaurants_logo_diet_house_line2 => 'HOUSE';

  @override
  String get family_restaurants_rating_diet_house => '4.7';

  @override
  String get family_restaurants_browse_meals => 'استعرض الوجبات';

  @override
  String get family_restaurants_healthy_bowl => 'هيلثي بول';

  @override
  String get family_restaurants_logo_healthy_bowl_line1 => 'HEALTHY';

  @override
  String get family_restaurants_logo_healthy_bowl_line2 => 'BOWL';

  @override
  String get family_restaurants_rating_healthy_bowl => '4.6';

  @override
  String get family_restaurants_protein_kitchen => 'بروتين كيتشن';

  @override
  String get family_restaurants_logo_protein_kitchen_line1 => 'THE';

  @override
  String get family_restaurants_logo_protein_kitchen_line2 => 'PROTEIN';

  @override
  String get family_restaurants_logo_protein_kitchen_line3 => 'KITCHEN';

  @override
  String get family_restaurants_rating_protein_kitchen => '4.3';

  @override
  String get family_restaurants_salad_station => 'سلاد ستيشن';

  @override
  String get family_restaurants_logo_salad_station_line1 => 'SALAD';

  @override
  String get family_restaurants_logo_salad_station_line2 => 'STATION';

  @override
  String get family_restaurants_rating_salad_station => '4.6';

  @override
  String get family_restaurants_assurance_title =>
      'كل التوصيات تراعي تفضيلاتك وحساسياتك';

  @override
  String get family_restaurants_assurance_subtitle =>
      'اختر من بين هذه المطاعم مطمئناً، جميع الوجبات مناسبة لك وتدعم هدفك الصحي';

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
  String get family_member_permissions_confirm_title => 'تأكيد حفظ الصلاحيات';

  @override
  String family_member_permissions_confirm_desc(String memberName) {
    return 'هل أنت متأكد من حفظ تعديل الصلاحيات لـ $memberName؟';
  }

  @override
  String get family_member_permissions_confirm_cancel => 'إلغاء';

  @override
  String get family_member_permissions_confirm_action => 'تأكيد';

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
  String family_member_access_title(String memberName) {
    return 'إدارة الوصول لـ $memberName';
  }

  @override
  String get family_member_access_status_title => 'حالة الحساب';

  @override
  String get family_member_access_status_active => 'نشط';

  @override
  String get family_member_access_status_paused => 'متوقف مؤقتاً';

  @override
  String get family_member_access_permissions_tile_title =>
      'صلاحيات استخدام التطبيق';

  @override
  String get family_member_access_permissions_tile_subtitle =>
      'تحكم في اختيار واستبدال الوجبات وتعديل العنوان';

  @override
  String family_member_access_last_login(String timeAgo) {
    return 'آخر تسجيل دخول $timeAgo';
  }

  @override
  String get family_member_access_credentials_section => 'بيانات الدخول';

  @override
  String get family_member_access_email_label => 'البريد الإلكتروني';

  @override
  String get family_member_access_password_label => 'كلمة المرور';

  @override
  String get family_member_access_edit => 'تعديل';

  @override
  String get family_member_access_independent_title => 'لديه حساب مستقل';

  @override
  String family_member_access_independent_subtitle(String memberName) {
    return 'عند تفعيل هذا الخيار ، يمكن لـ $memberName تسجيل الدخول والإدارة المستقلة لوجباته وإعداداته';
  }

  @override
  String get family_member_access_membership_section => 'إدارة العضوية';

  @override
  String family_member_access_membership_subtitle(String memberName) {
    return 'تحكم في حالة عضوية $memberName ضمن الباقة العائلية';
  }

  @override
  String get family_member_access_active_desc =>
      'يستطيع الوصول إلى جميع الميزات واستخدام الباقة';

  @override
  String get family_member_access_paused_desc =>
      'يتم تعليق الوصول مؤقتاً مع الاحتفاظ بالبيانات والإعدادات';

  @override
  String get family_member_access_deactivate_button => 'إيقاف الحساب';

  @override
  String get family_member_access_deactivate_confirm_title =>
      'إيقاف حساب العضو';

  @override
  String family_member_access_deactivate_confirm_desc(String memberName) {
    return 'هل أنت متأكد من رغبتك في إيقاف حساب $memberName؟ سيتم تعليق وصوله للباقة وإلغاء وجباته المجدولة.';
  }

  @override
  String get family_member_access_deactivate_cancel => 'إلغاء';

  @override
  String get family_member_access_deactivate_confirm_action => 'تأكيد الإيقاف';

  @override
  String get family_member_access_save_button => 'حفظ التغييرات';

  @override
  String get family_member_access_save_success => 'تم حفظ تغييرات الوصول بنجاح';

  @override
  String get family_member_permissions_save_success => 'تم حفظ الصلاحيات بنجاح';

  @override
  String get family_member_renewal_success => 'تم إرسال طلب التجديد بنجاح';

  @override
  String get family_members_title => 'الأفراد';

  @override
  String get family_members_search_hint => 'ابحث عن فرد';

  @override
  String get family_members_add_member => 'إضافة فرد';

  @override
  String get family_member_has_account => 'لديه حساب';

  @override
  String get family_member_all_meals_manager => 'جميع الوجبات يديرها المسؤول';

  @override
  String get family_member_some_meals_customized => 'تم تخصيص بعض الوجبات';

  @override
  String get family_member_no_plan_selected => 'لم يتم اختيار النظام';

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
  String get family_phone_number => 'رقم الموبايل';

  @override
  String get family_phone_number_hint => '+965 0000 0000';

  @override
  String get family_phone_lookup => 'بحث عن الفرد';

  @override
  String get family_error_already_in_family =>
      'This phone number already belongs to another family.';

  @override
  String get family_error_plan_locked =>
      'لدى هذا الفرد اشتراك نشط بالفعل، ولا يمكن تغيير خطته من هنا.';

  @override
  String get family_error_plan_incomplete =>
      'أكمل البرنامج والباقة والتصنيف والمدة لهذا الفرد.';

  @override
  String get family_error_member_incomplete =>
      'اختر فردًا واحدًا على الأقل وأكمل بيانات اشتراكه.';

  @override
  String get family_occupation => 'المهنة';

  @override
  String get family_occupation_hint => 'اكتب المهنة (اختياري)';

  @override
  String get family_relation => 'صلة القرابة';

  @override
  String get family_relation_hint => 'اختر صلة القرابة';

  @override
  String get family_relation_input_hint => 'اكتب صلة القرابة';

  @override
  String get family_age => 'العمر';

  @override
  String get family_age_hint => 'ادخل العمر';

  @override
  String get family_age_invalid => 'أدخل عمرًا من 1 إلى 120';

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
  String get family_delete_member_confirmation_title => 'حذف الفرد؟';

  @override
  String get family_delete_member_confirmation_message =>
      'هل أنت متأكد من حذف هذا الفرد؟';

  @override
  String get family_delete_member_success => 'تم حذف الفرد بنجاح';

  @override
  String get family_add_member_success => 'تمت إضافة الفرد بنجاح';

  @override
  String get family_update_member_success => 'تم تعديل بيانات الفرد بنجاح';

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
  String get family_step_location => 'الموقع';

  @override
  String get family_step_allergies => 'الحساسية';

  @override
  String get family_step_package_days => 'الباقة والأيام';

  @override
  String get family_step_payment => 'الدفع';

  @override
  String get family_setup_step_four => '4';

  @override
  String get family_setup_step_five => '5';

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
  String get family_new_members_subtotal => 'إجمالي الأعضاء الجدد';

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
  String get calendar_empty_meals_title => 'لا توجد وجبات حالياً';

  @override
  String get calendar_empty_meals_description =>
      'لم تقم بإضافة أي وجبات بعد.\nابدأ الآن بإضافة وجباتك الصحية.';

  @override
  String get calendar_empty_meals_button => 'إضافة وجبات';

  @override
  String get calendar_no_subscription_title => 'لا توجد وجبات حتى الان';

  @override
  String get calendar_no_subscription_description =>
      'ييدو أنك لست مشتركاً في أي باقة.\nاشترك الآن واستمتع بوجبات صحية تناسب أهدافك.';

  @override
  String get calendar_no_subscription_button => 'عرض الاشتراكات';

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
  String get calendar_daily_nutrition_total => 'إجمالي القيم من هذا اليوم';

  @override
  String get calendar_usual_delivery_time => 'وقت التوصيل المعتاد';

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
  String get calendar_restaurant_subtitle =>
      'وجبات صحية متوازنة بمكونات طبيعية';

  @override
  String get calendar_restaurant_description =>
      'نقدم وجبات صحية عالية الجودة باستخدام مكونات طازجة\nوطبيعية لمساعدتك على تحقيق أهدافك الغذائية والرياضية.';

  @override
  String get calendar_restaurant_no_reviews => 'لا توجد تقييمات';

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
  String calendar_restaurant_usage_limit(int used, int limit) {
    return 'الاستخدام $used من $limit';
  }

  @override
  String get calendar_restaurant_repetition_prefix => 'تكرار';

  @override
  String calendar_restaurant_usage_badge(int used, int limit) {
    return 'تكرار $limit/$used';
  }

  @override
  String calendar_restaurant_quota_exhausted(int limit) {
    return 'تم استهلاك الحد ($limit/$limit)';
  }

  @override
  String calendar_restaurant_quota_exhausted_badge(int limit) {
    return 'مكتمل ($limit/$limit)';
  }

  @override
  String get calendar_meal_suffix => ' وجبة';

  @override
  String get calendar_change_restaurant => 'تغيير المطعم';

  @override
  String get calendar_meals_changed => 'تم تغيير الوجبة';

  @override
  String get calendar_selection_locked_before_72_hours =>
      'آخر تعديل قبل التوصيل بـ 72 ساعة';

  @override
  String get family_member_day_closed_button => 'تم الإغلاق';

  @override
  String get calendar_pick_restaurant_first => 'اختيار ';

  @override
  String get calendar_pick_restaurant_second => 'مطعم';

  @override
  String get calendar_done => 'تم';

  @override
  String get calendar_meals_save_success => 'تمت إضافة الوجبة بنجاح.';

  @override
  String get calendar_confirm_meals => 'تأكيد الوجبات';

  @override
  String get calendar_confirm_selections => 'تأكيد الاختيارات';

  @override
  String get calendar_confirm_selection_header => 'تأكيد اختيار الوجبات';

  @override
  String get calendar_confirm_meals_success =>
      'تم إرسال الوجبات للمطعم للمراجعة';

  @override
  String get calendar_confirmed_sheet_title => 'تم تأكيد الوجبات';

  @override
  String get calendar_confirmed_sheet_subtitle =>
      'تم حفظ اختياراتك بنجاح وسيتم تجهيز وجباتك لليوم المحدد';

  @override
  String get calendar_confirmed_sheet_status_label => 'الحالة';

  @override
  String get calendar_status_awaiting_restaurant => 'في انتظار تأكيد المطعم';

  @override
  String get calendar_status_confirmed => 'مؤكد';

  @override
  String get calendar_confirmed_sheet_note =>
      'يمكنك تعديل الوجبات قبل موعد الإغلاق اليومي';

  @override
  String get calendar_confirmed_sheet_back_to_calendar => 'العودة للتقويم';

  @override
  String get calendar_confirmed_sheet_view_meals => 'عرض الوجبات';

  @override
  String get calendar_error_box_incomplete =>
      'يرجى اختيار كل الوجبات المطلوبة أولاً';

  @override
  String get calendar_error_selection_locked =>
      'تم قفل هذا اليوم ولم يعد قابلاً للتعديل';

  @override
  String get calendar_error_day_unavailable => 'هذا اليوم غير متاح حالياً';

  @override
  String get calendar_error_fulfillment_not_ready =>
      'الاشتراك غير جاهز حالياً، يرجى إعادة المحاولة لاحقاً';

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
  String get profile_settings_language_sheet_title => 'اختر اللغة';

  @override
  String get profile_settings_language_arabic => 'العربية';

  @override
  String get profile_settings_language_english => 'الإنجليزية';

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

  @override
  String get wallet_title => 'المحفظة';

  @override
  String get wallet_total_refundable_balance_title =>
      'إجمالي الرصيد القابل للاسترداد';

  @override
  String get wallet_total_refundable_balance_subtitle =>
      'رصيد ناتج عن إلغاء الاشتراكات أو التسويات';

  @override
  String get wallet_transactions_history => 'سجل العمليات';

  @override
  String get wallet_refund_to_card => 'استرداد إلى البطاقة';

  @override
  String get wallet_important_info_title => 'معلومات مهمة';

  @override
  String get wallet_important_info_body =>
      'هذا الرصيد مخصص فقط لاستقبال المبالغ المستردة\nمن إلغاء الاشتراكات أو عند حدوث تسوية خاصة\nلا يمكن شحن المحفظة أو إضافة مبالغ إليها';

  @override
  String get wallet_recent_transactions => 'آخر العمليات';

  @override
  String get wallet_view_all => 'عرض الكل';

  @override
  String get wallet_security_note =>
      'نحرص على حماية بياناتك ومعاملاتك وفق أعلى معايير الأمان';

  @override
  String get wallet_refundable_balance => 'الرصيد القابل للاسترداد';

  @override
  String wallet_last_updated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get wallet_filter_settlements => 'تسويات';

  @override
  String get wallet_filter_card_refund => 'استرداد إلى البطاقة';

  @override
  String get wallet_filter_refunds => 'المبالغ المستردة';

  @override
  String get wallet_filter_all => 'الكل';

  @override
  String get wallet_search_hint => 'ابحث في العمليات';

  @override
  String get wallet_group_today => 'اليوم';

  @override
  String get wallet_group_this_week => 'هذا الأسبوع';

  @override
  String get wallet_group_april_2026 => 'أبريل 2026';

  @override
  String get wallet_transactions_notice =>
      'يحتوي سجل العمليات على المدفوعات والمبالغ المستردة\nوتسويات المحفظة فقط';

  @override
  String get wallet_status_completed => 'مكتمل';

  @override
  String get wallet_status_processing => 'قيد المعالجة';

  @override
  String get wallet_select_card => 'اختر البطاقة';

  @override
  String get wallet_refund_notice_body =>
      '• سيتم خصم المبلغ من رصيد المحفظة عند إرسال الطلب\n• لا يمكن التراجع بعد بدء المعالجة';

  @override
  String get wallet_order_summary_title => 'ملخص الطلب';

  @override
  String get wallet_confirm_refund => 'تأكيد طلب الاسترداد';

  @override
  String get wallet_cancel => 'إلغاء';

  @override
  String get wallet_refund_available_balance => 'الرصيد المتاح للاسترداد';

  @override
  String get wallet_refund_hero_subtitle =>
      'سيتم تحويل المبلغ إلى بطاقتك خلال 3-7 أيام عمل';

  @override
  String get wallet_refund_amount => 'مبلغ الاسترداد';

  @override
  String get wallet_refund_custom_amount => 'مبلغ مخصص';

  @override
  String get wallet_refund_full_balance => 'كامل الرصيد';

  @override
  String get wallet_summary_receiving_card => 'البطاقة المستلمة';

  @override
  String get wallet_summary_amount => 'المبلغ';

  @override
  String get wallet_summary_fees => 'الرسوم';

  @override
  String get wallet_summary_free => 'مجانا';

  @override
  String get wallet_summary_expected_receipt => 'الاستلام المتوقع';

  @override
  String get wallet_summary_expected_receipt_value => 'خلال 7-14 يوم عمل';

  @override
  String get wallet_card_expires_at => 'تنتهي في';

  @override
  String get biometric_login_title => 'تسجيل الدخول بالبصمة';

  @override
  String get biometric_login_subtitle =>
      'استخدم البصمة أو Face ID لتسجيل الدخول السريع';

  @override
  String get biometric_face_id => 'Face ID';

  @override
  String get biometric_fingerprint => 'بصمة الإصبع';

  @override
  String get biometric_generic => 'القياسات الحيوية';

  @override
  String get biometric_enable_reason =>
      'يرجى تأكيد هويتك لتفعيل تسجيل الدخول بالبصمة';

  @override
  String get biometric_auth_reason =>
      'يرجى تأكيد هويتك لتسجيل الدخول إلى حسابك';

  @override
  String get biometric_enabled_success => 'تم تفعيل تسجيل الدخول بالبصمة بنجاح';

  @override
  String get biometric_disabled_success => 'تم تعطيل تسجيل الدخول بالبصمة';

  @override
  String get biometric_not_supported =>
      'الجهاز لا يدعم المصادقة بالبصمة أو Face ID';

  @override
  String get biometric_not_enrolled =>
      'لم يتم تسجيل أي بصمة أو Face ID على هذا الجهاز';

  @override
  String get biometric_locked_out =>
      'تم قفل البصمة مؤقتًا بسبب تكرار المحاولات الفاشلة';

  @override
  String get biometric_permanently_locked_out =>
      'تم قفل البصمة نهائيًا، يرجى فتح القفل برمز مرور الجهاز';

  @override
  String get biometric_failed =>
      'فشلت المصادقة بالبصمة، يرجى المحاولة مرة أخرى';

  @override
  String get biometric_prompt_enable_dialog_title => 'تفعيل الدخول السريع';

  @override
  String get biometric_prompt_enable_dialog_body =>
      'هل ترغب في تفعيل تسجيل الدخول بالبصمة / Face ID للدخول السريع مستقبلاً؟';

  @override
  String get biometric_enable_button => 'تفعيل الآن';

  @override
  String get biometric_skip_button => 'لاحقاً';

  @override
  String get biometric_quick_login => 'تسجيل الدخول بالبصمة';

  @override
  String get family_packages_selection_title => 'اختر باقة العائلة';

  @override
  String get family_packages_selection_subtitle =>
      'اختر باقة الحجم المناسبة لعدد أفراد عائلتك للاستفادة من الخصم';

  @override
  String family_package_members_range(int min, int max) {
    return 'من $min إلى $max أفراد';
  }

  @override
  String family_package_discount_badge(String discount) {
    return 'خصم $discount';
  }

  @override
  String get family_package_select_button => 'اختيار الباقة';

  @override
  String get family_package_continue_button => 'متابعة إعداد العائلة';

  @override
  String family_members_count_indicator(int current, int max) {
    return '$current / $max أفراد';
  }

  @override
  String get family_members_count_label => 'أفراد العائلة';

  @override
  String get family_members_max_reached => 'وصلت الحد الأقصى لأفراد هذه الباقة';

  @override
  String family_members_min_warning(int min) {
    return 'يرجى إضافة $min أفراد على الأقل لتفعيل خصم هذه الباقة والدفع';
  }

  @override
  String get family_step_package_selection => 'باقة الحجم';

  @override
  String get family_gender_male => 'ذكر';

  @override
  String get family_gender => 'النوع';

  @override
  String get family_gender_female => 'أنثى';

  @override
  String get family_address_select => 'عنوان التوصيل';

  @override
  String get family_address_select_hint => 'اختر عنوان التوصيل';

  @override
  String get family_tier_basic => 'بيزك';

  @override
  String get family_tier_platinum => 'بلاتينيوم';

  @override
  String get family_tier_elite => 'إيليت';

  @override
  String get family_change_package => 'تغيير الباقة';

  @override
  String get family_packages_empty => 'لا توجد باقات عائلية متاحة حالياً';

  @override
  String get family_restaurants_member_ahmed => 'أحمد';

  @override
  String family_restaurants_title(String memberName) {
    return 'مطاعم $memberName';
  }

  @override
  String family_restaurants_suitable_title(String memberName) {
    return 'مطاعم مناسبة لـ$memberName';
  }

  @override
  String get profile_influencer_partner => 'شريك مؤثر';

  @override
  String get profile_influencer_partner_subtitle =>
      'تابع الإحالات والروابط والأرباح';

  @override
  String get influencer_dashboard_title => 'المؤثر';

  @override
  String get influencer_user_name => 'مرحباً ، محمد';

  @override
  String get influencer_partner_label => 'Influencer Partner';

  @override
  String get influencer_statistics => 'الإحصائيات';

  @override
  String get influencer_statistics_subtitle => 'تابع أداءك ونمو أعمالك';

  @override
  String get influencer_tools => 'أدوات الشراكة';

  @override
  String get influencer_total_earnings => 'إجمالي العمولات';

  @override
  String get influencer_total_earnings_value => '845';

  @override
  String get influencer_period_7_days => '7 أيام';

  @override
  String get influencer_period_30_days => '30 يوم';

  @override
  String get influencer_period_90_days => '90 يوم';

  @override
  String get influencer_period_6_months => '6 أشهر';

  @override
  String get influencer_period_year => 'سنة';

  @override
  String get influencer_previous_30_days_comparison =>
      'مقارنة بالـ 30 يوم السابقة';

  @override
  String get influencer_growth_percent => '+4.3%';

  @override
  String get influencer_this_month => 'هدف الشهر';

  @override
  String get influencer_referrals => 'العملاء المسجلون';

  @override
  String get influencer_referrals_value => '230';

  @override
  String get influencer_active_codes => 'هذا الأسبوع 7+';

  @override
  String get influencer_conversion_rate => 'معدل التحويل';

  @override
  String get influencer_conversion_rate_value => '35%';

  @override
  String get influencer_from_visits => 'هذا الأسبوع 7+';

  @override
  String get influencer_pending_withdrawals => 'النقرات على الرابط';

  @override
  String get influencer_pending_withdrawals_value => '520';

  @override
  String get influencer_under_review => 'هذا الأسبوع 7+';

  @override
  String get influencer_completed_subscriptions => 'الاشتراكات المكتملة';

  @override
  String get influencer_completed_subscriptions_value => '81';

  @override
  String get influencer_generated_orders => 'الطلبات الناتجة';

  @override
  String get influencer_generated_orders_value => '68';

  @override
  String get influencer_overview => 'نظرة عامة';

  @override
  String get influencer_revenue_growth => 'تطور الأرباح';

  @override
  String get influencer_daily => 'يومي';

  @override
  String get influencer_earnings_label => 'الأرباح';

  @override
  String get influencer_top_products => 'أفضل المنتجات أداءاً';

  @override
  String get influencer_top_product_name => 'بوكس دايت متكامل';

  @override
  String get influencer_top_product_orders_value => '124';

  @override
  String get influencer_orders_label => 'طلب';

  @override
  String get influencer_product_revenue_label => 'الأرباح';

  @override
  String get influencer_top_product_revenue_value => '245 KWD';

  @override
  String get influencer_chart_20_april => '20 أبريل';

  @override
  String get influencer_chart_27_april => '27 أبريل';

  @override
  String get influencer_chart_4_may => '4 مايو';

  @override
  String get influencer_chart_11_may => '11 مايو';

  @override
  String get influencer_chart_18_may => '18 مايو';

  @override
  String get influencer_chart_25_may => '25 مايو';

  @override
  String get influencer_weekly_commission_gain => '+35 KWD';

  @override
  String get influencer_this_week => 'هذا الأسبوع';

  @override
  String get influencer_month_goal_progress => '80%';

  @override
  String get influencer_month_goal_value => '680 KWD / 850 KWD';

  @override
  String get influencer_view_details => 'عرض التفاصيل';

  @override
  String get influencer_share_links_title => 'روابط المشاركة';

  @override
  String get influencer_share_links_subtitle => 'شارك رابطك وكودك';

  @override
  String get influencer_social_connections_title => 'حسابات التواصل';

  @override
  String get influencer_social_connections_subtitle => 'اربط قنواتك العامة';

  @override
  String get influencer_wallet_title => 'محفظة الأرباح';

  @override
  String get influencer_wallet_subtitle => 'اعرض الرصيد والعمليات';

  @override
  String get influencer_wallet_figma_title => 'محفظتي';

  @override
  String get influencer_wallet_figma_subtitle => 'إدارة أرباحك وحركاتك المالية';

  @override
  String get influencer_available_balance => 'الرصيد المتاح';

  @override
  String get influencer_total_earnings_colon => 'إجمالي الأرباح :';

  @override
  String get influencer_wallet_total_balance_value => '1.245';

  @override
  String get influencer_wallet_withdraw_action => 'سحب الارباح';

  @override
  String get influencer_wallet_history_action => 'سجل العمليات';

  @override
  String get influencer_wallet_month_summary => 'ملخص هذا الشهر';

  @override
  String get influencer_wallet_summary_total_earnings => 'إجمالي الأرباح';

  @override
  String get influencer_wallet_summary_withdrawn => 'تم السحب';

  @override
  String get influencer_wallet_withdrawn_value => '400';

  @override
  String get influencer_wallet_latest_transactions => 'أحدث المعاملات';

  @override
  String get influencer_referral_code_title => 'كود الخصم الخاص بك';

  @override
  String get influencer_referral_code_subtitle => 'واحصل على عمولات أكثر';

  @override
  String get influencer_referral_code_value => 'AMMAR20';

  @override
  String get influencer_share_code_title => 'شارك رابطك وكودك';

  @override
  String get influencer_recent_activities => 'آخر النشاطات';

  @override
  String get influencer_view_all => 'عرض الكل';

  @override
  String get influencer_activity_first_user => 'المستخدم #gdf55';

  @override
  String get influencer_activity_first_plan => 'اشترك في باقة شهرية';

  @override
  String get influencer_activity_second_user => 'محمد علي';

  @override
  String get influencer_activity_second_plan => 'اشترك في باقة أسبوعية';

  @override
  String get influencer_activity_third_user => 'عبدالله ناصر';

  @override
  String get influencer_activity_third_plan => 'اشترك في باقة شهرية';

  @override
  String get influencer_activity_amount => '+5 KWD';

  @override
  String get influencer_activity_time => 'منذ 2 ساعة';

  @override
  String get influencer_tab_home => 'الرئيسية';

  @override
  String get influencer_tab_links => 'روابط';

  @override
  String get influencer_tab_wallet => 'المحفظة';

  @override
  String get influencer_tab_stats => 'احصائيات';

  @override
  String get influencer_tab_profile => 'البروفايل';

  @override
  String get influencer_share_links_header => 'شارك الآن';

  @override
  String get influencer_share_links_body => 'شارك بسهولة عبر منصات التواصل';

  @override
  String get influencer_share_now => 'شارك الآن';

  @override
  String get influencer_add_social_accounts => 'إضافة وسائل التواصل';

  @override
  String get influencer_social_connections_header => 'إضافة وسائل التواصل';

  @override
  String get influencer_social_connections_body =>
      'أضف حساباتك على وسائل التواصل لبدء الشراكة وكسب عمولات أكثر';

  @override
  String get influencer_save_continue => 'حفظ ومتابعة';

  @override
  String get influencer_skip_now => 'تخطي الآن';

  @override
  String get influencer_instagram => 'إنستغرام';

  @override
  String get influencer_tiktok => 'تيك توك';

  @override
  String get influencer_snapchat => 'سناب شات';

  @override
  String get influencer_whatsapp => 'واتساب';

  @override
  String get influencer_telegram => 'تيليجرام';

  @override
  String get influencer_youtube => 'يوتيوب';

  @override
  String get influencer_tiktok_subtitle => 'أضف حسابك على تيك توك';

  @override
  String get influencer_instagram_subtitle => 'أضف حسابك على إنستغرام';

  @override
  String get influencer_whatsapp_subtitle => 'أضف رقم واتساب للأعمال';

  @override
  String get influencer_telegram_subtitle => 'أضف حسابك على تيليجرام';

  @override
  String get influencer_youtube_subtitle => 'أضف قناتك على يوتيوب';

  @override
  String get influencer_snapchat_subtitle => 'أضف حسابك على سناب شات';

  @override
  String get influencer_social_add => 'إضافة';

  @override
  String get influencer_social_edit => 'تعديل';

  @override
  String get influencer_privacy_title => 'نحافظ على خصوصية بياناتك';

  @override
  String get influencer_privacy_body =>
      'نستخدم بياناتك فقط لتحسين فرص الشراكة والتواصل مع العلامات التجارية.';

  @override
  String get influencer_enter_account => 'أدخل الحساب أو الرابط';

  @override
  String get influencer_confirm => 'تأكيد';

  @override
  String get influencer_cancel => 'إلغاء';

  @override
  String get influencer_not_connected => 'غير متصل';

  @override
  String get influencer_currency => 'KWD';

  @override
  String get influencer_wallet_last_updated => 'آخر تحديث اليوم 09:15 ص';

  @override
  String get influencer_available_earnings => 'الأرباح المتاحة';

  @override
  String get influencer_request_withdraw => 'طلب سحب الأرباح';

  @override
  String get influencer_request_withdraw_subtitle =>
      'حوّل أرباحك إلى حسابك البنكي';

  @override
  String get influencer_withdraw_history_title => 'سجل عمليات السحب';

  @override
  String get influencer_withdraw_history_subtitle =>
      'تابع الطلبات السابقة والمعلقة';

  @override
  String get influencer_recent_commissions => 'آخر العمولات';

  @override
  String get influencer_withdraw_arrival_hint =>
      'سيتم مراجعة المبلغ قبل التحويل';

  @override
  String get influencer_withdraw_method => 'طريقة السحب';

  @override
  String get influencer_withdraw_screen_title => 'سحب الأرباح';

  @override
  String get influencer_withdraw_screen_subtitle =>
      'اختر طريقة السحب وأدخل البيانات';

  @override
  String get influencer_available_for_withdraw => 'الرصيد المتاح للسحب';

  @override
  String get influencer_choose_withdraw_method => 'اختر طريقة السحب';

  @override
  String get influencer_bank_transfer => 'تحويل بنكي';

  @override
  String get influencer_bank_transfer_subtitle => 'تحويل إلى حسابك البنكي';

  @override
  String get influencer_electronic_wallet => 'محفظة إلكترونية';

  @override
  String get influencer_electronic_wallet_subtitle =>
      'تحويل إلى محفظة إلكترونية';

  @override
  String get influencer_bank_transfer_details => 'بيانات التحويل البنكي';

  @override
  String get influencer_account_holder_hint => 'أدخل الاسم بالكامل';

  @override
  String get influencer_iban_hint => 'أدخل رقم الآيبان';

  @override
  String get influencer_select_bank_hint => 'اختر البنك';

  @override
  String get influencer_withdraw_notice_text =>
      'سيتم تحويل المبلغ كامل إلى حسابك قد تستغرق العملية من 1 إلى 3 أيام عمل';

  @override
  String get influencer_bank_account_holder => 'اسم صاحب الحساب';

  @override
  String get influencer_bank_account_holder_value => 'محمد أحمد';

  @override
  String get influencer_bank_iban => 'رقم الآيبان';

  @override
  String get influencer_bank_iban_value => 'KW81CBKU0000000000001234560101';

  @override
  String get influencer_bank_name => 'اسم البنك';

  @override
  String get influencer_bank_name_value => 'بنك الكويت الوطني';

  @override
  String get influencer_continue_review => 'متابعة للمراجعة';

  @override
  String get influencer_withdraw_review_title => 'مراجعة طلب السحب';

  @override
  String get influencer_withdraw_review_subtitle =>
      'راجع بيانات الطلب قبل تأكيد السحب';

  @override
  String get influencer_withdraw_amount => 'مبلغ السحب';

  @override
  String get influencer_confirm_withdraw => 'تأكيد طلب السحب';

  @override
  String get influencer_transfer_details => 'بيانات التحويل';

  @override
  String get influencer_bank_label => 'البنك';

  @override
  String get influencer_account_number => 'رقم الحساب';

  @override
  String get influencer_account_number_sample => '**** **** **** 1234';

  @override
  String get influencer_iban_with_label => 'رقم الآيبان(IBAN)';

  @override
  String get influencer_operation_summary => 'ملخص العملية';

  @override
  String get influencer_requested_withdraw_amount => 'المبلغ المطلوب سحبه';

  @override
  String get influencer_transfer_fees => 'رسوم التحويل';

  @override
  String get influencer_transfer_fees_value => '0.000 KWD';

  @override
  String get influencer_final_received_amount => 'المبلغ النهائي المستلم';

  @override
  String get influencer_important_info => 'معلومة هامة';

  @override
  String get influencer_important_info_message =>
      'سيتم تحويل المبلغ بالكامل إلى حسابك البنكي قد تستغرق العملية من 1 إلى 3 أيام عمل';

  @override
  String get influencer_back_button => 'رجوع';

  @override
  String get influencer_transaction_subscription_commission => 'عمولة اشتراك';

  @override
  String get influencer_transaction_withdraw_request => 'طلب سحب أرباح';

  @override
  String get influencer_transaction_referral_bonus => 'مكافأة إحالة';

  @override
  String get influencer_transaction_new_referral => 'إحالة جديدة';

  @override
  String get influencer_transaction_bank_withdrawal => 'سحب إلى حساب بنكي';

  @override
  String get influencer_transaction_premium_order_completed => 'طلب مميز مكتمل';

  @override
  String get influencer_transaction_25_may_2025 => '25 مايو 2025';

  @override
  String get influencer_transaction_amount_positive_120 => '+120 KWD';

  @override
  String get influencer_transaction_amount_negative_120 => '-120 KWD';

  @override
  String get influencer_transaction_today => 'اليوم، 09:15 ص';

  @override
  String get influencer_transaction_yesterday => 'أمس، 02:40 م';

  @override
  String get influencer_transaction_week => 'هذا الأسبوع';

  @override
  String get influencer_transaction_amount_large => '+24.000 د.ك';

  @override
  String get influencer_transaction_amount_medium => '-32.500 د.ك';

  @override
  String get influencer_transaction_amount_small => '+6.250 د.ك';

  @override
  String get billing_freeze_rules_title => 'شروط وسياسة التجميد';

  @override
  String get billing_confirm_overwrite_selections_title =>
      'تأكيد إلغاء الوجبات المحددة';

  @override
  String get billing_confirm_overwrite_selections_message =>
      'لديك وجبات محددة مسبقاً خلال فترة التجميد، وسيتم إلغاء هذه الاختيارات وإضافة أيام تعويضية بديلة في نهاية الاشتراك. هل تريد المتابعة؟';

  @override
  String get calendar_selection_locked =>
      'تم إيقاف التعديل على هذا اليوم نظراً لتجميد الاشتراك أو إغلاق المطبخ.';

  @override
  String get calendar_day_frozen_title => 'تم تجميد اليوم';

  @override
  String get calendar_day_frozen_description =>
      'تم إيقاف تحضير وتوصيل وجبات هذا اليوم مؤقتا. يمكنك إلغاء التجميد لاستئناف الوجبات';

  @override
  String get calendar_day_frozen_badge => 'اليوم مجمد';

  @override
  String get subscription_day_frozen =>
      'هذا اليوم مجمّد ضمن فترة تجميد الاشتراك.';

  @override
  String get billing_pending_freeze_title => 'تفاصيل تجميد الاشتراك';

  @override
  String get billing_pending_freeze_message =>
      'اشتراكك مجمّد حالياً. تفاصيل وتواريخ فترة التجميد موضحة أدناه:';

  @override
  String get billing_pending_freeze_start_date => 'تاريخ بداية التجميد';

  @override
  String get billing_pending_freeze_end_date => 'تاريخ نهاية التجميد';

  @override
  String billing_pending_freeze_days(int days) {
    return 'المدة: $days أيام';
  }

  @override
  String get billing_pending_freeze_status => 'الحالة';

  @override
  String billing_pending_freeze_notice_banner(
    String startDate,
    String endDate,
  ) {
    return 'الاشتراك مجمّد من $startDate إلى $endDate';
  }

  @override
  String get billing_status_approved => 'معتمد';

  @override
  String billing_active_freeze_service_days(int days) {
    return 'أيام الخدمة المجمدة: $days';
  }

  @override
  String billing_active_freeze_compensation_days(int days) {
    return 'أيام التعويض: $days';
  }

  @override
  String billing_active_freeze_new_end_date(String date) {
    return 'تاريخ نهاية الاشتراك الجديد: $date';
  }

  @override
  String get billing_active_freeze_compensation_dates => 'تواريخ التعويض';

  @override
  String get address_restaurant_does_not_service_region =>
      'المطعم المشترك معه حالياً لا يخدم هذه المنطقة. يرجى اختيار عنوان آخر.';

  @override
  String get address_coverage_notice_title => 'تنبيه تغطية المطاعم';

  @override
  String get address_no_serving_restaurants =>
      'لا توجد مطاعم تخدم هذه المنطقة حالياً';

  @override
  String get address_serving_restaurants_title =>
      'المطاعم التي تخدم منطقتك الجديدة';

  @override
  String get address_coverage_notice_action => 'حسناً، فهمت';

  @override
  String get address_preview_check_button => 'متابعة وتحقق من التغطية';

  @override
  String get address_coverage_covered_title => 'منطقتك مغطاة بمطاعم اشتراكك';

  @override
  String get address_coverage_uncovered_title => 'المنطقة غير مغطاة باشتراكك';

  @override
  String get address_coverage_confirm_save => 'تأكيد وحفظ العنوان';

  @override
  String get address_coverage_confirm_set_default => 'تأكيد تعيين كافتراضي';

  @override
  String get address_coverage_choose_another => 'اختيار عنوان آخر';

  @override
  String get address_coverage_uncovered_desc =>
      'مطعم اشتراكك الحالي لا يدعم التوصيل إلى هذه المنطقة.';

  @override
  String get upgrade_summary_operational_title => 'تفاصيل تفعيل الترقية';

  @override
  String get upgrade_summary_effective_date => 'تاريخ بدء التفعيل';

  @override
  String upgrade_summary_repetition(int limit, int days) {
    return 'يمكن تكرار المطعم حتى $limit مرات خلال $days يومًا';
  }

  @override
  String get upgrade_summary_new_restaurants => 'مطاعم جديدة تنضم لباقتك';

  @override
  String get upgrade_summary_no_new_restaurants =>
      'لا توجد مطاعم إضافية في هذا التصنيف';

  @override
  String get upgrade_summary_load_error =>
      'تعذر تحميل ملخص الترقية. يرجى المحاولة مرة أخرى.';

  @override
  String get billing_uncompleted_title => 'اشتراكات غير مكتملة';

  @override
  String get billing_uncompleted_hold_active => 'حجزك محفوظ مؤقتًا';

  @override
  String get billing_uncompleted_hold_expired => 'انتهت مهلة حجز المقاعد';

  @override
  String get billing_uncompleted_duration => 'مدة الاشتراك';

  @override
  String get billing_uncompleted_days => 'يومًا';

  @override
  String get billing_uncompleted_delete => 'حذف';

  @override
  String get billing_uncompleted_resume => 'إكمال الاشتراك';

  @override
  String get billing_uncompleted_delete_title => 'حذف الاشتراك غير المكتمل؟';

  @override
  String get billing_uncompleted_delete_message =>
      'سيتم إلغاء المسودة وفك الحجز المؤقت المرتبط بها.';

  @override
  String get billing_uncompleted_delete_success =>
      'تم حذف الاشتراك غير المكتمل';

  @override
  String get billing_uncompleted_resume_title => 'تأكيد تاريخ بدء الاشتراك';

  @override
  String get billing_uncompleted_resume_message =>
      'انتهت مهلة الحجز المؤقت. هل تريد المتابعة بتاريخ البدء المقترح؟';

  @override
  String get billing_uncompleted_resume_success =>
      'تابع إتمام الدفع في صفحة الدفع';

  @override
  String get billing_uncompleted_action_failed =>
      'تعذر إتمام الطلب. حاول مرة أخرى.';

  @override
  String get family_packages_header_title => 'اشتراكات عائلية';

  @override
  String get family_packages_header_subtitle => 'اختر الاشتراك الذي يناسبك';

  @override
  String get family_packages_hero_badge => 'وجبات تكفي الجميع';

  @override
  String get family_packages_hero_title => 'خطط متكاملة من 2 إلى 8 أفراد';

  @override
  String get family_packages_hero_subtitle => 'بأشتراكات مناسبة وتوصيل سريع';

  @override
  String get family_packages_section_title => 'اختر نوع الاشتراك';

  @override
  String get family_packages_default_meals_range => '2-4 وجبات';

  @override
  String family_packages_members_count(int min, int max) {
    return '$min-$max أفراد';
  }

  @override
  String get family_packages_continue_button => 'متابعة اختيار الاشتراك';

  @override
  String get family_allergies_title => 'الحساسية';

  @override
  String family_allergies_member(String name) {
    return 'حساسية $name';
  }

  @override
  String get family_allergies_none => 'بدون حساسية';

  @override
  String get family_allergies_save_next_member => 'حفظ والمتابعة';

  @override
  String get family_allergies_next_location => 'التالي: الموقع';

  @override
  String get family_allergies_next_payment => 'التالي: الدفع';

  @override
  String get family_allergies_food_title => 'الحساسية الغذائية';

  @override
  String get family_allergies_food_subtitle =>
      'حدد المكونات التي يجب تجنبها لهذا الفرد';

  @override
  String get family_allergies_common => 'الحساسيات الشائعة';

  @override
  String get family_allergies_search => 'ابحث عن حساسية';

  @override
  String get family_allergies_rejected => 'مكونات لا يفضلها';

  @override
  String get family_allergies_ingredient_search => 'ابحث عن مكونات';

  @override
  String get family_allergies_show_more => 'عرض المزيد';

  @override
  String get family_allergies_show_less => 'عرض أقل';

  @override
  String get family_allergies_information_note =>
      'نستخدم هذه المعلومات لتخصيص الوجبات المناسبة لكل فرد.';

  @override
  String get family_addresses_title => 'عناوين التوصيل';

  @override
  String family_addresses_member(String name) {
    return 'عنوان $name';
  }

  @override
  String get family_addresses_add => 'إضافة عنوان';

  @override
  String get family_addresses_use => 'استخدام هذا العنوان';

  @override
  String get family_addresses_next_member => 'حفظ والمتابعة';

  @override
  String get family_addresses_next_payment => 'التالي: الدفع';

  @override
  String get family_addresses_label => 'اسم العنوان';

  @override
  String get family_addresses_area => 'المنطقة';

  @override
  String get family_addresses_line => 'تفاصيل العنوان';

  @override
  String family_meal_selection_title(String name) {
    return 'وجبات $name';
  }

  @override
  String family_meal_selection_context(String restaurant, String slot) {
    return '$restaurant • $slot';
  }

  @override
  String get family_meal_stepper_restaurant => 'اختيار المطعم';

  @override
  String get family_meal_stepper_meal => 'اختيار الوجبة';

  @override
  String get family_meal_stepper_review => 'المراجعة';

  @override
  String get family_meal_macros_title => 'ملخص الماكروز';

  @override
  String get family_meal_macros_selected_badge => 'من وجبات مختارة';

  @override
  String get family_meal_macros_subtitle =>
      'يتحدث تلقائياً حسب الوجبات المختارة';

  @override
  String get family_meal_macros_calories => 'السعرات';

  @override
  String get family_meal_macros_carbs => 'الكربوهيدرات';

  @override
  String get family_meal_macros_protein => 'البروتين';

  @override
  String get family_meal_macros_fat => 'الدهون';

  @override
  String family_meal_gram_unit(String count) {
    return '$count جم';
  }

  @override
  String family_meal_calorie_unit(String count) {
    return '$count سعرة';
  }

  @override
  String get family_meal_tab_all => 'الكل';

  @override
  String get family_meal_tab_breakfast => 'إفطار';

  @override
  String get family_meal_tab_lunch => 'غداء';

  @override
  String get family_meal_tab_dinner => 'عشاء';

  @override
  String get family_meal_status_selected => 'تم الاختيار';

  @override
  String get family_meal_button_select => 'اختيار الوجبة';

  @override
  String family_meal_selected_counter(int selected, int total) {
    return 'تم اختيار $selected من $total وجبات';
  }

  @override
  String get family_meal_continue_review => 'متابعة المراجعة';

  @override
  String family_review_title(String name) {
    return 'مراجعة وجبات $name';
  }

  @override
  String get family_review_subtitle => 'راجع اختيارات اليوم قبل التأكيد';

  @override
  String get family_review_status_ready => 'جاهز للتأكيد';

  @override
  String get family_review_selected_day_label => 'اليوم المحدد';

  @override
  String get family_review_goal_label => 'الهدف';

  @override
  String get family_review_goal_balanced => 'متوازن';

  @override
  String get family_review_selected_meals_section => 'الوجبات المختارة';

  @override
  String get family_slot_breakfast => 'الإفطار';

  @override
  String get family_slot_lunch => 'الغداء';

  @override
  String get family_slot_dinner => 'العشاء';

  @override
  String get family_slot_snack => 'سناك';

  @override
  String get family_review_edit_button => 'تعديل';

  @override
  String get family_review_nutrition_summary_section => 'ملخص القيم الغذائية';

  @override
  String family_review_calories_progress(String current, String target) {
    return '$current من $target سعرة';
  }

  @override
  String family_review_grams_progress(String current, String target) {
    return '$current من $target جم';
  }

  @override
  String get family_review_member_instructions_section => 'تعليمات الفرد';

  @override
  String get family_review_preferences_note =>
      'سيتم مراعاة تفضيلاتك في حال احتياج استبدال أي وجبة';

  @override
  String get family_review_cutoff_title =>
      'يمكنك تعديل وجبات اليوم حتى وقت القفل';

  @override
  String get family_review_cutoff_desc =>
      'بمجرد وصول وقت القفل، سيتم تجهيز وجباتك رسمياً ولا يمكن إلغاء أو تعديل بعد ذلك.';

  @override
  String family_review_cutoff_time(String time) {
    return 'الوقت المتبقي: $time';
  }

  @override
  String get family_review_cutoff_disclaimer =>
      'في حال لم تكتمل الوجبات المتبقية، سيتم تعيينها تلقائياً بناءً على التفضيلات';

  @override
  String get family_review_edit_meals_button => 'تعديل الوجبات';

  @override
  String family_review_confirm_meals_button(String name) {
    return 'تأكيد وجبات $name';
  }

  @override
  String get family_review_success_message => 'تم تأكيد الوجبات بنجاح';

  @override
  String get family_meal_item_1_title => 'دجاج مشوي بالأعشاب';

  @override
  String get family_meal_item_1_desc =>
      'دجاج مشوي متبل بالأعشاب مع أرز بني وخضار مشكلة';

  @override
  String get family_meal_item_2_title => 'سلمون مشوي بالليمون';

  @override
  String get family_meal_item_2_desc =>
      'سلمون مشوي مع كينوا وخضار مشوية وصوص الليمون';

  @override
  String get family_meal_item_3_title => 'كفتة لحم بصلصة الطماطم';

  @override
  String get family_meal_item_3_desc =>
      'كفتة لحم بقري بصوص الطماطم مع بطاطس مهروسة وبروكلي';

  @override
  String get family_meal_item_4_title => 'طبق نباتي متوازن';

  @override
  String get family_meal_item_4_desc =>
      'كفتة نباتية مع حمص، كينوا، خضار مثلجة، وصوص طحينة';

  @override
  String get family_meal_tag_gluten_free => 'خالي من الجلوتين';

  @override
  String get family_meal_tag_contains_nuts => 'يحتوي على مكسرات';

  @override
  String get family_meal_tag_omega3 => 'مصدر أوميغا 3';

  @override
  String get family_review_meal_1_name => 'إفطار شوفان بالعسل والموز';

  @override
  String get family_review_meal_2_name => 'دجاج مشوي مع أرز بني وخضار مشوية';

  @override
  String get family_review_meal_3_name => 'سلمون بالليمون مع كينوا وسلطة خضراء';

  @override
  String get family_review_meal_4_name => 'زبادي يوناني مع توت وعسل';

  @override
  String get family_review_tag_no_nuts => 'بدون مكسرات';

  @override
  String get family_review_tag_brown_rice => 'يفضل الأرز البني';

  @override
  String get family_review_tag_not_spicy => 'لا طعام حار';

  @override
  String get subscription_upgrade_target_invalid =>
      'الطبقة المختارة غير صالحة للترقية.';

  @override
  String get upgrade_redirect_urls_required =>
      'بيانات إعادة التوجيه للدفع غير مكتملة.';

  @override
  String get upgrade_customer_not_found =>
      'بيانات العميل غير مكتملة لعملية الدفع.';

  @override
  String get subscription_upgrade_not_available =>
      'الاشتراك غير متاح للترقية حالياً.';

  @override
  String get subscription_upgrade_request_already_pending =>
      'يوجد طلب ترقية معلق قيد المتابعة بالفعل.';

  @override
  String get subscription_not_found => 'لم يتم العثور على الاشتراك.';

  @override
  String get subscription_upgrade_default_error =>
      'حدث خطأ أثناء بدء عملية الترقية، يرجى المحاولة مرة أخرى.';

  @override
  String get restaurant_tier_upgrade_success =>
      'تمت ترقية التصنيف بنجاح وتفعيل الاشتراك المحدث فوراً';

  @override
  String get restaurant_tier_upgrade_confirm_title => 'تأكيد ترقية التصنيف';

  @override
  String get restaurant_tier_upgrade_no_data =>
      'لا توجد بيانات متاحة لطلب الترقية.';

  @override
  String get family_error_cannot_remove_manager => 'لا يمكن حذف مدير العائلة.';

  @override
  String get family_error_member_not_found => 'لم يتم العثور على فرد العائلة.';

  @override
  String get family_error_not_manager => 'هذا الإجراء متاح لمدير العائلة فقط.';

  @override
  String get family_error_use_checkout_flow =>
      'أضف أفراد العائلة من خلال خطوات الاشتراك والدفع.';

  @override
  String get family_error_manager_permissions_immutable =>
      'لا يمكن تغيير صلاحيات مدير العائلة.';

  @override
  String get family_error_member_paused => 'هذا الفرد موقوف حالياً.';

  @override
  String get family_error_permission_denied =>
      'هذا الفرد لا يملك صلاحية تعديل الوجبات.';

  @override
  String get family_error_renewal_not_available =>
      'لا يمكن تجديد هذا الاشتراك حالياً.';

  @override
  String get family_error_subscription_not_found =>
      'لم يتم العثور على اشتراك الفرد المطلوب.';

  @override
  String get family_error_customer_only => 'هذا الإجراء متاح للعملاء فقط.';

  @override
  String get family_member_no_plan => 'من غير خطة';

  @override
  String get family_member_paused_label => 'موقوف';

  @override
  String get family_member_active_label => 'نشط';

  @override
  String family_member_days_remaining(int count) {
    return 'متبقي $count أيام';
  }

  @override
  String family_member_age_years(int count) {
    return '$count سنة';
  }

  @override
  String family_member_details_title(String name) {
    return 'تفاصيل $name';
  }

  @override
  String get family_member_manager_label => 'مدير العائلة';

  @override
  String get family_member_member_label => 'فرد في العائلة';

  @override
  String get family_member_program_title => 'البرنامج الغذائي';

  @override
  String get family_member_change_program => 'تغيير البرنامج';

  @override
  String get family_member_package_title => 'الاشتراك';

  @override
  String family_member_subscription_dates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get family_member_renew_subscription => 'تجديد الاشتراك';

  @override
  String get family_member_today_nutrition => 'تغذية اليوم';

  @override
  String family_member_calories_value(String count) {
    return '$count سعرة';
  }

  @override
  String get family_member_show_calendar => 'عرض التقويم';

  @override
  String get family_member_access_phone_label => 'رقم الموبايل';

  @override
  String get family_member_access_pause_label => 'إيقاف الفرد';

  @override
  String get family_member_access_remove_label => 'حذف الفرد';

  @override
  String get family_member_access_generated_password_title =>
      'كلمة مرور لمرة واحدة';

  @override
  String get family_member_access_generated_password_message =>
      'شارك كلمة المرور الآن، لن يتم عرضها مرة أخرى.';

  @override
  String get family_member_access_existing_login =>
      'رقم الموبايل لديه حساب MealMate بالفعل، ويمكن للفرد الدخول بكلمة المرور الحالية.';

  @override
  String get family_member_access_copy => 'نسخ';

  @override
  String get family_member_shortcut_daily_meals => 'الوجبات اليومية';

  @override
  String get family_member_shortcut_daily_meals_subtitle =>
      'عرض الوجبات والخطط';

  @override
  String get family_member_shortcut_permissions => 'الصلاحيات';

  @override
  String get family_member_shortcut_permissions_subtitle =>
      'عرض وإدارة الصلاحيات';

  @override
  String family_member_calendar_title(String name) {
    return 'تقويم $name';
  }

  @override
  String get family_member_no_active_subscription =>
      'هذا الفرد ليس لديه اشتراك نشط حالياً.';

  @override
  String get family_member_no_meals_selected =>
      'لا توجد وجبات مختارة لهذا اليوم.';

  @override
  String family_member_selected_meals_count(int count) {
    return '$count وجبات مختارة';
  }

  @override
  String get family_member_day_details_button => 'عرض تفاصيل اليوم';

  @override
  String get family_member_choose_meals_button => 'اختيار الوجبات';

  @override
  String get family_member_selected_meals_title => 'الوجبات المختارة';

  @override
  String family_member_selected_meals_subtitle(String name, String date) {
    return 'الوجبات المختارة لـ$name يوم $date';
  }

  @override
  String get family_member_meal_chosen => 'تم الاختيار';

  @override
  String get family_member_choose_meal => 'اختار وجبة';

  @override
  String get family_day_screen_title => 'تفاصيل يوم';

  @override
  String get family_day_current_restaurant_subtitle => 'المطعم الحالي';

  @override
  String get family_day_review_meals_button => 'مراجعة وجبات اليوم';

  @override
  String get family_day_all_meals_selected => 'تم اختيار جميع الوجبات';

  @override
  String get family_day_default_restaurant_name => 'مطعم جرين شيف';

  @override
  String get influencer_header_greeting => 'مرحباً ، محمد';

  @override
  String get currency_kwd => 'د.ك';

  @override
  String get offer_browse_title => 'العروض المتاحة';

  @override
  String get offer_browse_empty => 'لا توجد عروض متوفرة حالياً';

  @override
  String get offer_browse_tab_all => 'الكل';

  @override
  String get offer_browse_tab_offers => 'عروض خاصة';

  @override
  String get offer_browse_tab_restaurants => 'مطاعم';

  @override
  String get offer_browse_tab_subscriptions => 'اشتراكات';

  @override
  String get offer_browse_remaining_spots => 'مقاعد متبقية';

  @override
  String get offer_browse_action_button => 'استفد من العرض';

  @override
  String get offer_hub_view_all => 'عرض الكل';

  @override
  String get offer_hub_share_message => 'تم نسخ رابط المشاركة!';

  @override
  String get offer_deal_best_seller => 'الأكثر طلباً';

  @override
  String get offer_deal_action_button => 'اطلب الآن';

  @override
  String get offer_deal_free_delivery => 'توصيل مجاني';

  @override
  String get offer_details_code_label => 'كود الخصم';

  @override
  String get offer_details_copy_code => 'تم نسخ الكود بنجاح';

  @override
  String get offer_countdown_prefix => 'ينتهي العرض خلال';

  @override
  String get offer_countdown_expired => 'انتهى هذا العرض';

  @override
  String get offer_status_expired => 'العرض منتهي الصلاحية';

  @override
  String get offer_status_sold_out => 'نفدت المقاعد';

  @override
  String get offer_promo_title => 'إدخال كود الخصم';

  @override
  String get offer_promo_headline => 'لديك كود خصم أو كوبون؟';

  @override
  String get offer_promo_subtitle =>
      'أدخل كود الخصم للاستفادة من أفضل العروض الحصرية على اشتراكاتك';

  @override
  String get offer_promo_hint => 'أدخل الكود هنا (مثال: SAVE20)';

  @override
  String get offer_promo_paste_tooltip => 'لصق من الحافظة';

  @override
  String get offer_promo_apply_button => 'تطبيق الكود';

  @override
  String get offer_promo_empty_error => 'يرجى كتابة كود الخصم أولاً';

  @override
  String get offer_promo_invalid_error =>
      'كود الخصم غير صالح أو منتهي الصلاحية';

  @override
  String get offer_promo_available_codes_title => 'أكواد مقترحة لك';

  @override
  String get offer_promo_apply_code => 'تطبيق';

  @override
  String get offer_promo_save20_title => 'خصم 20% على جميع الباقات الشهرية';

  @override
  String get offer_promo_fit10_title => 'خصم 10% على برامج اللياقة';

  @override
  String get offer_promo_welcome_title => 'خصم 15% للمشتركين الجدد';

  @override
  String get offer_redeem_title => 'تطبيق العرض واختيار الباقة';

  @override
  String get offer_redeem_select_package_title => 'اختر مدة الباقة المناسبة لك';

  @override
  String get offer_package_month_title => 'باقة شهر كامل (26 يوم)';

  @override
  String get offer_package_half_month_title => 'باقة نصف شهر (13 يوم)';

  @override
  String get offer_package_week_title => 'باقة أسبوعية (6 أيام)';

  @override
  String offer_redeem_min_days_notice(String days) {
    return 'يتطلب هذا العرض اشتراكاً بحد أدنى $days يوم';
  }

  @override
  String get offer_redeem_total_after_discount => 'الإجمالي بعد الخصم';

  @override
  String get offer_redeem_proceed_button => 'المتابعة لتأكيد الاشتراك';

  @override
  String get offer_redeem_safe_payment_notice => 'عملية دفع آمنة ومشفرة 100%';

  @override
  String get offer_checkout_title => 'تأكيد الاشتراك بالعرض';

  @override
  String get offer_checkout_applied_title => 'تم تطبيق العرض بنجاح!';

  @override
  String get offer_checkout_applied_code => 'الكود المعتمد';

  @override
  String get offer_checkout_applied_description =>
      'تم تفعيل أفضل خصم متاح على باقتك المختارة';

  @override
  String get offer_checkout_order_summary_title => 'ملخص الاشتراك';

  @override
  String get offer_checkout_package_label => 'الباقة المختارة';

  @override
  String get offer_checkout_meals_per_day => 'عدد الوجبات يومياً';

  @override
  String get offer_checkout_original_price => 'السعر الأصلي';

  @override
  String get offer_checkout_discount_amount => 'قيمة الخصم';

  @override
  String get offer_checkout_final_total => 'المبلغ الإجمالي للدفع';

  @override
  String get offer_checkout_secure_badge =>
      'عملية الدفع محمية ومضمونة عبر بوابة الدفع الآمنة';

  @override
  String get offer_checkout_proceed_button => 'تأكيد ودفع الآن';

  @override
  String get offer_checkout_change_package_button => 'تغيير الباقة أو العرض';

  @override
  String get offer_activation_success_title => 'تم تفعيل الاشتراك بنجاح';

  @override
  String get offer_activation_congrats => 'مبروك! تم تفعيل عرضك بنجاح';

  @override
  String get offer_activation_subtitle =>
      'أصبحت باقتك جاهزة للاستخدام. يمكنك الآن بدء تحديد وجباتك وجدولها';

  @override
  String get offer_activation_order_title => 'تفاصيل الاشتراك المفعل';

  @override
  String get offer_activation_paid_total => 'المبلغ المدفوع';

  @override
  String get offer_activation_choose_plan_button => 'جدولة واختيار الوجبات';

  @override
  String get meals_count => 'وجبات';

  @override
  String get notifications_screen_title => 'الإشعارات';

  @override
  String get notifications_mark_all_read => 'تحديد الكل كمقروء';

  @override
  String get notifications_filter_all => 'الكل';

  @override
  String get notifications_filter_orders => 'الطلبات والتوصيل';

  @override
  String get notifications_filter_reminders => 'التذكيرات';

  @override
  String get notifications_filter_offers => 'العروض';

  @override
  String get notifications_group_today => 'اليوم';

  @override
  String get notifications_group_yesterday => 'أمس';

  @override
  String get notifications_group_earlier => 'هذا الأسبوع';

  @override
  String get notifications_empty_title => 'لا توجد إشعارات حالياً';

  @override
  String get notifications_empty_subtitle =>
      'سنخبرك بكل جديد فور توفر تحديثات لوجباتك أو اشتراكك';

  @override
  String get notifications_time_just_now => 'الآن';

  @override
  String notifications_time_minutes_ago(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String notifications_time_hours_ago(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String get notifications_action_track => 'تتبع الطلب';

  @override
  String get notifications_action_select_meal => 'اختيار الوجبة';

  @override
  String get notifications_action_view_offer => 'عرض العرض';

  @override
  String get notifications_tab_all => 'الكل';

  @override
  String get notifications_tab_subscription => 'الباقة والاشتراك';

  @override
  String get notifications_tab_meals => 'الوجبات';

  @override
  String get notifications_tab_system => 'النظام';

  @override
  String get notifications_clear_all => 'مسح الاشعارات';

  @override
  String get notif_today_meals_title => 'وجبات اليوم جاهزة للاختيار';

  @override
  String get notif_today_meals_subtitle =>
      'لم تقم باختيار وجبات 2 من أفراد العائلة';

  @override
  String get notif_meals_selected_title => 'تم اختيار الوجبات بنجاح';

  @override
  String get notif_meals_selected_subtitle =>
      'تم اختيار وجبات أحمد لليوم الإثنين';

  @override
  String get notif_package_renew_title => 'تجديد الباقة';

  @override
  String get notif_package_renew_subtitle => 'تم تجديد باقتك العائلية بنجاح';

  @override
  String get notif_delivery_coming_title => 'توصيل قادم';

  @override
  String get notif_delivery_coming_subtitle =>
      'توصيل وجبات الغد بين 8:00 ص - 10:00 ص';

  @override
  String get notif_new_offer_title => 'عرض جديد';

  @override
  String get notif_new_offer_subtitle => 'احصل على وجبة مجانية عند دعوة صديق';

  @override
  String get notif_system_update_title => 'تحديث النظام';

  @override
  String get notif_system_update_subtitle =>
      'تم تحديث التطبيق إلى الإصدار الجديد';

  @override
  String get notifications_prefs_title => 'إعدادات الإشعارات';

  @override
  String get notifications_prefs_subtitle =>
      'اختر أنواع الإشعارات التي تريد استلامها';

  @override
  String get notifications_prefs_allow_all => 'السماح بالإشعارات';

  @override
  String get notifications_prefs_allow_all_subtitle =>
      'تفعيل أو إيقاف جميع الإشعارات';

  @override
  String get notifications_prefs_meals => 'الوجبات';

  @override
  String get notifications_prefs_meals_subtitle =>
      'إشعارات تتعلق باختيار وتجهيز الوجبات';

  @override
  String get notifications_prefs_delivery => 'التوصيل';

  @override
  String get notifications_prefs_delivery_subtitle =>
      'إشعارات تتعلق بحالة التوصيل';

  @override
  String get notifications_prefs_subscription => 'الإشتراك والدفع';

  @override
  String get notifications_prefs_subscription_subtitle =>
      'إشعارات تتعلق بالاشتراك والمدفوعات';

  @override
  String get notifications_prefs_offers => 'العروض والمكافآت';

  @override
  String get notifications_prefs_offers_subtitle =>
      'إشعارات خاصة بالعروض والمكافآت';

  @override
  String get notifications_prefs_family => 'العائلة';

  @override
  String get notifications_prefs_family_subtitle =>
      'إشعارات متعلقة بأفراد العائلة';

  @override
  String get notifications_prefs_family_badge => 'ظاهر فقط لمدير العائلة';

  @override
  String get notifications_prefs_account => 'الحساب والنظام';

  @override
  String get notifications_prefs_account_subtitle =>
      'إشعارات تخص حسابك وبيانات التطبيق';

  @override
  String get notifications_prefs_footer_info =>
      'ستصلك الإشعارات وفق إعداداتك، يمكنك تغييرها في أي وقت.';

  @override
  String get subscription_success_title => 'تم تفعيل اشتراكك بنجاح';

  @override
  String get subscription_success_subtitle =>
      'اشتراكك جاهز الآن، ويمكنك البدء باختيار وجباتك وتخصيص خطتك الغذائية.';

  @override
  String get subscription_success_summary_title => 'ملخص الاشتراك';

  @override
  String get subscription_success_package_label => 'الباقة';

  @override
  String get subscription_success_duration_label => 'المدة';

  @override
  String get subscription_success_tier_label => 'تصنيف المطاعم';

  @override
  String get subscription_success_payment_date_label => 'تاريخ الدفع';

  @override
  String get subscription_success_start_date_label => 'تاريخ بدأ الاشتراك';

  @override
  String get subscription_success_end_date_label => 'تاريخ انتهاء الاشتراك';

  @override
  String get subscription_success_payment_confirmed_title =>
      'تم تأكيد الدفع وتفعيل الاشتراك';

  @override
  String get subscription_success_payment_confirmed_desc =>
      'يمكنك إدارة اشتراكك والقوائم من حسابك في أي وقت.';

  @override
  String get subscription_success_next_step_title => 'الخطوة التالية';

  @override
  String get subscription_success_next_step_desc =>
      'اختر وجباتك للأيام القادمة وحدد المطعم المناسب لك.';

  @override
  String get subscription_success_start_meals_button => 'ابدأ اختيار وجباتك';

  @override
  String get subscription_success_view_subscription_button => 'عرض الاشتراك';

  @override
  String get sandbox_badge => 'تجربة';

  @override
  String get sandbox_checkout_title => 'إكمال بدون دفع — تجربة';

  @override
  String get sandbox_checkout_subtitle => 'بيئة تجريبية بدون خصم فعلي';

  @override
  String get notification_button_tooltip => 'الإشعارات';

  @override
  String get meal_details_per_meal => 'لكل وجبة';

  @override
  String get meal_details_per_100g => 'لكل 100 جم';

  @override
  String get meal_tag_high_protein => 'عالي البروتين';

  @override
  String get meal_tag_diet_friendly => 'مناسب للدايت';

  @override
  String get meal_tag_natural_ingredients => 'مكونات طبيعية';

  @override
  String get coupon_status_valid => 'تم تطبيق الكوبون بنجاح';

  @override
  String get coupon_status_not_found => 'كود الخصم غير موجود';

  @override
  String get coupon_status_inactive => 'كود الخصم غير مُفعّل حاليًا';

  @override
  String get coupon_status_not_started => 'لم يبدأ تاريخ صلاحية كود الخصم بعد';

  @override
  String get coupon_status_expired => 'انتهت صلاحية كود الخصم';

  @override
  String get coupon_status_usage_exhausted =>
      'تم استنفاد عدد مرات استخدام كود الخصم';

  @override
  String get coupon_status_stacking_conflict =>
      'لا يمكن الجمع بين كود الخصم والعرض الحالي';

  @override
  String get coupon_status_ineligible => 'كود الخصم غير مؤهل لهذا الاشتراك';

  @override
  String get coupon_status_unknown => 'كود الخصم غير صالح';

  @override
  String get coupon_error_rejected => 'تم رفض كود الخصم';

  @override
  String get coupon_error_no_longer_valid => 'انتهت صلاحية كود الخصم';

  @override
  String get coupon_error_full_discount_unsupported =>
      'الدفع بمبلغ صفري غير مدعوم حاليًا. أزل الكود أو استخدم كودًا آخر.';

  @override
  String get coupon_apply_button => 'تطبيق';

  @override
  String get coupon_remove_button => 'إزالة';

  @override
  String get coupon_input_hint => 'أدخل كود الخصم';

  @override
  String get coupon_card_title => 'كود الخصم';

  @override
  String get coupon_applied_label => 'تم تطبيق الخصم';
}
