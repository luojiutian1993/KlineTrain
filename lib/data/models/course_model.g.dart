// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      duration: (json['duration'] as num).toInt(),
      lessonsCount: (json['lessonsCount'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      studentsCount: (json['studentsCount'] as num).toInt(),
      category: json['category'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'duration': instance.duration,
      'lessonsCount': instance.lessonsCount,
      'rating': instance.rating,
      'studentsCount': instance.studentsCount,
      'category': instance.category,
      'lessons': instance.lessons,
    };

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: (json['duration'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      videoUrl: json['videoUrl'] as String,
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'order': instance.order,
      'videoUrl': instance.videoUrl,
      'isCompleted': instance.isCompleted,
    };

CourseResponse _$CourseResponseFromJson(Map<String, dynamic> json) =>
    CourseResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseResponseToJson(CourseResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
