enum UserRole {ADMIN , STUDENT} 

extension UserRoleExtension on UserRole {
  String get code {
    switch(this){
      case UserRole.ADMIN :{
        return "ADMIN"; 
      }
      case UserRole.STUDENT :{
        return "STUDENT";
      }
    }
  }
}