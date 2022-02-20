import 'package:bloc/bloc.dart';
import 'package:cnjokes/repository/chjokes.dart';

class BaseFilterState {}

class FilterLoadingState extends BaseFilterState {}

class FilterState extends BaseFilterState {
  FilterState({
    required this.categories,
    required this.categoriesSelected,
    required this.searchQuery,
  });

  List<String> categories;
  Set<String> categoriesSelected;
  String searchQuery;

  String? get validateQuery {
    if (searchQuery.isEmpty) {
      return null;
    }

    if (searchQuery.length < 3) {
      return 'Query is too short';
    }

    if (searchQuery.length > 120) {
      return 'Query is too long';
    }

    return null;
  }
}

class FilterCubit extends Cubit<BaseFilterState> {
  final ChuckNorrisIoRepository api;

  FilterCubit(this.api) : super(BaseFilterState()) {
    _refresh();
  }

  void _refresh() async {
    emit(FilterLoadingState());
    var cats = await api.getCategories();
    emit(FilterState(
      categories: cats,
      categoriesSelected: Set.identity(),
      searchQuery: '',
    ));
  }

  void switchCategory(String category) {
    if (this.state is! FilterState) {
      return;
    }

    var state = this.state as FilterState;
    if (!state.categories.contains(category)) {
      return;
    }

    var selected = Set<String>.from(state.categoriesSelected);
    if (selected.contains(category)) {
      selected.remove(category);
    } else {
      selected.add(category);
    }

    emit(FilterState(
      categories: state.categories,
      categoriesSelected: selected,
      searchQuery: state.searchQuery,
    ));
  }

  void setQuery(String query) {
    if (this.state is! FilterState) {
      return;
    }

    var state = this.state as FilterState;
    emit(FilterState(
      categories: state.categories,
      categoriesSelected: state.categoriesSelected,
      searchQuery: query,
    ));
  }
}
