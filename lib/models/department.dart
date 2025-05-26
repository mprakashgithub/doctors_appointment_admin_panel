class Department {
  final String id;
  final String name;
  final String description;
  final String head;
  final int totalDoctors;
  final int totalPatients;
  final String location;
  final String contact;
  final List<String> services;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.head,
    required this.totalDoctors,
    required this.totalPatients,
    required this.location,
    required this.contact,
    required this.services,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      head: json['head'],
      totalDoctors: json['totalDoctors'],
      totalPatients: json['totalPatients'],
      location: json['location'],
      contact: json['contact'],
      services: List<String>.from(json['services']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'head': head,
      'totalDoctors': totalDoctors,
      'totalPatients': totalPatients,
      'location': location,
      'contact': contact,
      'services': services,
    };
  }
}
