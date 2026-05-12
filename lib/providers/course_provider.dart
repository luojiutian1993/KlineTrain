import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/models/course_model.dart';

part 'course_provider.g.dart';

@riverpod
class Courses extends _$Courses {
  @override
  Future<List<CourseModel>> build() async {
    return _generateMockCourses();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_generateMockCourses);
  }
}

Future<List<CourseModel>> _generateMockCourses() async {
  await Future.delayed(const Duration(seconds: 1));

  return [
    CourseModel(
      id: '1',
      title: 'K线基础入门',
      description: '从零开始学习K线基础知识，理解K线的构成和意义',
      coverUrl: 'https://picsum.photos/seed/kline1/300/200',
      duration: 180,
      lessonsCount: 8,
      rating: 4.8,
      studentsCount: 1256,
      category: '基础入门',
      lessons: [
        LessonModel(
          id: '1-1',
          title: '什么是K线',
          duration: 15,
          order: 1,
          videoUrl: '',
          isCompleted: true,
        ),
        LessonModel(
          id: '1-2',
          title: 'K线的组成部分',
          duration: 20,
          order: 2,
          videoUrl: '',
          isCompleted: true,
        ),
      ],
    ),
    CourseModel(
      id: '2',
      title: '技术指标详解',
      description: '深入学习常用技术指标，掌握MACD、RSI等指标的使用方法',
      coverUrl: 'https://picsum.photos/seed/kline2/300/200',
      duration: 240,
      lessonsCount: 12,
      rating: 4.7,
      studentsCount: 892,
      category: '进阶学习',
      lessons: [],
    ),
    CourseModel(
      id: '3',
      title: '实战交易策略',
      description: '学习实战交易策略，掌握买卖时机的判断方法',
      coverUrl: 'https://picsum.photos/seed/kline3/300/200',
      duration: 300,
      lessonsCount: 15,
      rating: 4.9,
      studentsCount: 678,
      category: '实战技巧',
      lessons: [],
    ),
  ];
}
