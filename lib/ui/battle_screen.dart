import 'package:flutter/material.dart';

class BattleScreen extends StatefulWidget {
  final String character;

  BattleScreen({required this.character});

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  double playerHealth = 100.0; // Initial health
  double playerEnergy = 50.0; // Initial energy

  // Dummy methods for handling actions
  void takeDamage() {
    setState(() {
      playerHealth -= 10; // Decrease health by 10
      if (playerHealth < 0)
        playerHealth = 0; // Prevent health from going below 0
    });
  }

  void gainEnergy() {
    setState(() {
      playerEnergy += 10; // Increase energy by 10
      if (playerEnergy > 100) playerEnergy = 100; // Cap energy at 100
    });
  }

  void transform() {
    if (playerEnergy >= 100) {
      setState(() {
        playerEnergy = 0; // Reset energy after transformation
      });
      print('${widget.character} has transformed!');
    } else {
      print('Not enough energy to transform!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A1A),
      appBar: AppBar(
        title: Text('${widget.character} Battle'),
        backgroundColor: Color(0xFFB35D32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the character's status
            Text(
              '${widget.character} is ready to battle!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 30),

            // Health Bar
            Container(
              width: 300,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[800],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: playerHealth / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Health: ${playerHealth.toInt()}%',
              style: TextStyle(color: Colors.white),
            ),

            // Energy Bar
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[800],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: playerEnergy / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Energy: ${playerEnergy.toInt()}%',
              style: TextStyle(color: Colors.white),
            ),

            SizedBox(height: 40),

            // Start Battle Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for battle start logic
                takeDamage(); // Example: simulate taking damage when starting the battle
              },
              child: Text('Start Battle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB35D32),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            // Transform button logic
            ElevatedButton(
              onPressed: () {
                transform();
              },
              child: Text('Transform'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Transformation color
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            // Example: Gain energy
            ElevatedButton(
              onPressed: () {
                gainEnergy(); // Increase energy when button is pressed
              },
              child: Text('Gain Energy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Energy button color
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
