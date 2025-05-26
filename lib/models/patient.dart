class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String bloodGroup;
  final List<MedicalCondition> medicalHistory;
  final List<String> allergies;
  final String lastVisit;
  final String nextAppointment;
  final String assignedDoctor;
  final EmergencyContact emergencyContact;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.bloodGroup,
    required this.medicalHistory,
    required this.allergies,
    required this.lastVisit,
    required this.nextAppointment,
    required this.assignedDoctor,
    required this.emergencyContact,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      bloodGroup: json['bloodGroup'],
      medicalHistory: (json['medicalHistory'] as List)
          .map((e) => MedicalCondition.fromJson(e))
          .toList(),
      allergies: List<String>.from(json['allergies']),
      lastVisit: json['lastVisit'],
      nextAppointment: json['nextAppointment'],
      assignedDoctor: json['assignedDoctor'],
      emergencyContact: EmergencyContact.fromJson(json['emergencyContact']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'address': address,
      'bloodGroup': bloodGroup,
      'medicalHistory': medicalHistory.map((e) => e.toJson()).toList(),
      'allergies': allergies,
      'lastVisit': lastVisit,
      'nextAppointment': nextAppointment,
      'assignedDoctor': assignedDoctor,
      'emergencyContact': emergencyContact.toJson(),
    };
  }
}

class MedicalCondition {
  final String condition;
  final String diagnosedDate;
  final String status;

  MedicalCondition({
    required this.condition,
    required this.diagnosedDate,
    required this.status,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) {
    return MedicalCondition(
      condition: json['condition'],
      diagnosedDate: json['diagnosedDate'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'diagnosedDate': diagnosedDate,
      'status': status,
    };
  }
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      relationship: json['relationship'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }
}
