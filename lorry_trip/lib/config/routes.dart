import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lorry_trip/controller/home_bindings.dart';
import 'package:lorry_trip/view/create_trip.dart';
import 'package:lorry_trip/view/home_view.dart';
import 'package:lorry_trip/view/trip_completed.dart';
import 'package:lorry_trip/view/trip_details.dart';
import 'package:lorry_trip/view/trip_expences.dart';

abstract class Routes {
  static const home = '/';
  static const details = '/details';
  static const tripExpense = '/trip-expense';
  static const tripComplete = '/trip-complete';
  static const createTrip = '/create-trip';

  static final pages = <GetPage>[
    GetPage(name: home, page: () => const HomeView(), binding: HomeBindings()),
    GetPage(name: details, page: () => const TripDetailView()),
    GetPage(name: tripExpense, page: () => const TripExpenseView()),
    GetPage(name: tripComplete, page: () => const TripCompleteView()),
    GetPage(name: createTrip, page: () => const CreateTripView()),
  ];
}
