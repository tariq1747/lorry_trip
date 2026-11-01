import 'package:flutter/material.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: 12.radius),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: AppTheme.surface)
              : Text(title),
        ),
      ),
    );
  }
}
