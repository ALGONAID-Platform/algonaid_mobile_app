// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';

class UserEntity {
  int id;
  String username;
  String email;
  UserRole role;
  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });
}
