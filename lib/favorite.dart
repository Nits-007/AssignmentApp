import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> favoriteTitles = [];
  List<String> favoriteImages = [];
  List<String> favoriteAges = [];
  List<String> favoriteDescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      favoriteTitles = sp.getStringList('favoriteTitles') ?? [];
      favoriteImages = sp.getStringList('favoriteImages') ?? [];
      favoriteAges = sp.getStringList('favoriteAges') ?? [];
      favoriteDescriptions = sp.getStringList('favoriteDescriptions') ?? [];
    });
  }

  Future<void> _removeFromFavorites(int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      favoriteTitles.removeAt(index);
      favoriteImages.removeAt(index);
      favoriteAges.removeAt(index);
      favoriteDescriptions.removeAt(index);

      sp.setStringList('favoriteTitles', favoriteTitles);
      sp.setStringList('favoriteImages', favoriteImages);
      sp.setStringList('favoriteAges', favoriteAges);
      sp.setStringList('favoriteDescriptions', favoriteDescriptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Favorite Anime",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 40, 40, 43),
      ),
      body: favoriteTitles.isEmpty
          ? const Center(child: Text("No favorites added yet."))
          : ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: favoriteTitles.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color.fromARGB(255, 25, 25, 112),
                thickness: 2,
                height: 30,
              ),
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          favoriteImages[index],
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeFromFavorites(index);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          favoriteTitles[index].toUpperCase(),
                          style: GoogleFonts.aladin(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Age Rating: " + favoriteAges[index],
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        favoriteDescriptions[index],
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
