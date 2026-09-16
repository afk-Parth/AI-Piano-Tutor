import 'package:flutter/material.dart';

class SessionSummaryScreen extends StatelessWidget {
  final Map songData;
  final int correctNotes;
  final int wrongNotes;
  final double accuracy;
  final String duration;

  const SessionSummaryScreen({
    super.key,
    required this.songData,
    required this.correctNotes,
    required this.wrongNotes,
    required this.accuracy,
    required this.duration,
  });

  String getStars() {
    if (accuracy >= 95) {
      return "★★★";
    }

    if (accuracy >= 80) {
      return "★★☆";
    }

    return "★☆☆";
  }

  Widget buildStatCard(
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Session Summary",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                songData["image"],
                height: 180,
              ),
              const SizedBox(height: 20),
              Text(
                songData["title"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                getStars(),
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 20),
              buildStatCard(
                "Accuracy",
                "${accuracy.toStringAsFixed(1)}%",
              ),
              buildStatCard(
                "Correct Notes",
                "$correctNotes",
              ),
              buildStatCard(
                "Mistakes",
                "$wrongNotes",
              ),
              buildStatCard(
                "Duration",
                duration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
