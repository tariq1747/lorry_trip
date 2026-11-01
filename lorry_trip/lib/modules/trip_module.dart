import 'dart:convert';

import 'package:lorry_trip/config/enums.dart';

class Trip {
  final num tripId;
  final String? startLocation;
  final String? endLocation;
  final String? transportName;
  final num? totalCost;
  final num? punchCost;
  final String? driverName;
  final String? vehicleNumber;
  final DateTime? tripDate;
  final String? loadDetails;
  final TripStatus status;
  final Expense? expense;
  final Completion? completion;

  Trip({
    required this.tripId,
    this.startLocation,
    this.endLocation,
    this.transportName,
    this.totalCost,
    this.punchCost,
    this.driverName,
    this.vehicleNumber,
    this.tripDate,
    this.loadDetails,
    required this.status,
    this.expense,
    this.completion,
  });

  factory Trip.fromRawJson(String str) => Trip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    tripId: json["tripId"],
    startLocation: json["startLocation"],
    endLocation: json["endLocation"],
    transportName: json["transportName"],
    totalCost: json["totalCost"],
    punchCost: json["punchCost"],
    driverName: json["driverName"],
    vehicleNumber: json["vehicleNumber"],
    tripDate: json["tripDate"] == null
        ? null
        : DateTime.parse(json["tripDate"]),
    loadDetails: json["loadDetails"],
    status: TripStatus.fromString(json['status'] ?? 'START'),
    expense: json["expense"] == null ? null : Expense.fromJson(json["expense"]),
    completion: json["completion"] == null
        ? null
        : Completion.fromJson(json["completion"]),
  );

  Map<String, dynamic> toJson() => {
    "tripId": tripId,
    "startLocation": startLocation,
    "endLocation": endLocation,
    "transportName": transportName,
    "totalCost": totalCost,
    "punchCost": punchCost,
    "driverName": driverName,
    "vehicleNumber": vehicleNumber,
    "tripDate":
        "${tripDate!.year.toString().padLeft(4, '0')}-${tripDate!.month.toString().padLeft(2, '0')}-${tripDate!.day.toString().padLeft(2, '0')}",
    "loadDetails": loadDetails,
    "status": status,
    "expense": expense?.toJson(),
    "completion": completion?.toJson(),
  };
}

class Completion {
  final num? id;
  final String? location;
  final DateTime? completionDate;
  final num? unloadingCharge;
  final bool? punchCostReceived;

  Completion({
    this.id,
    this.location,
    this.completionDate,
    this.unloadingCharge,
    this.punchCostReceived,
  });

  factory Completion.fromRawJson(String str) =>
      Completion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Completion.fromJson(Map<String, dynamic> json) => Completion(
    id: json["id"],
    location: json["location"],
    completionDate: json["completionDate"] == null
        ? null
        : DateTime.parse(json["completionDate"]),
    unloadingCharge: json["unloadingCharge"],
    punchCostReceived: json["punchCostReceived"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "completionDate":
        "${completionDate!.year.toString().padLeft(4, '0')}-${completionDate!.month.toString().padLeft(2, '0')}-${completionDate!.day.toString().padLeft(2, '0')}",
    "unloadingCharge": unloadingCharge,
    "punchCostReceived": punchCostReceived,
  };
}

class Expense {
  final num? id;
  final num? dieselCost;
  final num? dieselLiter;
  final DateTime? expenseDate;
  final num? otherExpenses;
  final num? driverFee;
  final num? tollFasttag;
  final num? transportFee;
  final num? maintenanceCost;

  Expense({
    this.id,
    this.dieselCost,
    this.dieselLiter,
    this.expenseDate,
    this.otherExpenses,
    this.driverFee,
    this.tollFasttag,
    this.transportFee,
    this.maintenanceCost,
  });

  factory Expense.fromRawJson(String str) => Expense.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json["id"],
    dieselCost: json["dieselCost"],
    dieselLiter: json["dieselLiter"],
    expenseDate: json["expenseDate"] == null
        ? null
        : DateTime.parse(json["expenseDate"]),
    otherExpenses: json["otherExpenses"],
    driverFee: json["driverFee"],
    tollFasttag: json["tollFasttag"],
    transportFee: json["transportFee"],
    maintenanceCost: json["maintenanceCost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dieselCost": dieselCost,
    "dieselLiter": dieselLiter,
    "expenseDate":
        "${expenseDate!.year.toString().padLeft(4, '0')}-${expenseDate!.month.toString().padLeft(2, '0')}-${expenseDate!.day.toString().padLeft(2, '0')}",
    "otherExpenses": otherExpenses,
    "driverFee": driverFee,
    "tollFasttag": tollFasttag,
    "transportFee": transportFee,
    "maintenanceCost": maintenanceCost,
  };
}
