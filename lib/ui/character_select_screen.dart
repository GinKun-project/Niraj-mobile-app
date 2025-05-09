import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/battle_screen.dart';

class CharacterSelectScreen extends StatelessWidget {
  // You can later replace these with dynamic character data
  final List<String> characters = ['Warrior', 'Mage', 'Assassin', 'Tank'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A1A),
      appBar: AppBar(
        title: Text('Select Your Character'),
        backgroundColor: Color(0xFFB35D32),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.black,
              margin: EdgeInsets.all(15),
              child: ListTile(
                title: Text(
                  characters[index],
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons
                      .sports_esports, // You can later add character images here
                  color: Colors.white,
                ),
                onTap: () {
                  // Navigate to Battle Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              BattleScreen(character: characters[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
