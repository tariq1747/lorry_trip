import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizeExtension on num {
  /// Width percentage
  double get w => Get.width * (this / 100);

  /// Height percentage
  double get h => Get.height * (this / 100);

  /// Responsive font size (optional)
  double get sp => Get.width * (this / 375);

  /// Radius
  BorderRadius get radius => BorderRadius.circular(toDouble());

  /// EdgeInsets All
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// Horizontal Padding
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Vertical Padding
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  /// SizedBox Height
  SizedBox get heightBox => SizedBox(height: toDouble());

  /// SizedBox Width
  SizedBox get widthBox => SizedBox(width: toDouble());
}
