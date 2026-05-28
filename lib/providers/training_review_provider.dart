import 'package:riverpod/riverpod.dart';
import '../data/repositories/training_review_repository.dart';
import '../data/models/training_review_data.dart';

final trainingReviewProvider =
    FutureProvider.family<TrainingReviewData?, int>((ref, sessionId) async {
  try {
    return await TrainingReviewRepository.instance.getReviewData(sessionId);
  } catch (e) {
    return null;
  }
});
