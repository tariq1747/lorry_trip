import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/enums.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';
import 'package:lorry_trip/modules/trip_module.dart';

import '../controller/home_controller.dart';

class TripDetailView extends GetView<HomeController> {
  const TripDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Trip Details",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textPrimary,
        centerTitle: true,
      ),
      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        // 2. Empty State
        final trip = controller.tripDetails;
        if (trip == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: 24.all,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.assignment_late_outlined,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                ),
                24.heightBox,
                Text(
                  "No data found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // 3. Populated State
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfitCard(trip),

              _buildRouteHeader(trip),

              _buildSectionTitle("Logistics & Transport"),
              _buildCardSection([
                _buildDetailRow(
                  Icons.business,
                  "Transport Name",
                  trip.transportName ?? "N/A",
                ),
                _buildDetailRow(
                  Icons.person,
                  "Driver Name",
                  trip.driverName ?? "N/A",
                ),
                _buildDetailRow(
                  Icons.local_shipping,
                  "Vehicle Number",
                  trip.vehicleNumber ?? "N/A",
                ),
                _buildDetailRow(
                  Icons.calendar_today,
                  "Trip Date",
                  trip.tripDate?.toString() ?? "N/A",
                ),
                _buildDetailRow(
                  Icons.line_weight,
                  "Load Details",
                  trip.loadDetails ?? "N/A",
                  hideDivider: true,
                ),
              ]),

              _buildSectionTitle("Primary Financials"),
              _buildCardSection([
                _buildDetailRow(
                  Icons.account_balance_wallet,
                  "Total Cost (Revenue)",
                  "₹${trip.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                  isHighlight: true,
                  highlightColor: AppTheme.success,
                ),
                _buildDetailRow(
                  Icons.receipt,
                  "Punch Cost",
                  "₹${trip.punchCost?.toStringAsFixed(2) ?? '0.00'}",
                  hideDivider: true,
                ),
              ]),

              // Expenses Section
              if (trip.expense != null) ...[
                _buildSectionTitle("Trip Expenses"),
                _buildCardSection([
                  _buildDetailRow(
                    Icons.local_gas_station,
                    "Diesel Cost",
                    "₹${trip.expense!.dieselCost?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    Icons.water_drop,
                    "Diesel Volume",
                    "${trip.expense!.dieselLiter ?? '0'} Liters",
                  ),
                  _buildDetailRow(
                    Icons.calendar_month,
                    "Expense Date",
                    trip.expense!.expenseDate?.toString() ?? "N/A",
                  ),
                  _buildDetailRow(
                    Icons.toll,
                    "Toll / FastTag",
                    "₹${trip.expense!.tollFasttag?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    Icons.person_pin,
                    "Driver Fee",
                    "₹${trip.expense!.driverFee?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    Icons.local_shipping_outlined,
                    "Transport Fee",
                    "₹${trip.expense!.transportFee?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    Icons.build,
                    "Maintenance",
                    "₹${trip.expense!.maintenanceCost?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    Icons.receipt_long,
                    "Other Expenses",
                    "₹${trip.expense!.otherExpenses?.toStringAsFixed(2) ?? '0.00'}",
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                    padding: 12.all,
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.1),
                      borderRadius: 8.radius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Expense",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.error,
                          ),
                        ),
                        Text(
                          "₹${_calculateTotalExpenseString(trip.expense!)}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],

              // Completion Details Section
              if (trip.completion != null) ...[
                _buildSectionTitle("Completion Status"),
                _buildCardSection([
                  _buildDetailRow(
                    Icons.pin_drop,
                    "Drop Location",
                    trip.completion!.location ?? 'N/A',
                  ),
                  _buildDetailRow(
                    Icons.event_available,
                    "Completion Date",
                    trip.completion!.completionDate?.toString() ?? "N/A",
                  ),
                  _buildDetailRow(
                    Icons.move_down,
                    "Unloading Charge",
                    "₹${trip.completion!.unloadingCharge?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                  _buildDetailRow(
                    (trip.completion!.punchCostReceived ?? false)
                        ? Icons.check_circle
                        : Icons.cancel,
                    "Punch Cost Received",
                    (trip.completion!.punchCostReceived ?? false)
                        ? "Yes"
                        : "No",
                    isHighlight: true,
                    highlightColor:
                        (trip.completion!.punchCostReceived ?? false)
                        ? AppTheme.success
                        : AppTheme.error,
                    hideDivider: true,
                  ),
                ]),
              ],

              20.heightBox, // Bottom padding
            ],
          ),
        );
      }),
    );
  }

  // --- UI Helpers ---

  Widget _buildProfitCard(Trip trip) {
    double profit = _calculateProfit(trip);
    bool isProfitable = profit >= 0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: 16.radius,
        gradient: LinearGradient(
          colors: isProfitable
              ? [const Color(0xFF00b09b), const Color(0xFF96c93d)]
              : [const Color(0xFFcb2d3e), const Color(0xFFef473a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isProfitable ? Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "NET PROFIT",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          8.heightBox,
          Text(
            "₹${profit.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(Trip trip) {
    Color statusColor = AppTheme.primary;
    if (trip.status == TripStatus.completed) statusColor = AppTheme.success;
    if (trip.status == TripStatus.inProgress) statusColor = Colors.orange;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: 16.radius,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trip #${trip.tripId}",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: 20.radius,
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  trip.status.value,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          20.heightBox,

          // Timeline UI
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.my_location,
                    size: 22,
                    color: AppTheme.primary,
                  ),
                  Container(
                    height: 30,
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade300,
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 22,
                    color: AppTheme.error,
                  ),
                ],
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Location",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      trip.startLocation ?? "Unknown",
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    24.heightBox,

                    Text(
                      "End Location",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      trip.endLocation ?? "Unknown",
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, bottom: 1.h, top: 1.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: AppTheme.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: 16.radius,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isHighlight = false,
    Color? highlightColor,
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Styled Icon Box
              Container(
                padding: 8.all,
                decoration: BoxDecoration(
                  color: (highlightColor ?? AppTheme.primary).withOpacity(0.1),
                  borderRadius: 8.radius,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: highlightColor ?? AppTheme.primary,
                ),
              ),
              12.widthBox,
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: isHighlight ? 15.sp : 14.sp,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                    color: isHighlight
                        ? (highlightColor ?? AppTheme.textPrimary)
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!hideDivider)
          Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
      ],
    );
  }

  // --- Logic Helpers ---

  double _calculateTotalExpense(Trip trip) {
    double expenseTotal = 0.0;

    // Add primary expenses
    if (trip.expense != null) {
      expenseTotal +=
          (trip.expense!.dieselCost ?? 0) +
          (trip.expense!.otherExpenses ?? 0) +
          (trip.expense!.driverFee ?? 0) +
          (trip.expense!.tollFasttag ?? 0) +
          (trip.expense!.transportFee ?? 0) +
          (trip.expense!.maintenanceCost ?? 0).toDouble();
    }

    // Add unloading charge as an expense
    if (trip.completion != null) {
      expenseTotal += (trip.completion!.unloadingCharge ?? 0).toDouble();
    }

    return expenseTotal;
  }

  String _calculateTotalExpenseString(Expense expense) {
    double total =
        (expense.dieselCost ?? 0) +
        (expense.otherExpenses ?? 0) +
        (expense.driverFee ?? 0) +
        (expense.tollFasttag ?? 0) +
        (expense.transportFee ?? 0) +
        (expense.maintenanceCost ?? 0).toDouble();
    return total.toStringAsFixed(2);
  }

  double _calculateProfit(Trip trip) {
    double revenue = (trip.totalCost ?? 0.0).toDouble();
    double expenses = _calculateTotalExpense(trip);

    // Note: Adjust this formula if punchCost needs to be added/subtracted
    // from the final profit calculation for your specific business logic.
    return revenue - expenses;
  }
}
