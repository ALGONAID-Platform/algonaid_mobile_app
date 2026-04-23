import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppShadows {
  
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05), 
      blurRadius: 10,                       
      spreadRadius: 0,                      
      offset: const Offset(0, 2),            
    ),
  ];
  
  static final BoxShadow soft = BoxShadow(
    color: AppColors.shadow.withOpacity(0.1),
    offset: const Offset(0, 4),
    blurRadius: 10,
    spreadRadius: 0,
  );

  
  static final BoxShadow medium = BoxShadow(
    color: AppColors.shadow.withOpacity(0.15),
    offset: const Offset(0, 6),
    blurRadius: 20,
    spreadRadius: 0,
  );

  
  static final BoxShadow dialog = BoxShadow(
    color: AppColors.shadow.withOpacity(0.2), 
    offset: const Offset(0, 10),
    blurRadius: 40,
    spreadRadius: -5,
  );

 
  static final BoxShadow primaryGlow = BoxShadow(
    color: AppColors.primary.withOpacity(0.3),
    offset: const Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );

  
  static final BoxShadow reverse = BoxShadow(
    color: AppColors.shadow.withOpacity(0.08),
    offset: const Offset(0, -4),
    blurRadius: 10,
    spreadRadius: 0,
  );
}