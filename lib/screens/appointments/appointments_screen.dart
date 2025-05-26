import 'package:flutter/material.dart';
import '../../widgets/layout/main_layout.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/appointment.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> _appointments = [];
  List<Appointment> _filteredAppointments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;

  // Form controllers for editing
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _doctorIdController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _typeController = TextEditingController();
  final _statusController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _patientNameController.dispose();
    _doctorIdController.dispose();
    _doctorNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/appointments.json');
      final data = await json.decode(response);
      setState(() {
        _appointments = (data['appointments'] as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
        _filteredAppointments = List.from(_appointments);
        _totalPages = (_filteredAppointments.length / _itemsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading appointments: $e')),
        );
      }
    }
  }

  void _filterAppointments(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredAppointments = List.from(_appointments);
      } else {
        _filteredAppointments = _appointments.where((appointment) {
          return appointment.patientName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              appointment.doctorName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              appointment.type.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _currentPage = 1;
      _totalPages = (_filteredAppointments.length / _itemsPerPage).ceil();
    });
  }

  List<Appointment> get _currentPageAppointments {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredAppointments.sublist(
      startIndex,
      endIndex > _filteredAppointments.length
          ? _filteredAppointments.length
          : endIndex,
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
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
                  Text(
                    'Appointment Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection('Patient Information', [
                    _buildInfoRow('Name', appointment.patientName),
                    _buildInfoRow('ID', appointment.patientId),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Doctor Information', [
                    _buildInfoRow('Name', appointment.doctorName),
                    _buildInfoRow('ID', appointment.doctorId),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Appointment Details', [
                    _buildInfoRow('Date', appointment.date),
                    _buildInfoRow('Time', appointment.time),
                    _buildInfoRow('Type', appointment.type),
                    _buildInfoRow('Status', appointment.status),
                    _buildInfoRow(
                        'Duration', '${appointment.duration} minutes'),
                  ]),
                  if (appointment.notes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildInfoSection('Notes', [
                      _buildInfoRow('', appointment.notes),
                    ]),
                  ],
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

  void _showEditDialog(Appointment appointment) {
    // Pre-fill the form with appointment's data
    _patientIdController.text = appointment.patientId;
    _patientNameController.text = appointment.patientName;
    _doctorIdController.text = appointment.doctorId;
    _doctorNameController.text = appointment.doctorName;
    _dateController.text = appointment.date;
    _timeController.text = appointment.time;
    _typeController.text = appointment.type;
    _statusController.text = appointment.status;
    _notesController.text = appointment.notes;
    _durationController.text = appointment.duration.toString();

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
                      'Edit Appointment',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _patientIdController,
                      decoration: const InputDecoration(
                        labelText: 'Patient ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _patientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _doctorIdController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter doctor ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _doctorNameController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter doctor name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter time';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter appointment type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
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
                              // Update appointment data
                              final updatedAppointment = Appointment(
                                id: appointment.id,
                                patientId: _patientIdController.text,
                                patientName: _patientNameController.text,
                                doctorId: _doctorIdController.text,
                                doctorName: _doctorNameController.text,
                                date: _dateController.text,
                                time: _timeController.text,
                                type: _typeController.text,
                                status: _statusController.text,
                                notes: _notesController.text,
                                duration: int.parse(_durationController.text),
                              );

                              // Update the appointment in the list
                              setState(() {
                                final index = _appointments
                                    .indexWhere((a) => a.id == appointment.id);
                                if (index != -1) {
                                  _appointments[index] = updatedAppointment;
                                  _filterAppointments(
                                      _searchQuery); // Refresh filtered list
                                }
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Appointment updated successfully')),
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

  void _showDeleteConfirmation(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: Text(
            'Are you sure you want to delete the appointment for ${appointment.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _appointments.removeWhere((a) => a.id == appointment.id);
                _filterAppointments(_searchQuery); // Refresh filtered list
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Appointment deleted successfully')),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'rescheduled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MainLayout(
      title: 'Appointments',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appointments',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: _filterAppointments,
                    decoration: InputDecoration(
                      hintText: 'Search appointments...',
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
                    DataColumn(label: Text('Patient')),
                    DataColumn(label: Text('Doctor')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _currentPageAppointments.map((appointment) {
                    return DataRow(
                      cells: [
                        DataCell(Text(appointment.patientName)),
                        DataCell(Text(appointment.doctorName)),
                        DataCell(Text(appointment.date)),
                        DataCell(Text(appointment.time)),
                        DataCell(Text(appointment.type)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(appointment.status)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              appointment.status,
                              style: TextStyle(
                                color: _getStatusColor(appointment.status),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () =>
                                    _showAppointmentDetails(appointment),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditDialog(appointment),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _showDeleteConfirmation(appointment),
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
