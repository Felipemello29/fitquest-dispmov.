import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class DungeonState {
  final bool isLoading;
  final Position? currentLocation;
  final List<GymLocation> nearbyGyms;
  final String? error;
  final GymLocation? checkedInGym;

  DungeonState({
    this.isLoading = false,
    this.currentLocation,
    this.nearbyGyms = const [],
    this.error,
    this.checkedInGym,
  });

  DungeonState copyWith({
    bool? isLoading,
    Position? currentLocation,
    List<GymLocation>? nearbyGyms,
    String? error,
    GymLocation? checkedInGym,
  }) {
    return DungeonState(
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      nearbyGyms: nearbyGyms ?? this.nearbyGyms,
      error: error, // Can be set to null
      checkedInGym: checkedInGym ?? this.checkedInGym,
    );
  }
}

class DungeonNotifier extends Notifier<DungeonState> {
  late final LocationService _locationService;

  @override
  DungeonState build() {
    _locationService = ref.watch(locationServiceProvider);
    // Initialize in background
    Future.microtask(() => _initialize());
    return DungeonState();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final gyms = await _locationService.getNearbyGyms(position);
        state = state.copyWith(
          isLoading: false,
          currentLocation: position,
          nearbyGyms: gyms,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Could not determine location.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _initialize();
  }

  Future<bool> checkIn(GymLocation gym) async {
    if (state.currentLocation == null) return false;

    // Check distance between current location and gym
    final distance = Geolocator.distanceBetween(
      state.currentLocation!.latitude,
      state.currentLocation!.longitude,
      gym.latitude,
      gym.longitude,
    );

    // If within 200 meters (or if mocked, allow check-in)
    if (distance <= 200 || _locationService.isMocked) {
      state = state.copyWith(checkedInGym: gym);
      return true;
    } else {
      state = state.copyWith(error: 'You are too far from this gym to check in.');
      return false;
    }
  }
}

final dungeonNotifierProvider = NotifierProvider<DungeonNotifier, DungeonState>(() {
  return DungeonNotifier();
});
