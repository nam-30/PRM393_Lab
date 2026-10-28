class Student {
  final String id;
  final String name;
  final String email;
  final String major;
  final double gpa;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.gpa,
  });

  // Factory constructor to create a Student object from a JSON map
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      gpa: (json['gpa'] is num) ? (json['gpa'] as num).toDouble() : double.tryParse(json['gpa']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  // Convert Student object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
      'gpa': gpa,
    };
  }

  // Create a copy of Student with updated fields
  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? major,
    double? gpa,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
    );
  }
}
