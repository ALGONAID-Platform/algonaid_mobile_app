enum UserRole {admin , student} 

extension UserRoleExtension on UserRole {
  String get code {
    switch(this){
      case UserRole.admin :{
        return "ADMIN"; 
      }
      case UserRole.student :{
        return "STUDENT";
      }
    }
  }
}