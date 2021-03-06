import 'package:dio/dio.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:movie_app/environment_config.dart';
import 'package:movie_app/home/movie.dart';
import 'package:movie_app/home/movies_exceptions.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.watch(environmentConfigProvider);

  return MovieService(config, Dio());
});

class MovieService{
  MovieService(this._environmentConfig, this._dio);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Movie>> getMovies() async {
    try {
      final response = await _dio.get(
        "https://api.themoviedb.org/3/movie/popular?api_key=d4fec4e08599947de4dd8334c5d4bda7&language=en-US&page=1",
      );
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies = results.map((movieData) => Movie.fromMap(movieData)).toList(growable: false);
      return movies;
    } on DioError catch (dioError) {
      throw MoviesException.fromDioError(dioError);
    }
  }
}