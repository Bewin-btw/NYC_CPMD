import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A5AE0), Color(0xFF4A4DE9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'About This App',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const Icon(Icons.games, size: 50, color: Color(0xFF6A5AE0)),
                const SizedBox(height: 16),
                const Text(
                  '📱 Truth or Action',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4DE9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Truth or Action is an engaging party game app that helps friends have fun and learn more about each other. '
                  'Players take turns choosing between answering a truth question or completing a challenge. The game is designed '
                  'for casual, fun-filled social settings and can be enjoyed in person by groups of friends, classmates, or colleagues.',
                  style: TextStyle(fontSize: 16, height: 1.6),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                const Text(
                  '👥 Credits',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4DE9),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Developed by Aktaev Erik, Mukanova Alana, Amanbekova Aruzhan, Yermek Daulet\n\n'
                  'In the scope of the course “Crossplatform Development”\n'
                  'at Astana IT University.\n\n'
                  'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
