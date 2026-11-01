import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorry_trip/config/enums.dart';
import 'package:lorry_trip/config/routes.dart';
import 'package:lorry_trip/config/utils.dart';
import 'package:lorry_trip/modules/trip_module.dart';
import 'package:lorry_trip/repositories/home_repository.dart';

class HomeController extends GetxController {
  HomeController(this._repository);

  final HomeRepository _repository;

  // --- Pagination & Data State ---
  final trips = <Trip>[].obs;
  final RxBool hasMore = true.obs;

  // Spring Boot pagination starts at page 0
  int _currentPage = 0;
  final int _pageSize = 10;

  // Filter states (Update these from your UI to trigger filtering)
  final RxString driverFilter = ''.obs;
  final RxString vehicleFilter = ''.obs;

  // Scroll Controller for pagination
  final ScrollController scrollController = ScrollController();

  final RxString tripDate = ''.obs; // NEW

  /// -------------------- Create Trip --------------------

  final formKey = GlobalKey<FormState>();
  final autoValidate = false.obs;
  final startLocation = TextEditingController();
  final endLocation = TextEditingController();
  final transportName = TextEditingController();
  final totalCost = TextEditingController();
  final punchCost = TextEditingController();
  final driverName = TextEditingController();
  final vehicleNumber = TextEditingController();
  final date = TextEditingController();
  final load = TextEditingController();

  /// -------------------- Trip Expense --------------------

  final expenseFormKey = GlobalKey<FormState>();
  final autoValidateExpense = false.obs;
  final dieselCost = TextEditingController();
  final dieselLiter = TextEditingController();
  final expenseDate = TextEditingController();
  final otherExpenses = TextEditingController();
  final driverFee = TextEditingController();
  final tollFasttag = TextEditingController();
  final transportFee = TextEditingController();
  final maintenanceCost = TextEditingController();

  /// -------------------- Trip Complete --------------------

  final completeTripFormKey = GlobalKey<FormState>();
  final autoValidateComplete = false.obs;
  final completeLocation = TextEditingController();
  final completionDate = TextEditingController();
  final unloadingCharge = TextEditingController();

  final punchCostReceived = false.obs;

  /// Returned after Create Trip API
  num? tripId;
  Trip? tripDetails;

  /// -------------------- Common --------------------

  final isLoading = false.obs;
  final isFetchingNextPage =
      false.obs; // Prevents full screen reload on pagination

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data (Page 0)
    getTrips(isRefresh: true);

    // Pagination Scroll Listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // Trigger lazy load
        getTrips();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // UPDATED getTrips for Pagination & Filtering
  Future<void> getTrips({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 0;
      hasMore.value = true;
    }

    // Stop if we are already loading or if there is no more data to fetch
    if (!hasMore.value || isLoading.value || isFetchingNextPage.value) return;

    if (isRefresh) {
      isLoading.value = true; // Shows main spinner
    } else {
      isFetchingNextPage.value = true; // Shows bottom spinner
    }

    try {
      final result = await _repository.getTrips(
        page: _currentPage,
        size: _pageSize,
        driverName: driverFilter.value,
        vehicleNumber: vehicleFilter.value,
        tripDate: tripDate.value.isNotEmpty ? tripDate.value : null,
      );

      final List<Trip> fetchedTrips = result['trips'];
      final bool isLastPage = result['isLastPage'];

      if (isRefresh) {
        trips.value = fetchedTrips; // Replace list on refresh
      } else {
        trips.addAll(fetchedTrips); // Append to list on lazy load
      }

      // Update pagination states
      _currentPage++;
      hasMore.value = !isLastPage;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch trips. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
      );
    } finally {
      isLoading.value = false;
      isFetchingNextPage.value = false;
    }
  }

  // Update your apply filters method
  void applyFilters({
    String? driver,
    String? vehicle,
    String? date,
    bool clearAll = false,
  }) {
    if (clearAll) {
      driverFilter.value = '';
      vehicleFilter.value = '';
      tripDate.value = '';
    } else {
      if (driver != null) driverFilter.value = driver;
      if (vehicle != null) vehicleFilter.value = vehicle;
      if (date != null) tripDate.value = date;
    }

    getTrips(isRefresh: true); // Triggers API call from page 0 with new filters
  }

  Future<void> getTripDetails() async {
    isLoading.value = true;
    try {
      tripDetails = await _repository.getTripDetails(tripId ?? 0);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch trip details. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Action for Floating Action Button
  void onTapCreateTrip() {
    clearAllForms();
    Get.toNamed(Routes.createTrip);
  }

  // Action when a TripCard is clicked
  void openTrip(Trip trip) {
    clearAllForms();
    tripId = trip.tripId;
    switch (trip.status) {
      case TripStatus.pending:
        Get.toNamed(Routes.tripExpense);
        break;
      case TripStatus.inProgress:
        Get.toNamed(Routes.tripComplete);
        break;
      case TripStatus.completed:
        getTripDetails();
        Get.toNamed(Routes.details);
        break;
    }
  }

  /// -------------------- Create Trip --------------------
  Future<void> saveTrip() async {
    autoValidate.value = true;
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final body = {
        "startLocation": startLocation.text.trim(),
        "endLocation": endLocation.text.trim(),
        "transportName": transportName.text.trim(),
        "totalCost": double.parse(totalCost.text),
        "punchCost": double.parse(punchCost.text),
        "driverName": driverName.text.trim(),
        "vehicleNumber": vehicleNumber.text.trim(),
        "tripDate": date.text,
        "load": load.text.trim(),
      };

      final response = await _repository.createTrip(body);

      tripId = response?.tripId;
      if (tripId == null) {
        AppUtils.showSnackBar(
          title: "Error",
          message: "Failed to create trip. Please try again.",
        );
        return;
      }

      // Refresh the trips list in the background so the new trip appears when we go back

      Get.offNamedUntil(
        Routes.tripExpense,
        (route) => route.settings.name == Routes.home,
      );
    } finally {
      isLoading.value = false;
      await getTrips(
        isRefresh: true,
      ); // Refresh trips list after creating a new trip
    }
  }

  /// -------------------- Save Expense --------------------
  Future<void> saveExpense() async {
    autoValidateExpense.value = true;
    if (!expenseFormKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final body = {
        "tripId": tripId,
        "dieselCost": double.parse(dieselCost.text),
        "dieselLiter": double.parse(dieselLiter.text),
        "expenseDate": expenseDate.text,
        if (otherExpenses.text.isNotEmpty)
          "otherExpenses": double.parse(otherExpenses.text),
        if (driverFee.text.isNotEmpty)
          "driverFee": double.parse(driverFee.text),
        "tollFasttag": double.parse(tollFasttag.text),
        "transportFee": double.parse(transportFee.text),
        if (maintenanceCost.text.isNotEmpty)
          "maintenanceCost": double.parse(maintenanceCost.text),
      };

      bool res = await _repository.addTripExpense(body, tripId ?? 0);

      if (res) {
        Get.offNamedUntil(
          Routes.tripComplete,
          (route) => route.settings.name == Routes.home,
        );
      }
    } finally {
      isLoading.value = false;
      await getTrips(isRefresh: true);
    }
  }

  /// -------------------- Trip Complete --------------------
  Future<void> completeTrip() async {
    autoValidateComplete.value = true;
    if (!completeTripFormKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final body = {
        "tripId": tripId,
        "location": completeLocation.text.trim(),
        "completionDate": completionDate.text,
        if (unloadingCharge.text.isNotEmpty)
          "unloadingCharge": double.parse(unloadingCharge.text),
        "punchCostReceived": punchCostReceived.value,
      };

      bool ref = await _repository.completeTrip(body, tripId ?? 0);

      if (ref) {
        AppUtils.showSnackBar(
          title: "Success",
          message: "Trip completed successfully.",
        );
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(Routes.home);
        });
      }
    } finally {
      isLoading.value = false;
      autoValidateComplete.value = false;
      await getTrips(isRefresh: true);
    }
  }

  // ... (Keep your validators and pickDate/clearAllForms exact same below this)

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is mandatory';
    if (value.trim().length < 2) return 'Must be at least 2 characters long';
    return null;
  }

  String? numericValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Value is required';
    final number = double.tryParse(value);
    if (number == null) return 'Enter a valid decimal number';
    if (number <= 0) return 'Amount must be greater than zero';
    if (value.length > 9) return 'Amount value limit exceeded';
    return null;
  }

  String? vehicleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle plate identification is required';
    }
    final RegExp plateRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}$');
    final sanitized = value.replaceAll(' ', '').toUpperCase();
    if (!plateRegex.hasMatch(sanitized) && sanitized.length < 6) {
      return 'Invalid license number structure format';
    }
    return null;
  }

  void pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toString().split(' ')[0];
    }
  }

  void clearAllForms() {
    startLocation.clear();
    endLocation.clear();
    transportName.clear();
    totalCost.clear();
    punchCost.clear();
    driverName.clear();
    vehicleNumber.clear();
    date.clear();
    load.clear();

    dieselCost.clear();
    dieselLiter.clear();
    expenseDate.clear();
    otherExpenses.clear();
    driverFee.clear();
    tollFasttag.clear();
    transportFee.clear();
    maintenanceCost.clear();

    completeLocation.clear();
    completionDate.clear();
    unloadingCharge.clear();

    punchCostReceived.value = false;
    tripId = null;
    isLoading.value = false;
    autoValidateComplete.value = false;
    autoValidateExpense.value = false;
    autoValidate.value = false;
  }
}
