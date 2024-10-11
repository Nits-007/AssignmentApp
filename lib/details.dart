import 'package:animeapp/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Details extends StatefulWidget {
  final String titl;
  const Details({super.key, required this.titl});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<List<Anime>> futureAnime;
  Map<String, double> animeRatings = {};

  @override
  void initState() {
    super.initState();
    futureAnime = getAnime(widget.titl);
    _loadSavedRatings();
  }

  _loadSavedRatings() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.getKeys().forEach((key) {
        if (key.startsWith('animeRating_')) {
          animeRatings[key.replaceFirst('animeRating_', '')] =
              sp.getDouble(key) ?? 0.0;
        }
      });
    });
  }

  _saveRating(String animeTitle, double rating) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble('animeRating_$animeTitle', rating);
    setState(() {
      animeRatings[animeTitle] = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: const Text(
            "Anime Lists",
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: Color.fromARGB(255, 40, 40, 43),
        ),
        body: FutureBuilder<List<Anime>>(
            future: futureAnime,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.separated(
                        itemCount: diffanime.length,
                        separatorBuilder: (context, index) => const Divider(
                              color: Color.fromARGB(255, 25, 25, 112),
                              thickness: 2,
                              height: 30,
                            ),
                        itemBuilder: (context, index) {
                          String animeTitle =
                              diffanime[index].title.toUpperCase();
                          double currentRating =
                              animeRatings[animeTitle] ?? 0.0;

                          return Container(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    diffanime[index].image,
                                    height: 400,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton.filled(
                                      focusColor: Colors.pink,
                                      iconSize: 30,
                                      onPressed: () async {
                                        SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                        // Retrieve current lists
                                        List<String> favoriteTitles =
                                            sp.getStringList(
                                                    'favoriteTitles') ??
                                                [];
                                        List<String> favoriteImages =
                                            sp.getStringList(
                                                    'favoriteImages') ??
                                                [];
                                        List<String> favoriteAges =
                                            sp.getStringList('favoriteAges') ??
                                                [];
                                        List<String> favoriteDescriptions =
                                            sp.getStringList(
                                                    'favoriteDescriptions') ??
                                                [];

                                        favoriteTitles.add(diffanime[index]
                                            .title
                                            .toUpperCase());
                                        favoriteImages
                                            .add(diffanime[index].image);
                                        favoriteAges.add(diffanime[index].age);
                                        favoriteDescriptions
                                            .add(diffanime[index].desc);

                                        sp.setStringList(
                                            'favoriteTitles', favoriteTitles);
                                        sp.setStringList(
                                            'favoriteImages', favoriteImages);
                                        sp.setStringList(
                                            'favoriteAges', favoriteAges);
                                        sp.setStringList('favoriteDescriptions',
                                            favoriteDescriptions);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  '${diffanime[index].title} added to favorites')),
                                        );
                                      },
                                      icon: Icon(Icons.favorite_sharp),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    animeTitle,
                                    style: GoogleFonts.aladin(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Age Rating: " + diffanime[index].age,
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  diffanime[index].desc,
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 10),
                                RatingBar.builder(
                                  initialRating: currentRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    _saveRating(animeTitle, rating);
                                  },
                                ),
                                Text(
                                  'Rating: $currentRating / 5',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }));
              }
            }));
  }
}
