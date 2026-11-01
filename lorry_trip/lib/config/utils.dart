import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';

class AppUtils {
  AppUtils._();

  /// Snackbar
  static void showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? AppTheme.error : AppTheme.success,
      colorText: Colors.white,
      margin: 16.all,
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  /// Loading Dialog
  static void showLoading() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: 20.all,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: 12.radius,
            ),
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Confirmation Dialog
  static Future<bool> showConfirmation({
    required String title,
    required String message,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: 16.radius),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Bottom Sheet
  static Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
  }) {
    return Get.bottomSheet<T>(
      Container(
        padding: 20.all,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(top: false, child: child),
      ),
      isDismissible: isDismissible,
      isScrollControlled: true,
    );
  }

  /// Date Picker
  static Future<DateTime?> pickDate({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: Get.context!,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2024),
      lastDate: lastDate ?? DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: AppTheme.primary)),
          child: child!,
        );
      },
    );
  }

  /// Time Picker
  static Future<TimeOfDay?> pickTime() {
    return showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
  }

  /// Hide Keyboard
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
