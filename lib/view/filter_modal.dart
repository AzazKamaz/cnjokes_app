import 'package:cnjokes/cubit/filter.dart';
import 'package:cnjokes/cubit/joke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showFilterModal(BuildContext context) async {
  await showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                .add(const EdgeInsets.all(32)),
        child: const FilterModal(),
      );
    },
  );
}

class FilterModal extends StatelessWidget {
  const FilterModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filter = BlocProvider.of<FilterCubit>(context, listen: true);
    if (filter.state is! FilterState) {
      return const CircularProgressIndicator();
    }
    var state = filter.state as FilterState;

    var filterActive = state.searchQuery.isEmpty;
    var queryActive = state.categoriesSelected.isEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Filter by category:',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: -11,
          children: state.categories
              .map((cat) => FilterChip(
                    label: Text(cat),
                    onSelected:
                        filterActive ? (_) => filter.switchCategory(cat) : null,
                    selected: state.categoriesSelected.contains(cat),
                  ))
              .toList(),
        ),
        TextFormField(
          initialValue: state.searchQuery,
          enabled: queryActive,
          onChanged: (String query) => filter.setQuery(query),
          decoration: InputDecoration(
            label: const Text('Search query'),
            errorText: state.validateQuery,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<JokeCubit>(context).refresh();
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        )
      ],
    );
  }
}
