import 'package:bloc/bloc.dart';
import 'package:cnjokes/cubit/filter.dart';
import 'package:flutter/foundation.dart';

import '../repository/chjokes.dart';

class BaseJokeState {}

class JokeLoadingState extends BaseJokeState {}

class JokeState extends BaseJokeState {
  JokeState(this.joke);

  Joke? joke;
}

class JokeCubit extends Cubit<BaseJokeState> {
  final FilterCubit filter;
  final ChuckNorrisIoRepository api;

  JokeCubit(this.filter, this.api) : super(BaseJokeState()) {
    refresh();
  }

  void refresh() async {
    emit(JokeLoadingState());

    Joke? joke;
    var filter = this.filter.state;
    if (filter is FilterState) {
      var categories = filter.categoriesSelected;
      var query = filter.searchQuery;
      joke = await api.getJoke(
        categories: categories.isEmpty ? null : List.from(categories),
        query: query.isEmpty ? null : query,
      );
    } else {
      joke = await api.getJoke();
    }

    emit(JokeState(joke));

    if (kDebugMode) {
      print(joke?.value);
    }
  }
}
