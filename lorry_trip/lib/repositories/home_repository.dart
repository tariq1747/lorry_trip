import 'package:lorry_trip/modules/trip_module.dart';
import 'package:lorry_trip/network_call/api_call.dart';

class HomeRepository {
  HomeRepository(this._apiService);

  final ApiCall _apiService;
  static const String baseUrl =
      "http://192.168.0.18:8080"; // Replace with your actual base URL
  static const trips = "$baseUrl/api/trips";
  static const tripExpense = "/expenses";
  static const tripComplete = "/complete";

  static String tripDetails(num id) => "$trips/$id";

  // UPDATED: Now accepts pagination and filter parameters
  Future<Map<String, dynamic>> getTrips({
    required int page,
    required int size,
    String? driverName,
    String? vehicleNumber,
    String? tripDate,
  }) async {
    try {
      // 1. Build Query Parameters safely
      Map<String, String> queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (driverName != null && driverName.isNotEmpty) {
        queryParams['driverName'] = driverName;
      }
      if (vehicleNumber != null && vehicleNumber.isNotEmpty) {
        queryParams['vehicleNumber'] = vehicleNumber;
      }
      if (tripDate != null && tripDate.isNotEmpty) {
        queryParams['date'] = tripDate;
      }

      // Create query string: ?page=0&size=10&sortBy=tripId...
      final queryString = Uri(queryParameters: queryParams).query;

      // 2. Execute API Call
      final response = await _apiService.get('$trips?$queryString');

      // 3. Parse Spring Boot Pageable Response
      // Note: Assumes response.data is already decoded to Map<String, dynamic> by your ApiCall wrapper
      List<Trip> fetchedTrips = (response.data['content'] as List)
          .map((e) => Trip.fromJson(e))
          .toList();

      bool isLastPage = response.data['last'] ?? true;

      return {'trips': fetchedTrips, 'isLastPage': isLastPage};
    } catch (e) {
      return {'trips': <Trip>[], 'isLastPage': true};
    }
  }

  Future<Trip?> getTripDetails(num id) async {
    try {
      final response = await _apiService.get(tripDetails(id));
      return Trip.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Trip?> createTrip(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(trips, data: body);
      return Trip.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addTripExpense(Map<String, dynamic> body, num tripId) async {
    try {
      final response = await _apiService.post(
        "${tripDetails(tripId)}$tripExpense",
        data: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> completeTrip(Map<String, dynamic> body, num tripId) async {
    try {
      final response = await _apiService.post(
        "${tripDetails(tripId)}$tripComplete",
        data: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
