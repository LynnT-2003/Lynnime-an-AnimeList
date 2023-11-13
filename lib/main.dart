import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lynnime_application_2/services/firestore_service.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

final FirestoreService _firestoreService = FirestoreService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _firestoreService.getData();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimeListScreen(),
    );
  }
}

class Anime {
  final String title;
  final String imageUrl;
  final String description;
  final double score;
  final int ranked;
  final int popularity;
  final String streamUrl;

  Anime({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.score,
    required this.ranked,
    required this.popularity,
    required this.streamUrl,
  });
}

class AnimeListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AnimeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lynnime an AnimeList'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      // Add the drawer to the Scaffold
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 100, // Set your desired height
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          'Whats on your Lynnime?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ))),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Add logic for handling Profile
                Scaffold.of(context).openEndDrawer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Profile'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('WatchList'),
              onTap: () {
                // Add logic for handling WatchList
                // Scaffold.of(context).openEndDrawer();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Opening WatchList'),
                //   ),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WatchListScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Add logic for handling Settings
                // Scaffold.of(context).openEndDrawer();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Opening Settings'),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _firestoreService.getData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No data available");
          }

          List<Map<String, dynamic>> animeDataList = snapshot.data!;
          List<Anime> animeList = animeDataList
              .map((data) => Anime(
                    title: data['title'],
                    imageUrl: data['imageUrl'],
                    description: data['description'],
                    score: data['score'] ??
                        0.0, // Add null check and default value if needed
                    ranked: data['ranked'] ??
                        0, // Add null check and default value if needed
                    popularity: data['popularity'] ??
                        0, // Add null check and default value if needed
                    streamUrl:
                        data['streamUrl'] ?? 0, // Add null check if needed
                  ))
              .toList();

          return AnimeList(animeList: animeList);
        },
      ),
    );
  }
}

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchList'),
      ),
      body: AnimeList(animeList: watchList),
    );
  }
}

class AnimeList extends StatelessWidget {
  final List<Anime> animeList;

  const AnimeList({Key? key, required this.animeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Adjust the padding as needed
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          return AnimeCard(anime: animeList[index]);
        },
      ),
    );
  }
}

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeDetailScreen(anime: anime),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              anime.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                anime.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Anime> watchList = [];
bool isInWatchList(Anime anime) {
  return watchList.contains(anime);
}

class AnimeDetailScreen extends StatelessWidget {
  final Anime anime;

  const AnimeDetailScreen({Key? key, required this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                anime.title,
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Image.network(
                anime.imageUrl,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 50.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MetricCard(title: 'Score', value: anime.score.toString()),
                  MetricCard(title: 'Ranking', value: anime.ranked.toString()),
                  MetricCard(
                      title: 'Liking', value: anime.popularity.toString()),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  anime.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32.0),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    if (isInWatchList(anime)) {
                      // Remove from watchlist
                      watchList.remove(anime);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anime removed from WatchList'),
                        ),
                      );
                    } else {
                      // Add to watchlist
                      watchList.add(anime);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anime added to WatchList'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    isInWatchList(anime)
                        ? 'Remove from WatchList'
                        : 'Add to WatchList !',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const MetricCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                title.toLowerCase() == "score" ? value : '#$value',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
