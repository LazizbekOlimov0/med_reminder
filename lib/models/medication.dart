class MedicineModel {
  final String? id;
  final String name;
  final String type;
  final int duration;
  final String quantity;
  final String doseTime;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool isActive;
  final String userId;
  final List<String> medicineDoseTimes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicineModel({
    this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.quantity,
    required this.doseTime,
    required this.startDate,
    this.endDate,
    this.notes,
    required this.isActive,
    required this.userId,
    required this.medicineDoseTimes,
    this.createdAt,
    this.updatedAt,
  });

  // Convert MedicineModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'duration': duration,
      'quantity': quantity,
      'doseTime': doseTime,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
      'userId': userId,
      'medicineDoseTimes': medicineDoseTimes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create MedicineModel from JSON
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? 0,
      quantity: json['quantity'] ?? '',
      doseTime: json['doseTime'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      userId: json['userId'] ?? '',
      medicineDoseTimes: List<String>.from(json['medicineDoseTimes'] ?? []),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Create a copy of MedicineModel with updated fields
  MedicineModel copyWith({
    String? id,
    String? name,
    String? type,
    int? duration,
    String? quantity,
    String? doseTime,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
    String? userId,
    List<String>? medicineDoseTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      quantity: quantity ?? this.quantity,
      doseTime: doseTime ?? this.doseTime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      medicineDoseTimes: medicineDoseTimes ?? this.medicineDoseTimes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MedicineModel(id: $id, name: $name, type: $type, duration: $duration, quantity: $quantity, doseTime: $doseTime, startDate: $startDate, endDate: $endDate, notes: $notes, isActive: $isActive, userId: $userId, medicineDoseTimes: $medicineDoseTimes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicineModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.duration == duration &&
        other.quantity == quantity &&
        other.doseTime == doseTime &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.notes == notes &&
        other.isActive == isActive &&
        other.userId == userId &&
        _listEquals(other.medicineDoseTimes, medicineDoseTimes) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      type,
      duration,
      quantity,
      doseTime,
      startDate,
      endDate,
      notes,
      isActive,
      userId,
      medicineDoseTimes,
      createdAt,
      updatedAt,
    );
  }

  // Helper method to compare lists
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
