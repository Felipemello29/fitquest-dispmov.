import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/step_tracker_service.dart';

final stepTrackerServiceProvider = Provider<StepTrackerService>((ref) {
  final service = StepTrackerService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final stepCountProvider = StreamProvider<int>((ref) {
  final service = ref.watch(stepTrackerServiceProvider);
  return service.stepCountStream;
});

class HeroesMarchState {
  final int steps;
  final int goal;
  final bool isSimulated;

  const HeroesMarchState({
    required this.steps,
    required this.goal,
    required this.isSimulated,
  });

  int get evolutionPoints => steps ~/ 100;
  double get progress => (steps / goal).clamp(0.0, 1.0);

  HeroesMarchState copyWith({
    int? steps,
    int? goal,
    bool? isSimulated,
  }) {
    return HeroesMarchState(
      steps: steps ?? this.steps,
      goal: goal ?? this.goal,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }
}

class HeroesMarchNotifier extends Notifier<HeroesMarchState> {
  @override
  HeroesMarchState build() {
    final stepStream = ref.watch(stepCountProvider);
    final service = ref.watch(stepTrackerServiceProvider);

    return stepStream.when(
      data: (steps) => HeroesMarchState(
        steps: steps,
        goal: 10000,
        isSimulated: service.isMocked,
      ),
      error: (_, __) => HeroesMarchState(
        steps: 2450,
        goal: 10000,
        isSimulated: true,
      ),
      loading: () => HeroesMarchState(
        steps: 0,
        goal: 10000,
        isSimulated: service.isMocked,
      ),
    );
  }
}

final heroesMarchNotifierProvider =
    NotifierProvider<HeroesMarchNotifier, HeroesMarchState>(
        HeroesMarchNotifier.new);
