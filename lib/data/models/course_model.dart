import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final int duration;
  final int lessonsCount;
  final double rating;
  final int studentsCount;
  final String category;
  final List<LessonModel> lessons;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.duration,
    required this.lessonsCount,
    required this.rating,
    required this.studentsCount,
    required this.category,
    required this.lessons,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}

@JsonSerializable()
class LessonModel {
  final String id;
  final String title;
  final int duration;
  final int order;
  final String videoUrl;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.order,
    required this.videoUrl,
    required this.isCompleted,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonModelToJson(this);
}

@JsonSerializable()
class CourseResponse {
  final int code;
  final String message;
  final List<CourseModel> data;

  CourseResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}
