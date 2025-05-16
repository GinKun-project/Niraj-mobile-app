import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/battle_screen.dart'; // Ensure the path is correct

class CharacterSelectScreen extends StatelessWidget {
  final List<String> characters = const ['Warrior', 'Mage', 'Assassin', 'Tank'];
  final List<String> characterImages = const [
    'assets/images/warrior.jpg',
    'assets/images/mage.png',
    'assets/images/assassin.jpg',
    'assets/images/tank.png',
  ];

  const CharacterSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Choose Your Character',
          style: TextStyle(
            color: Colors.white,
            fontSize:
                22, // Adjusted the size of the title for better visibility
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image (full screen)
          Positioned.fill(
            child: Image.asset(
              'assets/images/character_selection.webp', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),

          // UI content: Centered content with no scrolling
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // Slight padding to fit content
                vertical:
                    screenHeight *
                    0.1, // Increase vertical padding for better UI alignment
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ), // Increased spacing between title and characters
                  // Character grid with fixed cross axis count for responsive UI
                  Expanded(
                    child: GridView.builder(
                      itemCount: characters.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            screenWidth > 600
                                ? 3
                                : 2, // Adjust number of columns based on screen size
                        childAspectRatio:
                            1.2, // Adjusted aspect ratio for better spacing
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final character = characters[index];
                        final characterImage = characterImages[index];
                        return _CharacterGridItem(
                          character: character,
                          image: characterImage,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BattleScreen(character: character),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterGridItem extends StatelessWidget {
  final String character;
  final String image;
  final VoidCallback onTap;

  const _CharacterGridItem({
    required this.character,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 80, // Adjusted the image size to fit better on the screen
              height: 80, // Adjusted height to fit the screen nicely
            ),
            const SizedBox(height: 10),
            Text(
              character,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Reduced font size for better UI fit
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
