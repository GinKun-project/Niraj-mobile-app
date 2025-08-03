import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';

void main() {
  group('PlayerEntity', () {
    test('should create player with correct properties', () {
      const player = PlayerEntity(
        name: 'Test Player',
        maxHp: 1000,
        currentHp: 800,
        attack: 120,
        defense: 80,
        criticalChance: 0.15,
        dodgeChance: 0.10,
      );

      expect(player.name, 'Test Player');
      expect(player.maxHp, 1000);
      expect(player.currentHp, 800);
      expect(player.attack, 120);
      expect(player.defense, 80);
      expect(player.criticalChance, 0.15);
      expect(player.dodgeChance, 0.10);
    });

    test('isAlive should return true when currentHp > 0', () {
      const player = PlayerEntity(
        name: 'Test Player',
        maxHp: 1000,
        currentHp: 100,
        attack: 120,
        defense: 80,
        criticalChance: 0.15,
        dodgeChance: 0.10,
      );

      expect(player.isAlive, isTrue);
    });

    test('isAlive should return false when currentHp <= 0', () {
      const player = PlayerEntity(
        name: 'Test Player',
        maxHp: 1000,
        currentHp: 0,
        attack: 120,
        defense: 80,
        criticalChance: 0.15,
        dodgeChance: 0.10,
      );

      expect(player.isAlive, isFalse);
    });

    test('healthPercentage should return correct percentage', () {
      const player = PlayerEntity(
        name: 'Test Player',
        maxHp: 1000,
        currentHp: 750,
        attack: 120,
        defense: 80,
        criticalChance: 0.15,
        dodgeChance: 0.10,
      );

      expect(player.healthPercentage, 0.75);
    });

    test('copyWith should create new instance with updated values', () {
      const player = PlayerEntity(
        name: 'Test Player',
        maxHp: 1000,
        currentHp: 800,
        attack: 120,
        defense: 80,
        criticalChance: 0.15,
        dodgeChance: 0.10,
      );

      final updatedPlayer = player.copyWith(currentHp: 600, attack: 140);

      expect(updatedPlayer.name, player.name);
      expect(updatedPlayer.maxHp, player.maxHp);
      expect(updatedPlayer.currentHp, 600);
      expect(updatedPlayer.attack, 140);
      expect(updatedPlayer.defense, player.defense);
      expect(updatedPlayer.criticalChance, player.criticalChance);
      expect(updatedPlayer.dodgeChance, player.dodgeChance);
    });
  });
}
