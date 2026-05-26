import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainTabIndexProvider = StateProvider<int>((ref) => 0);

class MainTabController {
  final void Function(int) setIndex;

  MainTabController({required this.setIndex});
}

final mainTabControllerProvider = Provider<MainTabController?>((ref) => null);

class MainTabNotifier extends StateNotifier<int> {
  MainTabNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final mainTabNotifierProvider = StateNotifierProvider<MainTabNotifier, int>(
  (ref) => MainTabNotifier(),
);
