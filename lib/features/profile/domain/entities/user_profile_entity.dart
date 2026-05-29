class UserProfileEntity {
  final String name;
  final String? avatar;
  final String? background;
  final String? grade;
  final String? birthDate;
  final String? address;

  UserProfileEntity({
    required this.name,
    this.avatar,
    this.background,
    this.grade,
    this.birthDate,
    this.address,
  });
}
