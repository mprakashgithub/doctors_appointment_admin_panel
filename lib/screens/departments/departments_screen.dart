import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/department.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Department> _departments = [];
  List<Department> _filteredDepartments = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/departments.json');
      final data = await json.decode(response);
      setState(() {
        _departments = (data['departments'] as List)
            .map((json) => Department.fromJson(json))
            .toList();
        _filteredDepartments = List.from(_departments);
        _totalPages = (_filteredDepartments.length / _itemsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading departments: $e')),
        );
      }
    }
  }

  void _filterDepartments(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDepartments = List.from(_departments);
      } else {
        _filteredDepartments = _departments.where((department) {
          return department.name.toLowerCase().contains(query.toLowerCase()) ||
              department.head.toLowerCase().contains(query.toLowerCase()) ||
              department.description
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
      _currentPage = 1;
      _totalPages = (_filteredDepartments.length / _itemsPerPage).ceil();
    });
  }

  List<Department> get _currentPageDepartments {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredDepartments.sublist(
      startIndex,
      endIndex > _filteredDepartments.length
          ? _filteredDepartments.length
          : endIndex,
    );
  }

  void _showDepartmentDetails(Department department) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                department.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildInfoSection('Department Information', [
                _buildInfoRow('Head', department.head),
                _buildInfoRow('Location', department.location),
                _buildInfoRow('Contact', department.contact),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Statistics', [
                _buildInfoRow(
                    'Total Doctors', department.totalDoctors.toString()),
                _buildInfoRow(
                    'Total Patients', department.totalPatients.toString()),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Description', [
                Text(department.description),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Services', [
                ...department.services.map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16),
                        const SizedBox(width: 8),
                        Text(service),
                      ],
                    ),
                  ),
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
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Departments',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: _filterDepartments,
                  decoration: InputDecoration(
                    hintText: 'Search departments...',
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
                  DataColumn(label: Text('Head')),
                  DataColumn(label: Text('Doctors')),
                  DataColumn(label: Text('Patients')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _currentPageDepartments.map((department) {
                  return DataRow(
                    cells: [
                      DataCell(Text(department.name)),
                      DataCell(Text(department.head)),
                      DataCell(Text(department.totalDoctors.toString())),
                      DataCell(Text(department.totalPatients.toString())),
                      DataCell(Text(department.location)),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () =>
                                  _showDepartmentDetails(department),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Implement edit functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Implement delete functionality
                              },
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
    );
  }
}
