import 'package:hive/hive.dart';

class UserProfile {
  int stepCount;
  int evolutionPoints;
  int level;

  UserProfile({
    this.stepCount = 0,
    this.evolutionPoints = 0,
    this.level = 1,
  });

  UserProfile copyWith({
    int? stepCount,
    int? evolutionPoints,
    int? level,
  }) {
    return UserProfile(
      stepCount: stepCount ?? this.stepCount,
      evolutionPoints: evolutionPoints ?? this.evolutionPoints,
      level: level ?? this.level,
    );
  }
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final stepCount = reader.readInt();
    final evolutionPoints = reader.readInt();
    final level = reader.readInt();
    return UserProfile(
      stepCount: stepCount,
      evolutionPoints: evolutionPoints,
      level: level,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer.writeInt(obj.stepCount);
    writer.writeInt(obj.evolutionPoints);
    writer.writeInt(obj.level);
  }
}
