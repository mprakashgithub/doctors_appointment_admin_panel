import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/patient.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/department.dart';

class DashboardService {
  Future<Map<String, dynamic>> loadDashboardData() async {
    try {
      // Load patients data
      final String patientsResponse =
          await rootBundle.loadString('assets/data/patients.json');
      final patientsData = await json.decode(patientsResponse);
      final patients = (patientsData['patients'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();

      // Load doctors data
      final String doctorsResponse =
          await rootBundle.loadString('assets/data/doctors.json');
      final doctorsData = await json.decode(doctorsResponse);
      final doctors = (doctorsData['doctors'] as List)
          .map((json) => Doctor.fromJson(json))
          .toList();

      // Load appointments data
      final String appointmentsResponse =
          await rootBundle.loadString('assets/data/appointments.json');
      final appointmentsData = await json.decode(appointmentsResponse);
      final appointments = (appointmentsData['appointments'] as List)
          .map((json) => Appointment.fromJson(json))
          .toList();

      // Load departments data
      final String departmentsResponse =
          await rootBundle.loadString('assets/data/departments.json');
      final departmentsData = await json.decode(departmentsResponse);
      final departments = (departmentsData['departments'] as List)
          .map((json) => Department.fromJson(json))
          .toList();

      // Calculate statistics
      Map<String, int> departmentStats = {};
      Map<String, int> appointmentStatusStats = {};

      for (var department in departments) {
        departmentStats[department.name] = department.totalPatients;
      }

      for (var appointment in appointments) {
        appointmentStatusStats[appointment.status] =
            (appointmentStatusStats[appointment.status] ?? 0) + 1;
      }

      // Sort appointments by date (most recent first)
      appointments.sort((a, b) => b.date.compareTo(a.date));
      // Sort patients by last visit date (most recent first)
      patients.sort((a, b) => b.lastVisit.compareTo(a.lastVisit));

      return {
        'patients': patients,
        'doctors': doctors,
        'appointments': appointments,
        'departments': departments,
        'departmentStats': departmentStats,
        'appointmentStatusStats': appointmentStatusStats,
        'totalPatients': patients.length,
        'totalDoctors': doctors.length,
        'totalAppointments': appointments.length,
        'totalDepartments': departments.length,
        'recentAppointments': appointments.take(5).toList(),
        'recentPatients': patients.take(5).toList(),
      };
    } catch (e) {
      throw Exception('Error loading dashboard data: $e');
    }
  }
}
