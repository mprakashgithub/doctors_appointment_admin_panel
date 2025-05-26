import 'package:get/get.dart';

class NavigationController extends GetxController {
  final _currentRoute = ''.obs;

  String get currentRoute => _currentRoute.value;

  void updateRoute(String route) {
    _currentRoute.value = route;
  }
}
