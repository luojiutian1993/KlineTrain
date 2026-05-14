// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$NoticeTypeEnumMap, json['type']),
      isRead: json['isRead'] as bool? ?? false,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': _$NoticeTypeEnumMap[instance.type]!,
      'isRead': instance.isRead,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };

const _$NoticeTypeEnumMap = {
  NoticeType.system: 'system',
  NoticeType.activity: 'activity',
  NoticeType.training: 'training',
};
