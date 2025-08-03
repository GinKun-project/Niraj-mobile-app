class PlayerEntity {
  final String name;
  final int maxHp;
  final int currentHp;
  final int attack;
  final int defense;
  final double criticalChance;
  final double dodgeChance;
  final int positionX;
  final int positionY;

  const PlayerEntity({
    required this.name,
    required this.maxHp,
    required this.currentHp,
    required this.attack,
    required this.defense,
    required this.criticalChance,
    required this.dodgeChance,
    this.positionX = 0,
    this.positionY = 0,
  });

  PlayerEntity copyWith({
    String? name,
    int? maxHp,
    int? currentHp,
    int? attack,
    int? defense,
    double? criticalChance,
    double? dodgeChance,
    int? positionX,
    int? positionY,
  }) {
    return PlayerEntity(
      name: name ?? this.name,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      criticalChance: criticalChance ?? this.criticalChance,
      dodgeChance: dodgeChance ?? this.dodgeChance,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
    );
  }

  bool get isAlive => currentHp > 0;
  double get healthPercentage => currentHp / maxHp;
}
