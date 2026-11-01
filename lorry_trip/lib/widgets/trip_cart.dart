import 'package:flutter/material.dart';
import 'package:lorry_trip/config/responsiveness.dart';
import 'package:lorry_trip/config/themes.dart';
import 'package:lorry_trip/modules/trip_module.dart';
import 'package:intl/intl.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({Key? key, required this.trip, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: 20.radius, // Softer, modern corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: 20.radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // HEADER SECTION (Tinted Background)
              // ==========================================
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.04),
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.primary.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_center,
                            size: 18,
                            color: AppTheme.primary,
                          ),
                          8.widthBox,
                          Expanded(
                            child: Text(
                              trip.transportName ?? 'Unknown Transport',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.widthBox,
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: trip.status.color,
                        borderRadius: 30.radius,
                        boxShadow: [
                          BoxShadow(
                            color: trip.status.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        trip.status.value.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 9.5.sp,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // BODY SECTION
              // ==========================================
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- VERTICAL ROUTE TIMELINE ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Graphics
                        Column(
                          children: [
                            4.heightBox,
                            Icon(
                              Icons.radio_button_checked,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: AppTheme.primary.withOpacity(0.2),
                            ),
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppTheme.error,
                            ),
                          ],
                        ),
                        12.widthBox,
                        // Timeline Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PICKUP LOCATION",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                trip.startLocation ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              20.heightBox, // Spacing matching the vertical line

                              Text(
                                "DROP LOCATION",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                trip.endLocation ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    20.heightBox,
                    Divider(color: Colors.grey.shade200, height: 1),
                    16.heightBox,

                    // --- TRIP DETAILS GRID ---
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoBlock(
                            "Date",
                            trip.tripDate != null
                                ? DateFormat(
                                    'dd MMM, yy',
                                  ).format(trip.tripDate!)
                                : 'N/A',
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildInfoBlock(
                            "Driver",
                            trip.driverName ?? 'N/A',
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildInfoBlock(
                            "Vehicle",
                            trip.vehicleNumber ?? 'N/A',
                          ),
                        ),
                      ],
                    ),

                    16.heightBox,

                    // --- FOOTER (Pricing) ---
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: 12.radius,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 18,
                                color: AppTheme.textSecondary,
                              ),
                              6.widthBox,
                              Text(
                                'Total Revenue',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              _formatCost(trip.totalCost?.toDouble() ?? 0.0),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Grid Info Block
  Widget _buildInfoBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        4.heightBox,
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  // Helper: Fallback formatting for large numbers
  String _formatCost(double cost) {
    if (cost > 999999999) {
      return "₹${cost.toStringAsExponential(2)}";
    }
    return "₹${cost.toStringAsFixed(2)}";
  }
}
