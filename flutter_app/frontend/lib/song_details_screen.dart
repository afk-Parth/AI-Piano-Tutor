import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/practice_screen.dart';

class SongDetailsScreen extends StatefulWidget {
  final String songFile;

  const SongDetailsScreen({
    super.key,
    required this.songFile,
  });

  @override
  State<SongDetailsScreen> createState() =>
      _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  Map<String, dynamic>? songData;

  @override
  void initState() {
    super.initState();
    loadSong();
  }

  Future<void> loadSong() async {
    final jsonString =
        await rootBundle.loadString(widget.songFile);

    setState(() {
      songData = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (songData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(songData!['title']),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Hero(
              tag: 'song-image-${songData!['image']}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  songData!['image'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              songData!['title'],
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            infoRow(
              "Difficulty",
              songData!['difficulty'],
            ),

            infoRow(
              "Duration",
              songData!['duration'],
            ),

            infoRow(
              "Notes",
              "${songData!['noteCount']}",
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PracticeScreen(
                        songData: songData!,
                      ),
                    ),
                  );
                },

                child: const Text(
                  "Start Practice",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}