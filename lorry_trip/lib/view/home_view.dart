import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';
import 'package:lorry_trip/controller/home_controller.dart';
import 'package:lorry_trip/widgets/trip_cart.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Trips',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          Obx(() {
            return Column(
              children: [
                if (controller.driverFilter.value.isNotEmpty ||
                    controller.vehicleFilter.value.isNotEmpty ||
                    controller.tripDate.value.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.do_disturb_on),
                    color: Colors.red.shade400,
                    onPressed: () => controller.applyFilters(clearAll: true),
                  ),
              ],
            );
          }),

          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filter Trips',
            onPressed: () => _showFilterBottomSheet(context),
          ),
          4.widthBox,
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
        onPressed: controller.onTapCreateTrip,
        icon: const Icon(Icons.add),
        label: const Text('Create Trip'),
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        // MUST pass isRefresh: true so it resets pagination to page 0
        onRefresh: () async => controller.getTrips(isRefresh: true),
        child: Obx(() {
          // 1. Initial Loading State
          if (controller.trips.isEmpty && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Empty State
          if (controller.trips.isEmpty && !controller.isLoading.value) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: Get.height * 0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      16.heightBox,
                      Text(
                        'No trips found',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      // Show clear filter button if filters are active but no results found
                      if (controller.driverFilter.value.isNotEmpty ||
                          controller.vehicleFilter.value.isNotEmpty ||
                          controller.tripDate.value.isNotEmpty)
                        TextButton.icon(
                          onPressed: () =>
                              controller.applyFilters(clearAll: true),
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Filters'),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }

          // 3. Populated List View with Pagination
          return ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 1.h, bottom: 100), // padding for FAB
            itemCount:
                controller.trips.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Render the loading spinner at the bottom of the list
              if (index == controller.trips.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // Render the Trip Card
              final currentTrip = controller.trips[index];
              return TripCard(
                trip: currentTrip,
                onTap: () => controller.openTrip(currentTrip),
              );
            },
          );
        }),
      ),
    );
  }

  // ==========================================
  // FILTER BOTTOM SHEET
  // ==========================================
  void _showFilterBottomSheet(BuildContext context) {
    // Local controllers for the bottom sheet state
    final driverCtrl = TextEditingController(
      text: controller.driverFilter.value,
    );
    final vehicleCtrl = TextEditingController(
      text: controller.vehicleFilter.value,
    );
    final startDateCtrl = TextEditingController(
      text: controller.tripDate.value,
    );

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Filter Trips",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              16.heightBox,

              // Driver Name Filter
              TextField(
                controller: driverCtrl,
                decoration: InputDecoration(
                  labelText: "Driver Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              12.heightBox,

              // Vehicle Number Filter
              TextField(
                controller: vehicleCtrl,
                decoration: InputDecoration(
                  labelText: "Vehicle Number",
                  prefixIcon: const Icon(Icons.local_shipping_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              12.heightBox,

              // Date Filters (Row)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startDateCtrl,
                      readOnly: true,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null)
                          startDateCtrl.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked);
                      },
                      decoration: InputDecoration(
                        labelText: "Trip Date",
                        prefixIcon: const Icon(Icons.calendar_today, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              24.heightBox,

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Close sheet
                        controller.applyFilters(clearAll: true);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Clear All"),
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close sheet
                        controller.applyFilters(
                          driver: driverCtrl.text.trim(),
                          vehicle: vehicleCtrl.text.trim(),
                          date: startDateCtrl.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Apply Filters"),
                    ),
                  ),
                ],
              ),
              16.heightBox, // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
