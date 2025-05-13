import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/battle_screen.dart'; // adjust path if needed

class CharacterSelectScreen extends StatelessWidget {
  final List<String> characters = ['Warrior', 'Mage', 'Assassin', 'Tank'];

  // Removed `const` here as it contains dynamic content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1A1A),
      appBar: AppBar(
        title: const Text('Select Your Character'),
        backgroundColor: const Color(0xFFB35D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: characters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final character = characters[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BattleScreen(character: character),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    character,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
