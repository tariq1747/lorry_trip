import 'package:get/get.dart';
import 'package:lorry_trip/controller/home_controller.dart';
import 'package:lorry_trip/network_call/api_call.dart';
import 'package:lorry_trip/repositories/home_repository.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(HomeRepository(ApiCall())), permanent: true);
  }
}
