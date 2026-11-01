import 'package:flutter/material.dart';
import 'package:lorry_trip/config/themes.dart';

enum TripStatus {
  completed('COMPLETED'),
  inProgress('ON_THE_WAY'),
  pending('START');

  final String value;
  const TripStatus(this.value);

  // Uses AppTheme colors directly
  Color get color {
    switch (this) {
      case TripStatus.completed:
        return AppTheme.success;
      case TripStatus.inProgress:
        return AppTheme.secondary; // Mapped to secondary color
      case TripStatus.pending:
        return AppTheme.error;
    }
  }

  factory TripStatus.fromString(String status) {
    return TripStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => TripStatus.pending,
    );
  }
}
