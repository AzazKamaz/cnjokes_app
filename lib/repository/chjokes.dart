import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'chjokes.g.dart';

@RestApi(baseUrl: "https://api.chucknorris.io/jokes/")
abstract class ChuckNorrisJokesClient {
  factory ChuckNorrisJokesClient(Dio dio, {String baseUrl}) =
      _ChuckNorrisJokesClient;

  @GET("/categories")
  Future<List<String>> getCategories();

  @GET("/random")
  Future<Joke> getRandom();

  @GET("/random")
  Future<Joke> getRandomInCategory(@Query("category") String category);

  @GET("/search")
  Future<JokeSearch> search(@Query("query") String query);
}

@JsonSerializable()
class Joke {
  String? id;
  List<String>? categories;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'icon_url')
  String? iconUrl;
  String? url;
  String? value;

  Joke();

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);

  Map<String, dynamic> toJson() => _$JokeToJson(this);
}

@JsonSerializable()
class JokeSearch {
  int total = 0;
  List<Joke> result = [];

  JokeSearch();

  factory JokeSearch.fromJson(Map<String, dynamic> json) =>
      _$JokeSearchFromJson(json);

  Map<String, dynamic> toJson() => _$JokeSearchToJson(this);
}

class SearchCache {
  final String query;
  final List<Joke> jokes;

  SearchCache(this.query, this.jokes);
}

class ChuckNorrisIoRepository {
  final ChuckNorrisJokesClient client;
  SearchCache? search;

  ChuckNorrisIoRepository()
      : client = ChuckNorrisJokesClient(
          Dio()..interceptors.add(LogInterceptor(responseBody: true)),
        );

  Future<List<String>> getCategories() async {
    while (true) {
      try {
        return await client.getCategories();
      } catch (e) {
        print(e);
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  Future<Joke?> getJoke({List<String>? categories, String? query}) async {
    try {
      if (categories != null) {
        return await client.getRandomInCategory(categories.join(','));
      }
      if (query != null) {
        if (search == null || search!.query != query || search!.jokes.isEmpty) {
          var jokes = (await client.search(query)).result;
          jokes.shuffle();
          search = SearchCache(query, jokes);
        }
        if (search!.jokes.isEmpty) {
          return null;
        }
        return search!.jokes.removeLast();
      }
      return await client.getRandom();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
