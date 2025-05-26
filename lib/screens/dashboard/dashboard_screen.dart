import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../widgets/layout/main_layout.dart';
import '../../services/dashboard_service.dart';
import '../../widgets/dashboard/stat_card.dart';
import '../../widgets/dashboard/recent_appointments.dart';
import '../../widgets/dashboard/recent_patients.dart';
import '../../widgets/dashboard/department_stats.dart';
import '../../widgets/dashboard/appointment_status_stats.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  final _dashboardService = DashboardService();
  Map<String, dynamic> _dashboardData = {};

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await _dashboardService.loadDashboardData();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isMobile = !ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return MainLayout(
      title: 'Dashboard',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile
              ? 12
              : isTablet
                  ? 16
                  : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                  height: isMobile
                      ? 12
                      : isTablet
                          ? 16
                          : 24),
              if (isMobile || isTablet)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatCard(
                      title: 'Total Patients',
                      value: _dashboardData['totalPatients'].toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    StatCard(
                      title: 'Total Doctors',
                      value: _dashboardData['totalDoctors'].toString(),
                      icon: Icons.medical_services,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: 'Total Appointments',
                      value: _dashboardData['totalAppointments'].toString(),
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: 'Total Departments',
                      value: _dashboardData['totalDepartments'].toString(),
                      icon: Icons.business,
                      color: Colors.purple,
                    ),
                  ],
                )
              else
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 16 / 11,
                  children: [
                    StatCard(
                      title: 'Total Patients',
                      value: _dashboardData['totalPatients'].toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    StatCard(
                      title: 'Total Doctors',
                      value: _dashboardData['totalDoctors'].toString(),
                      icon: Icons.medical_services,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: 'Total Appointments',
                      value: _dashboardData['totalAppointments'].toString(),
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: 'Total Departments',
                      value: _dashboardData['totalDepartments'].toString(),
                      icon: Icons.business,
                      color: Colors.purple,
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: RecentAppointments(
                        appointments: _dashboardData['recentAppointments'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RecentPatients(
                        patients: _dashboardData['recentPatients'],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    RecentAppointments(
                      appointments: _dashboardData['recentAppointments'],
                    ),
                    const SizedBox(height: 16),
                    RecentPatients(
                      patients: _dashboardData['recentPatients'],
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DepartmentStats(
                        departments: _dashboardData['departments'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppointmentStatusStats(
                        statusCounts: _dashboardData['appointmentStatusStats'],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    DepartmentStats(
                      departments: _dashboardData['departments'],
                    ),
                    const SizedBox(height: 16),
                    AppointmentStatusStats(
                      statusCounts: _dashboardData['appointmentStatusStats'],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
