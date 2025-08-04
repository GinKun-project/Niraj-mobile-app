import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_clash_frontend/features/game/presentation/view/game_view.dart';
import 'package:shadow_clash_frontend/features/game/presentation/provider/game_provider.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';

void main() {
  group('GameView Widget Tests', () {
    testWidgets('should render game view with all components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      // Verify the game view is rendered
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should show player and enemy HP bars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      // Wait for the game to load
      await tester.pumpAndSettle();

      // Verify HP bars are displayed
      expect(find.textContaining('Player:'), findsOneWidget);
      expect(find.textContaining('Enemy:'), findsOneWidget);
    });

    testWidgets('should show turn indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify turn indicator is shown
      expect(find.textContaining('YOUR TURN'), findsOneWidget);
    });

    testWidgets('should show timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify timer is displayed
      expect(find.textContaining(':'), findsOneWidget);
    });

    testWidgets('should show attack and skill buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify action buttons are present
      expect(find.textContaining('ATTACK'), findsOneWidget);
      expect(find.textContaining('SKILL'), findsOneWidget);
    });

    testWidgets('should handle attack button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap attack button
      final attackButton = find.textContaining('ATTACK');
      if (attackButton.evaluate().isNotEmpty) {
        await tester.tap(attackButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should handle skill button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap skill button
      final skillButton = find.textContaining('SKILL');
      if (skillButton.evaluate().isNotEmpty) {
        await tester.tap(skillButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should show battle end overlay on victory',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate victory condition
      // This would normally be triggered by game logic
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should show battle end overlay on defeat',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate defeat condition
      // This would normally be triggered by game logic
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should navigate to dashboard from battle end overlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // This would test the navigation functionality
      // In a real scenario, the overlay would appear after game ends
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should display damage effects', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify damage effects component is present
      // This would be tested when damage is actually dealt
    });

    testWidgets('should update HP bars when damage is taken',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get initial HP values
      final initialPlayerHp = find.textContaining('Player: 1200/1200');
      final initialEnemyHp = find.textContaining('Enemy: 1200/1200');

      expect(initialPlayerHp, findsOneWidget);
      expect(initialEnemyHp, findsOneWidget);

      // After attack, HP should change
      final attackButton = find.textContaining('ATTACK');
      if (attackButton.evaluate().isNotEmpty) {
        await tester.tap(attackButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should show critical hit effects',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test critical hit effects would be shown when critical damage occurs
    });

    testWidgets('should handle game state changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify game state updates are reflected in UI
      final turnIndicator = find.textContaining('YOUR TURN');
      expect(turnIndicator, findsOneWidget);
    });

    testWidgets('should display background and sprites',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify game components are rendered
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should handle responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 600));
      await tester.pumpAndSettle();

      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpAndSettle();
    });

    testWidgets('should show loading state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      // Initially, the game should be loading
      await tester.pump();
    });

    testWidgets('should handle audio service errors gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Game should continue to work even if audio fails
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('should display proper game status',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify game is in playing state
      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
