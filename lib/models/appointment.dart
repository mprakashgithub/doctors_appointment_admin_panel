class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String date;
  final String time;
  final String type;
  final String status;
  final String notes;
  final int duration;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.notes,
    required this.duration,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      date: json['date'],
      time: json['time'],
      type: json['type'],
      status: json['status'],
      notes: json['notes'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'type': type,
      'status': status,
      'notes': notes,
      'duration': duration,
    };
  }
}
