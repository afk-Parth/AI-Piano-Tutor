import 'dart:async';

import 'package:flutter/material.dart';

import 'services/piano_audio_service.dart';
import 'song_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(PianoAudioService.instance.initialize());
  runApp(const PianoTutorApp());
}

class PianoTutorApp extends StatelessWidget {
  const PianoTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Piano Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    SongsScreen(),
    PracticeScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor: const Color(0xFFE7FF57),

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Songs',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.piano),
            label: 'Practice',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String image;

  Song({
    required this.title,
    required this.artist,
    required this.image,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Song> featuredSongs = [
    Song(
      title: "Twinkle Twinkle",
      artist: "Beginner",
      image: "https://picsum.photos/400/300?random=1",
    ),
    Song(
      title: "Happy Birthday",
      artist: "Beginner",
      image: "https://picsum.photos/400/300?random=2",
    ),
    Song(
      title: "Jingle Bells",
      artist: "Beginner",
      image: "https://picsum.photos/400/300?random=3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Discover",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search Songs",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Continue Learning",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Twinkle Twinkle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Progress: 60%",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: 0.6,
                    color: Color(0xFFE7FF57),
                    backgroundColor: Colors.white24,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              "Featured Songs",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 290,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredSongs.length,
                itemBuilder: (context, index) {
                  final song = featuredSongs[index];

                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                          child: Image.network(
                            song.image,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                song.artist,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7FF57),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Start",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongItem {
  final String title;
  final String difficulty;
  final String image;
  final String jsonFile;

  SongItem({
    required this.title,
    required this.difficulty,
    required this.image,
    required this.jsonFile,
  });
}

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  static final List<SongItem> beginnerSongs = [
    SongItem(
      title: "Twinkle Twinkle",
      difficulty: "Beginner",
      image: "assets/images/twinkle.jpg",
      jsonFile: "assets/songs/twinkle.json",
    ),
    SongItem(
      title: "Happy Birthday",
      difficulty: "Beginner",
      image: "assets/images/happy_birthday.jpg",
      jsonFile: "assets/songs/happy_birthday.json",
    ),
    SongItem(
      title: "Jingle Bells",
      difficulty: "Beginner",
      image: "assets/images/jingle_bells.jpg",
      jsonFile: "assets/songs/jingle_bells.json",
    ),
    SongItem(
      title: "Mary Lamb",
      difficulty: "Beginner",
      image: "assets/images/mary_lamb.jpg",
      jsonFile: "assets/songs/mary_lamb.json",
    ),
  ];

  static final List<SongItem> intermediateSongs = [
    SongItem(
      title: "Canon in D",
      difficulty: "Intermediate",
      image: "assets/images/canon_d.jpg",
      jsonFile: "assets/songs/canon_d.json",
    ),
    SongItem(
      title: "Für Elise",
      difficulty: "Intermediate",
      image: "assets/images/fur_elise.jpg",
      jsonFile: "assets/songs/fur_elise.json",
    ),
    SongItem(
      title: "Minuet in G",
      difficulty: "Intermediate",
      image: "assets/images/minute_g.jpg",
      jsonFile: "assets/songs/minute_g.json",
    ),
  ];

  static final List<SongItem> advancedSongs = [
    SongItem(
      title: "River Flows in You",
      difficulty: "Advanced",
      image: "assets/images/river_flows.jpg",
      jsonFile: "assets/songs/river_flows.json",
    ),
    SongItem(
      title: "Perfect",
      difficulty: "Advanced",
      image: "assets/images/perfect.jpg",
      jsonFile: "assets/songs/perfect.json",
    ),
  ];

  Widget buildSection(
      String title,
      List<SongItem> songs,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongDetailsScreen(
                        songFile: song.jsonFile,
                      ),
                    ),
                  );
                },
                child: Container(      
                width: 170,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      child: Image.asset(
                        song.image,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            song.difficulty,
                            style: TextStyle(
                              color:
                              Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration:
                            BoxDecoration(
                              color: const Color(
                                0xFFE7FF57,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(20),
                            ),
                            child: const Text(
                              "Play",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Songs",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            buildSection(
              "Beginner",
              beginnerSongs,
              context,
            ),

            buildSection(
              "Intermediate",
              intermediateSongs,
              context,
            ),

            buildSection(
              "Advanced",
              advancedSongs,
              context,
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Practice",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Progress",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profile",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}