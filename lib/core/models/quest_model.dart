import 'package:hive/hive.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final int xpReward;
  final bool isCompleted;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    this.currentValue = 0,
    required this.xpReward,
    this.isCompleted = false,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? targetValue,
    int? currentValue,
    int? xpReward,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 1;

  @override
  Quest read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final targetValue = reader.readInt();
    final currentValue = reader.readInt();
    final xpReward = reader.readInt();
    final isCompleted = reader.readBool();
    return Quest(
      id: id,
      title: title,
      description: description,
      targetValue: targetValue,
      currentValue: currentValue,
      xpReward: xpReward,
      isCompleted: isCompleted,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeInt(obj.targetValue);
    writer.writeInt(obj.currentValue);
    writer.writeInt(obj.xpReward);
    writer.writeBool(obj.isCompleted);
  }
}
