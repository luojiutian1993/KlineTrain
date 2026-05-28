import 'package:flutter/foundation.dart';

class TrainingNotifier extends ChangeNotifier {
  static final TrainingNotifier instance = TrainingNotifier._();

  TrainingNotifier._();

  bool _hasPendingUpdate = false;
  int _refreshCount = 0;

  bool get hasPendingUpdate => _hasPendingUpdate;
  int get refreshCount => _refreshCount;

  void notifyTrainingSaved() {
    _hasPendingUpdate = true;
    _refreshCount++;
    notifyListeners();
  }

  void clearPendingUpdate() {
    _hasPendingUpdate = false;
  }
}