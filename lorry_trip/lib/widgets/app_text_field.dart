import 'package:flutter/material.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final AutovalidateMode autovalidateMode;
  final IconData? prefixIcon; // Added for visual aesthetics

  @override
  Widget build(BuildContext context) {
    return Padding(
      // FIX: Changed from 16.all to only bottom padding for cleaner stacking
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode: autovalidateMode,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength: 50,
        onTap: onTap,
        style: TextStyle(fontSize: 14.sp, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: AppTheme.surface,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppTheme.primary, size: 20)
              : null,
          labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 13.sp),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.8.h,
          ),
          border: OutlineInputBorder(
            borderRadius: 12.radius,
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: 12.radius,
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: 12.radius,
            borderSide: const BorderSide(color: AppTheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: 12.radius,
            borderSide: const BorderSide(color: AppTheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: 12.radius,
            borderSide: const BorderSide(color: AppTheme.error, width: 2),
          ),
        ),
      ),
    );
  }
}
