import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.g.dart';

enum NoticeType {
  @JsonValue('system')
  system('系统公告'),
  @JsonValue('activity')
  activity('活动'),
  @JsonValue('training')
  training('训练提醒');

  const NoticeType(this.label);
  final String label;
}

@JsonSerializable()
class NoticeModel {
  final String id;
  final String title;
  final String content;
  final NoticeType type;
  final bool isRead;
  final DateTime publishedAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.isRead = false,
    required this.publishedAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);

  NoticeModel copyWith({
    String? id,
    String? title,
    String? content,
    NoticeType? type,
    bool? isRead,
    DateTime? publishedAt,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
