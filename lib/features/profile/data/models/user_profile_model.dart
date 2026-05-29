import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required super.name,
    super.avatar,
    super.background,
    super.grade,
    super.birthDate,
    super.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      avatar: json['avatar'],
      background: json['background'],
      grade: json['grade'],
      birthDate: json['birthDate'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'background': background,
      'grade': grade,
      'birthDate': birthDate,
      'address': address,
    };
  }

  UserProfileModel copyWith({
    String? name,
    String? avatar,
    String? background,
    String? grade,
    String? birthDate,
    String? address,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      background: background ?? this.background,
      grade: grade ?? this.grade,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
    );
  }
}
