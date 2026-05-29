import '../../domain/entities/total_points_entity.dart';

class TotalPointsModel extends TotalPointsEntity {
  const TotalPointsModel({required super.totalPoints});

  factory TotalPointsModel.fromJson(Map<String, dynamic> json) {
    return TotalPointsModel(
      totalPoints: json['totalPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
    };
  }
}
