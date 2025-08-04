class DashboardEntity {
  final String playerName;
  final int playerLevel;
  final int playerXp;
  final int playerWins;
  final bool showNotification;

  const DashboardEntity({
    required this.playerName,
    required this.playerLevel,
    required this.playerXp,
    required this.playerWins,
    required this.showNotification,
  });

  DashboardEntity copyWith({
    String? playerName,
    int? playerLevel,
    int? playerXp,
    int? playerWins,
    bool? showNotification,
  }) {
    return DashboardEntity(
      playerName: playerName ?? this.playerName,
      playerLevel: playerLevel ?? this.playerLevel,
      playerXp: playerXp ?? this.playerXp,
      playerWins: playerWins ?? this.playerWins,
      showNotification: showNotification ?? this.showNotification,
    );
  }
}
