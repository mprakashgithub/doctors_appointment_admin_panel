class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String email;
  final String phone;
  final String department;
  final int experience;
  final String qualification;
  final Map<String, String> availability;
  final int patientsCount;
  final double rating;
  final String image;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
    required this.phone,
    required this.department,
    required this.experience,
    required this.qualification,
    required this.availability,
    required this.patientsCount,
    required this.rating,
    required this.image,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      email: json['email'],
      phone: json['phone'],
      department: json['department'],
      experience: json['experience'],
      qualification: json['qualification'],
      availability: Map<String, String>.from(json['availability']),
      patientsCount: json['patientsCount'],
      rating: json['rating'].toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'email': email,
      'phone': phone,
      'department': department,
      'experience': experience,
      'qualification': qualification,
      'availability': availability,
      'patientsCount': patientsCount,
      'rating': rating,
      'image': image,
    };
  }
}
