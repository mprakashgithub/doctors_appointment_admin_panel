import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/patient.dart';
import '../../services/patient_service.dart';
import '../../widgets/layout/main_layout.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _lastVisitController;
  late TextEditingController _nextAppointmentController;
  late TextEditingController _assignedDoctorController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationshipController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadPatients();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _lastVisitController = TextEditingController();
    _nextAppointmentController = TextEditingController();
    _assignedDoctorController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationshipController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bloodGroupController.dispose();
    _lastVisitController.dispose();
    _nextAppointmentController.dispose();
    _assignedDoctorController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationshipController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    try {
      final patients = await PatientService.loadPatients();
      setState(() {
        _patients = patients;
        _filteredPatients = patients;
        _totalPages = (_filteredPatients.length / _itemsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  void _filterPatients(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPatients = _patients;
      } else {
        _filteredPatients = _patients.where((patient) {
          return patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.id.toLowerCase().contains(query.toLowerCase()) ||
              patient.email.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _totalPages = (_filteredPatients.length / _itemsPerPage).ceil();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<Patient> get _currentPagePatients {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  void _showEditPatientDialog(Patient patient) {
    // Initialize controllers with patient data
    _nameController.text = patient.name;
    _ageController.text = patient.age.toString();
    _emailController.text = patient.email;
    _phoneController.text = patient.phone;
    _addressController.text = patient.address;
    _bloodGroupController.text = patient.bloodGroup;
    _lastVisitController.text = patient.lastVisit;
    _nextAppointmentController.text = patient.nextAppointment;
    _assignedDoctorController.text = patient.assignedDoctor;
    _emergencyNameController.text = patient.emergencyContact.name;
    _emergencyPhoneController.text = patient.emergencyContact.phone;
    _emergencyRelationshipController.text =
        patient.emergencyContact.relationship;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Patient - ${patient.name}'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter age' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter email' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter phone' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter address' : null,
                ),
                TextFormField(
                  controller: _bloodGroupController,
                  decoration: const InputDecoration(labelText: 'Blood Group'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter blood group'
                      : null,
                ),
                TextFormField(
                  controller: _lastVisitController,
                  decoration: const InputDecoration(labelText: 'Last Visit'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter last visit date'
                      : null,
                ),
                TextFormField(
                  controller: _nextAppointmentController,
                  decoration:
                      const InputDecoration(labelText: 'Next Appointment'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter next appointment'
                      : null,
                ),
                TextFormField(
                  controller: _assignedDoctorController,
                  decoration:
                      const InputDecoration(labelText: 'Assigned Doctor'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter assigned doctor'
                      : null,
                ),
                const Divider(),
                const Text('Emergency Contact',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _emergencyNameController,
                  decoration: const InputDecoration(
                      labelText: 'Emergency Contact Name'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter emergency contact name'
                      : null,
                ),
                TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(
                      labelText: 'Emergency Contact Phone'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter emergency contact phone'
                      : null,
                ),
                TextFormField(
                  controller: _emergencyRelationshipController,
                  decoration: const InputDecoration(
                      labelText: 'Emergency Contact Relationship'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter emergency contact relationship'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Update patient data
                final updatedPatient = Patient(
                  id: patient.id,
                  name: _nameController.text,
                  age: int.parse(_ageController.text),
                  gender: patient.gender, // Keep existing gender
                  email: _emailController.text,
                  phone: _phoneController.text,
                  address: _addressController.text,
                  bloodGroup: _bloodGroupController.text,
                  medicalHistory:
                      patient.medicalHistory, // Keep existing medical history
                  allergies: patient.allergies, // Keep existing allergies
                  lastVisit: _lastVisitController.text,
                  nextAppointment: _nextAppointmentController.text,
                  assignedDoctor: _assignedDoctorController.text,
                  emergencyContact: EmergencyContact(
                    name: _emergencyNameController.text,
                    relationship: _emergencyRelationshipController.text,
                    phone: _emergencyPhoneController.text,
                  ),
                );

                // Update the patient in the list
                setState(() {
                  final index = _patients.indexWhere((p) => p.id == patient.id);
                  if (index != -1) {
                    _patients[index] = updatedPatient;
                    _filterPatients(_searchQuery); // Refresh filtered list
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Patient updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _patients.removeWhere((p) => p.id == patient.id);
                _filterPatients(_searchQuery); // Refresh filtered list
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Patient deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Patients',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Search and Add Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _filterPatients,
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement add patient functionality
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Patient'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Patients Table
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Age')),
                            DataColumn(label: Text('Gender')),
                            DataColumn(label: Text('Blood Group')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Last Visit')),
                            DataColumn(label: Text('Next Appointment')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _currentPagePatients.map((patient) {
                            return DataRow(
                              cells: [
                                DataCell(Text(patient.id)),
                                DataCell(Text(patient.name)),
                                DataCell(Text(patient.age.toString())),
                                DataCell(Text(patient.gender)),
                                DataCell(Text(patient.bloodGroup)),
                                DataCell(Text(patient.phone)),
                                DataCell(Text(patient.email)),
                                DataCell(Text(patient.lastVisit)),
                                DataCell(Text(patient.nextAppointment)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility),
                                        onPressed: () {
                                          _showPatientDetails(patient);
                                        },
                                        tooltip: 'View Details',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditPatientDialog(patient);
                                        },
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmation(patient);
                                        },
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  // Pagination Controls
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: _currentPage > 1
                              ? () => setState(() => _currentPage = 1)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _currentPage > 1
                              ? () => setState(() => _currentPage--)
                              : null,
                        ),
                        Text(
                          'Page $_currentPage of $_totalPages',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _currentPage < _totalPages
                              ? () => setState(() => _currentPage++)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: _currentPage < _totalPages
                              ? () => setState(() => _currentPage = _totalPages)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Patient Details - ${patient.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', patient.id),
              _buildDetailRow('Name', patient.name),
              _buildDetailRow('Age', patient.age.toString()),
              _buildDetailRow('Gender', patient.gender),
              _buildDetailRow('Blood Group', patient.bloodGroup),
              _buildDetailRow('Email', patient.email),
              _buildDetailRow('Phone', patient.phone),
              _buildDetailRow('Address', patient.address),
              const Divider(),
              const Text('Medical History',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...patient.medicalHistory.map((condition) => Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Condition: ${condition.condition}'),
                        Text('Diagnosed: ${condition.diagnosedDate}'),
                        Text('Status: ${condition.status}'),
                      ],
                    ),
                  )),
              const Divider(),
              const Text('Allergies',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(patient.allergies.join(', ')),
              ),
              const Divider(),
              _buildDetailRow('Last Visit', patient.lastVisit),
              _buildDetailRow('Next Appointment', patient.nextAppointment),
              _buildDetailRow('Assigned Doctor', patient.assignedDoctor),
              const Divider(),
              const Text('Emergency Contact',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${patient.emergencyContact.name}'),
                    Text(
                        'Relationship: ${patient.emergencyContact.relationship}'),
                    Text('Phone: ${patient.emergencyContact.phone}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
