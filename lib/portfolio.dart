import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Portfolio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"), // Replace with your image URL
            ),
            const SizedBox(height: 15),
            const Text('Shanjay Athithya',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const Text('Flutter Developer',
                style: TextStyle(fontSize: 18, color: Colors.grey)),

            const SizedBox(height: 30),
            sectionTitle("About Me"),
            const Text(
              'I am a passionate Flutter developer with experience in building beautiful and functional mobile applications. I love turning ideas into apps!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            sectionTitle("Skills"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                SkillChip(label: 'Flutter'),
                SkillChip(label: 'Dart'),
                SkillChip(label: 'Firebase'),
                SkillChip(label: 'REST APIs'),
                SkillChip(label: 'UI/UX Design'),
              ],
            ),

            const SizedBox(height: 30),
            sectionTitle("Projects"),
            ProjectCard(
              title: 'E-commerce App',
              description: 'A shopping app with product cards, cart, and checkout flow.',
            ),
            ProjectCard(
              title: 'Weather App',
              description: 'Get real-time weather info using OpenWeatherMap API.',
            ),
            ProjectCard(
              title: 'Task Manager',
              description: 'Organize your daily tasks with this sleek to-do app.',
            ),

            const SizedBox(height: 30),
            sectionTitle("Contact"),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text('shanjay@example.com'),
            ),
            const ListTile(
              leading: Icon(Icons.link),
              title: Text('github.com/shanjay-athithya'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Tamil Nadu, India'),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blueGrey,
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  const ProjectCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey[850],
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(title),
              content: Text(description),
              actions: [
                TextButton(
                  child: const Text('Close', style: TextStyle(color: Colors.white70)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
