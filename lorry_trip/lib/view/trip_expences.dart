import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/controller/home_controller.dart';
import 'package:lorry_trip/config/responsiveness.dart'; // Ensure SizeExtension is imported
import 'package:lorry_trip/config/themes.dart'; // Ensure AppTheme is imported

import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class TripExpenseView extends GetView<HomeController> {
  const TripExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Trip Expense",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      // Wrapped the form in Obx so autoValidateExpense triggers a rebuild
      body: Obx(
        () => Form(
          key: controller.expenseFormKey,
          autovalidateMode: controller.autoValidateExpense.value
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
                      // SECTION 1: Fuel & Date
                      _buildSectionTitle("Fuel Details"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.expenseDate,
                          label: "Expense Date",
                          prefixIcon: Icons.calendar_month,
                          readOnly: true,
                          onTap: () =>
                              controller.pickDate(controller.expenseDate),
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.dieselLiter,
                          label: "Diesel Volume (Liters)",
                          prefixIcon: Icons.local_gas_station,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.dieselCost,
                          label: "Diesel Total Cost (₹)",
                          prefixIcon: Icons.payments_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.requiredValidator,
                        ),
                      ]),

                      // SECTION 2: Mandatory Fees
                      _buildSectionTitle("Fees & Tolls"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.tollFasttag,
                          label: "Toll / FastTag (₹)",
                          prefixIcon: Icons.toll,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.driverFee,
                          label: "Driver Fee / Batta (₹)",
                          prefixIcon: Icons.person_pin,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.transportFee,
                          label: "Transport Commission (₹)",
                          prefixIcon: Icons.local_shipping_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.requiredValidator,
                        ),
                      ]),

                      // SECTION 3: Miscellaneous
                      _buildSectionTitle("Miscellaneous"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.maintenanceCost,
                          label: "Maintenance / Repairs (₹)",
                          prefixIcon: Icons.build_circle_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: null,
                        ),
                        AppTextField(
                          controller: controller.otherExpenses,
                          label: "Other Expenses (₹)",
                          prefixIcon: Icons.receipt_long,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: null,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),

              // Bottom Action button pinning
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: AppButton(
                  title: "Save Expenses",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveExpense,
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
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
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
      child: Column(children: children),
    );
  }
}
