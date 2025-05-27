import 'package:get/get.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/doctors/doctors_screen.dart';
import '../screens/patients/patients_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/responsiveScreen/test_responsive_screen.dart';
import '../screens/settings/settings_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
        transition: Transition.circularReveal,
        name: Routes.login,
        page: () => const LoginScreen()),
    GetPage(
      transition: Transition.circularReveal,
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
        transition: Transition.noTransition,
        name: Routes.doctors,
        page: () => const DoctorsScreen()),
    GetPage(
        transition: Transition.noTransition,
        name: Routes.patients,
        page: () => const PatientsScreen()),
    GetPage(
        transition: Transition.noTransition,
        name: Routes.appointments,
        page: () => const AppointmentsScreen()),
    GetPage(
        transition: Transition.noTransition,
        name: Routes.responsive,
        page: () => TestResponsiveScreen()),
    GetPage(
        transition: Transition.noTransition,
        name: Routes.settings,
        page: () => const SettingsScreen()),
  ];
}
