import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/responsiveness.dart'; // Ensure SizeExtension is imported
import 'package:lorry_trip/config/themes.dart'; // Ensure AppTheme is imported

import '../controller/home_controller.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class TripCompleteView extends GetView<HomeController> {
  const TripCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Complete Trip",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      // Wrapped the entire Form in Obx to respond to autoValidateComplete changes
      body: Obx(
        () => Form(
          key: controller.completeTripFormKey,
          autovalidateMode: controller.autoValidateComplete.value
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: Completion Details
                      _buildSectionTitle("Completion Details"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.completeLocation,
                          label: "Completion Location",
                          prefixIcon: Icons.pin_drop_outlined,
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.completionDate,
                          label: "Completion Date",
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () =>
                              controller.pickDate(controller.completionDate),
                          validator: controller.requiredValidator,
                        ),
                      ]),

                      // SECTION 2: Financial Settlement
                      _buildSectionTitle("Financial Settlement"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.unloadingCharge,
                          label: "Unloading Charge (₹) - Optional",
                          prefixIcon: Icons.payments_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          // Making it optional: Only validate if the user enters data
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                            }
                            return null;
                          },
                        ),

                        1.heightBox, // Spacing using your extension
                        // Styled Switch Container
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: 12.radius,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SwitchListTile(
                            title: Text(
                              "Punch Cost Received",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: controller.punchCostReceived.value,
                            activeColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: 12.radius,
                            ),
                            onChanged: (value) {
                              controller.punchCostReceived.value = value;
                            },
                          ),
                        ),
                        1.heightBox,
                      ]),
                    ],
                  ),
                ),
              ),

              // Bottom Pinned Action Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: AppButton(
                  title: "Mark as Completed",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.completeTrip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helper: Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, bottom: 1.h, top: 1.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  // UI Helper: Form Group Card Container
  Widget _buildFormGroup(List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: 12.radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
