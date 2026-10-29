
class Student {
  final String name;
  final String password;
  final String universityId;
  final String phone;
  final String unit;
  final String floor;
  final String room;
  final bool isReserved;
  final String? faceImagePath;

  const Student({
    required this.name,
    required this.password,
    required this.universityId,
    required this.phone,
    required this.unit,
    required this.floor,
    required this.room,
    this.isReserved = false,
    this.faceImagePath,
  });

  Student copyWith({
    String? name,
    String? password,
    String? universityId,
    String? phone,
    String? unit,
    String? floor,
    String? room,
    bool? isReserved,
    String? faceImagePath,
    bool clearFaceImagePath = false,
  }) {
    return Student(
      name: name ?? this.name,
      password: password ?? this.password,
      universityId: universityId ?? this.universityId,
      phone: phone ?? this.phone,
      unit: unit ?? this.unit,
      floor: floor ?? this.floor,
      room: room ?? this.room,
      isReserved: isReserved ?? this.isReserved,
      faceImagePath: clearFaceImagePath
          ? null
          : faceImagePath ?? this.faceImagePath,
    );
  }
}
