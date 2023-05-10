import 'package:fluent_ui/fluent_ui.dart';

import '../services/dio/exceptions.dart';

/// Show Some custom local notifications inside the app
class CustomInfoBar {
  /// Show the notification (regular notification)
  CustomInfoBar.showDefault(
      {required BuildContext context,
      required String title,
      required InfoBarSeverity severity,
      bool isLong = false,
      String? content,
      Widget? action}) {
    showToast(
        context: context,
        title: title,
        content: content,
        severity: severity,
        isLong: isLong,
        action: action);
  }

  /// Show the notification (error notification)
  CustomInfoBar.showError(
      {required BuildContext context,
      required CustomError error,
      required InfoBarSeverity severity,
      bool isLong = false,
      String? content,
      Widget? action}) {
    String contentMessage = "";
    switch (error) {
      case CustomError.noInternet:
        contentMessage = "لا يوجد اتصال بالانترنت";
        break;
      case CustomError.notExists:
        contentMessage = "الحساب غير موجود ، عدل البيانات";
        break;
      case CustomError.unKnown:
        contentMessage = "خطأ غير معروف";
        break;
      case CustomError.formatException:
        contentMessage = "خطأ غير معروف";
        break;
      case CustomError.alreadyExists:
        contentMessage = "ًالمستخدم موجود مسبقا ،عدل البيانات";
        break;
      case CustomError.fieldsEmpty:
        contentMessage = "املئ جميع الحقول";
        break;
      case CustomError.weakPassword:
        contentMessage = "كلمة السر ضعيفة ، ادخل 6 محارف على الأقل";
        break;
      case CustomError.ensurePasswordCorrect:
        contentMessage = "تأكد من ادخال كلمة المرور بشكل صحيح";
        break;
      case CustomError.imageNotPicked:
        contentMessage = "من فضلك اخنر صورة";
        break;
      case CustomError.chooseJobType:
        contentMessage = "اختر مستوى التوظيف";
        break;
      case CustomError.chooseLocation:
        contentMessage = "اختر موقع ما";
        break;
      case CustomError.moreThan10:
        contentMessage = 'لا يمكن تحديد مواعيد مراجعة إضافية في هذا اليوم';
    }

    showToast(
        context: context,
        title: contentMessage,
        content: content,
        severity: severity,
        isLong: isLong,
        action: action);
  }

  void showToast(
      {required BuildContext context,
      required String title,
      required InfoBarSeverity severity,
      bool isLong = false,
      String? content,
      Widget? action}) {
    InfoBar(
      title: Text(title),
      content: content == null ? null : Text(content),
      severity: severity,
      isLong: isLong,
      isIconVisible: true,
      action: action,
    );
    displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: content == null ? null : Text(content),
          severity: severity,
          isLong: isLong,
          isIconVisible: true,
          action: action,
        );
      },
    );
  }
}
