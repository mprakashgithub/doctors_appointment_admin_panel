import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../constants/theme.dart';
import '../../routes/app_pages.dart';
import '../../controllers/navigation_controller.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDrawer = !ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      width: isDrawer ? null : 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Logo or App Name
          const Text(
            'Doctors Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          // Navigation Items
          _buildNavItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: Routes.dashboard,
            isDrawer: isDrawer,
          ),
          _buildNavItem(
            icon: Icons.medical_services,
            title: 'Doctors',
            route: Routes.doctors,
            isDrawer: isDrawer,
          ),
          _buildNavItem(
            icon: Icons.people,
            title: 'Patients',
            route: Routes.patients,
            isDrawer: isDrawer,
          ),
          _buildNavItem(
            icon: Icons.calendar_today,
            title: 'Appointments',
            route: Routes.appointments,
            isDrawer: isDrawer,
          ),
          _buildNavItem(
            icon: Icons.settings,
            title: 'Settings',
            route: Routes.settings,
            isDrawer: isDrawer,
          ),
          const Spacer(),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                if (isDrawer) {
                  Navigator.pop(context);
                }
                Get.offAllNamed(Routes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isDrawer,
  }) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        final isActive = controller.currentRoute == route;
        return InkWell(
          onTap: () {
            controller.updateRoute(route);
            if (isDrawer) {
              Navigator.pop(Get.context!);
            }
            Get.toNamed(route);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDrawer ? 16 : 20,
              vertical: 12,
            ),
            color: isActive
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppTheme.primaryColor : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? AppTheme.primaryColor : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
