import 'package:get/get.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/doctors/doctors_screen.dart';
import '../screens/patients/patients_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/settings/settings_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.dashboard, page: () => const DashboardScreen()),
    GetPage(name: Routes.doctors, page: () => const DoctorsScreen()),
    GetPage(name: Routes.patients, page: () => const PatientsScreen()),
    GetPage(name: Routes.appointments, page: () => const AppointmentsScreen()),
    GetPage(name: Routes.settings, page: () => const SettingsScreen()),
  ];
}
