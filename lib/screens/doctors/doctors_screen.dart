import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/doctor.dart';
import '../../widgets/layout/main_layout.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;

  // Form controllers for editing
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _experienceController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _patientsCountController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _patientsCountController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/doctors.json');
      final data = await json.decode(response);
      setState(() {
        _doctors = (data['doctors'] as List)
            .map((json) => Doctor.fromJson(json))
            .toList();
        _filteredDoctors = List.from(_doctors);
        _totalPages = (_filteredDoctors.length / _itemsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading doctors: $e')),
        );
      }
    }
  }

  void _filterDoctors(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredDoctors = List.from(_doctors);
      } else {
        _filteredDoctors = _doctors.where((doctor) {
          return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
              doctor.specialization
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              doctor.department.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _currentPage = 1;
      _totalPages = (_filteredDoctors.length / _itemsPerPage).ceil();
    });
  }

  List<Doctor> get _currentPageDoctors {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredDoctors.sublist(
      startIndex,
      endIndex > _filteredDoctors.length ? _filteredDoctors.length : endIndex,
    );
  }

  void _showDoctorDetails(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              doctor.specialization,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              doctor.department,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection('Contact Information', [
                    _buildInfoRow('Email', doctor.email),
                    _buildInfoRow('Phone', doctor.phone),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Professional Details', [
                    _buildInfoRow('Experience', '${doctor.experience} years'),
                    _buildInfoRow('Qualification', doctor.qualification),
                    _buildInfoRow('Patients', doctor.patientsCount.toString()),
                    _buildInfoRow('Rating', '${doctor.rating}/5'),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Availability', [
                    ...doctor.availability.entries.map(
                      (entry) => _buildInfoRow(entry.key, entry.value),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(Doctor doctor) {
    // Pre-fill the form with doctor's data
    _nameController.text = doctor.name;
    _specializationController.text = doctor.specialization;
    _emailController.text = doctor.email;
    _phoneController.text = doctor.phone;
    _departmentController.text = doctor.department;
    _experienceController.text = doctor.experience.toString();
    _qualificationController.text = doctor.qualification;
    _patientsCountController.text = doctor.patientsCount.toString();
    _ratingController.text = doctor.rating.toString();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Doctor',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _specializationController,
                      decoration: const InputDecoration(
                        labelText: 'Specialization',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a specialization';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a department';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: 'Experience (years)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter experience';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qualificationController,
                      decoration: const InputDecoration(
                        labelText: 'Qualification',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter qualification';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _patientsCountController,
                      decoration: const InputDecoration(
                        labelText: 'Patients Count',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patients count';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter rating';
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 5) {
                          return 'Please enter a valid rating (0-5)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Update doctor data
                              final updatedDoctor = Doctor(
                                id: doctor.id,
                                name: _nameController.text,
                                specialization: _specializationController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                department: _departmentController.text,
                                experience:
                                    int.parse(_experienceController.text),
                                qualification: _qualificationController.text,
                                availability: doctor
                                    .availability, // Keep existing availability
                                patientsCount:
                                    int.parse(_patientsCountController.text),
                                rating: double.parse(_ratingController.text),
                                image: doctor.image, // Keep existing image
                              );

                              // Update the doctor in the list
                              setState(() {
                                final index = _doctors
                                    .indexWhere((d) => d.id == doctor.id);
                                if (index != -1) {
                                  _doctors[index] = updatedDoctor;
                                  _filterDoctors(
                                      _searchQuery); // Refresh filtered list
                                }
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Doctor updated successfully')),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Doctor'),
        content: Text('Are you sure you want to delete ${doctor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _doctors.removeWhere((d) => d.id == doctor.id);
                _filterDoctors(_searchQuery); // Refresh filtered list
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Doctor deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MainLayout(
      title: 'Doctors',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Doctors',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: _filterDoctors,
                    decoration: InputDecoration(
                      hintText: 'Search doctors...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Specialization')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Experience')),
                    DataColumn(label: Text('Patients')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _currentPageDoctors.map((doctor) {
                    return DataRow(
                      cells: [
                        DataCell(Text(doctor.name)),
                        DataCell(Text(doctor.specialization)),
                        DataCell(Text(doctor.department)),
                        DataCell(Text('${doctor.experience} years')),
                        DataCell(Text(doctor.patientsCount.toString())),
                        DataCell(Text('${doctor.rating}/5')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () => _showDoctorDetails(doctor),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditDialog(doctor),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _showDeleteConfirmation(doctor),
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
            const SizedBox(height: 16),
            Row(
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
                  style: Theme.of(context).textTheme.bodyLarge,
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
          ],
        ),
      ),
    );
  }
}
