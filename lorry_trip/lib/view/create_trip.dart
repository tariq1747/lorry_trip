import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';
import 'package:lorry_trip/controller/home_controller.dart';
import 'package:lorry_trip/widgets/app_button.dart';
import 'package:lorry_trip/widgets/app_text_field.dart';

class CreateTripView extends GetView<HomeController> {
  const CreateTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Create New Trip",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: Obx(
        () => Form(
          key: controller.formKey,
          autovalidateMode: controller.autoValidate.value
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
                      _buildSectionTitle("Route Details"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.startLocation,
                          label: "Start Location",
                          prefixIcon: Icons.radio_button_checked,
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.endLocation,
                          label: "End Location",
                          prefixIcon: Icons.location_on,
                          validator: controller.requiredValidator,
                        ),
                      ]),

                      _buildSectionTitle("Logistics & Transport"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.transportName,
                          label: "Transport Name",
                          prefixIcon: Icons.business,
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.driverName,
                          label: "Driver Name",
                          prefixIcon: Icons.person,
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.vehicleNumber,
                          label: "Vehicle Number",
                          prefixIcon: Icons.local_shipping,
                          validator: controller
                              .vehicleValidator, // Dedicated Plate regex validation
                        ),
                        AppTextField(
                          controller: controller.date,
                          label: "Trip Assignment Date",
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => controller.pickDate(controller.date),
                          validator: controller.requiredValidator,
                        ),
                        AppTextField(
                          controller: controller.load,
                          label: "Load (Tons / Type)",
                          prefixIcon: Icons.line_weight,
                          validator: controller.requiredValidator,
                        ),
                      ]),

                      _buildSectionTitle("Financial Specifications"),
                      _buildFormGroup([
                        AppTextField(
                          controller: controller.totalCost,
                          label: "Total Cost (₹)",
                          prefixIcon: Icons.payments,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.numericValidator,
                        ),
                        AppTextField(
                          controller: controller.punchCost,
                          label: "Punch Cost (₹)",
                          prefixIcon: Icons.receipt_long,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: controller.numericValidator,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),

              // Bottom Action button pinning
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Obx(
                  () => AppButton(
                    title: "Generate Trip Registry",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.saveTrip,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
