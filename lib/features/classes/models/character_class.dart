class CharacterClass {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final double xpMultiplierDungeon;
  final double xpMultiplierHeroesMarch;
  final double xpMultiplierGeneral;

  const CharacterClass({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.xpMultiplierDungeon = 1.0,
    this.xpMultiplierHeroesMarch = 1.0,
    this.xpMultiplierGeneral = 1.0,
  });

  static const novice = CharacterClass(
    id: 'novice',
    name: 'Novice',
    description: 'A beginner starting their fitness journey. Balanced stats.',
    iconName: 'person_outline',
  );

  static const warrior = CharacterClass(
    id: 'warrior',
    name: 'Warrior',
    description: 'Masters of strength and gym workouts. Bonus XP for Dungeon check-ins.',
    iconName: 'fitness_center',
    xpMultiplierDungeon: 1.2,
  );

  static const ranger = CharacterClass(
    id: 'ranger',
    name: 'Ranger',
    description: 'Masters of endurance and cardio. Bonus XP for Hero\'s March.',
    iconName: 'directions_run',
    xpMultiplierHeroesMarch: 1.2,
  );
  
  static const mage = CharacterClass(
    id: 'mage',
    name: 'Mage',
    description: 'Masters of flexibility and balance. Bonus general XP.',
    iconName: 'self_improvement',
    xpMultiplierGeneral: 1.1,
  );

  static const values = [novice, warrior, ranger, mage];

  static CharacterClass getById(String id) {
    return values.firstWhere((c) => c.id == id, orElse: () => novice);
  }
}
