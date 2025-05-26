import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/patient.dart';

class PatientService {
  static Future<List<Patient>> loadPatients() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/patients.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> patientsJson = jsonData['patients'];
      return patientsJson.map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading patients: $e');
      return [];
    }
  }
}
