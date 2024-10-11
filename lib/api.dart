import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  String title;
  String image;
  String desc;
  Category({required this.title, required this.image, required this.desc});
}

List<Category> diffcat = [];

List<String> ttl = [
  "adventure",
  "magic",
  "harem",
  "romance",
  "mystery",
  "crime",
];

Future<List<Category>> getCategories() async {
  diffcat.clear();
  for (String category in ttl) {
    String link =
        "https://kitsu.io/api/edge/anime?page[limit]=1&filter[categories]=$category";

    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (var i in data['data']) {
        Category cat = Category(
          title: category,
          image: i['attributes']['posterImage']['small'],
          desc: i['attributes']['synopsis'],
        );
        diffcat.add(cat);
      }
    } else {
      throw Exception('Failed to load data for category: $category');
    }
  }
  return diffcat;
}

class Anime {
  String title;
  String image;
  String desc;
  String age;

  Anime({
    required this.title,
    required this.image,
    required this.desc,
    required this.age,
  });
}

List<Anime> diffanime = [];

Future<List<Anime>> getAnime(String category) async {
  diffanime.clear();
  String link =
      "https://kitsu.io/api/edge/anime?page[limit]=5&filter[categories]=$category";

  final response = await http.get(Uri.parse(link));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    for (var i in data['data']) {
      Anime anime = Anime(
          title: i['attributes']['titles']['en'],
          image: i['attributes']['posterImage']['original'],
          desc: i['attributes']['synopsis'],
          age: i['attributes']['ageRatingGuide']);
      diffanime.add(anime);
    }
  } else {
    throw Exception('Failed to load data for anime: $Anime');
  }
  return diffanime;
}
