// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final int age;
  final double weight;
  final double height;
  final String condition; // 'PCOD', 'PCOS', 'Suspected', 'None'
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.condition,
    required this.createdAt,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'age': age,
    'weight': weight,
    'height': height,
    'condition': condition,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    age: map['age'] ?? 0,
    weight: (map['weight'] ?? 0).toDouble(),
    height: (map['height'] ?? 0).toDouble(),
    condition: map['condition'] ?? 'None',
    createdAt: DateTime.parse(
      map['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
  );
}

// lib/models/period_model.dart
class PeriodEntry {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int? flowLevel; // 1-5
  final List<String> symptoms;
  final String? notes;

  PeriodEntry({
    required this.id,
    required this.startDate,
    this.endDate,
    this.flowLevel,
    this.symptoms = const [],
    this.notes,
  });

  int? get duration =>
      endDate != null ? endDate!.difference(startDate).inDays + 1 : null;

  Map<String, dynamic> toMap() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'flowLevel': flowLevel,
    'symptoms': symptoms,
    'notes': notes,
  };

  factory PeriodEntry.fromMap(Map<String, dynamic> map) => PeriodEntry(
    id: map['id'] ?? '',
    startDate: DateTime.parse(map['startDate']),
    endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    flowLevel: map['flowLevel'],
    symptoms: List<String>.from(map['symptoms'] ?? []),
    notes: map['notes'],
  );
}

// lib/models/symptom_model.dart
class SymptomEntry {
  final String id;
  final DateTime date;
  final List<String> symptoms;
  final int severity; // 1-5
  final String? notes;

  SymptomEntry({
    required this.id,
    required this.date,
    required this.symptoms,
    required this.severity,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'symptoms': symptoms,
    'severity': severity,
    'notes': notes,
  };

  factory SymptomEntry.fromMap(Map<String, dynamic> map) => SymptomEntry(
    id: map['id'] ?? '',
    date: DateTime.parse(map['date']),
    symptoms: List<String>.from(map['symptoms'] ?? []),
    severity: map['severity'] ?? 1,
    notes: map['notes'],
  );
}

// lib/models/weight_model.dart
class WeightEntry {
  final String id;
  final DateTime date;
  final double weight;
  final String? notes;

  WeightEntry({
    required this.id,
    required this.date,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'weight': weight,
    'notes': notes,
  };

  factory WeightEntry.fromMap(Map<String, dynamic> map) => WeightEntry(
    id: map['id'] ?? '',
    date: DateTime.parse(map['date']),
    weight: (map['weight'] ?? 0).toDouble(),
    notes: map['notes'],
  );
}
