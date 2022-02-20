import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';

import '../cubit/joke.dart';

final unescape = HtmlUnescape();

class JokeBody extends StatelessWidget {
  const JokeBody({Key? key}) : super(key: key);

  Widget categoriesLayer(BuildContext context) {
    var cats = BlocBuilder<JokeCubit, BaseJokeState>(
      buildWhen: (prev, next) {
        if (next is JokeState) {
          return prev is! JokeState ||
              !listEquals(prev.joke?.categories, next.joke?.categories);
        }
        return false;
      },
      builder: (context, state) {
        if (state is! JokeState || state.joke?.categories == null) {
          return Container();
        }

        return Wrap(
          spacing: 5,
          alignment: WrapAlignment.center,
          children: state.joke!.categories!
              .map((cat) => Chip(label: Text(cat)))
              .toList(),
        );
      },
    );

    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: cats,
    );
  }

  Widget jokeLayer(BuildContext context) {
    return BlocBuilder<JokeCubit, BaseJokeState>(
      buildWhen: (prev, next) {
        if (next is JokeState) {
          return prev is! JokeState || next.joke?.value != prev.joke?.value;
        }
        return false;
      },
      builder: (context, state) {
        if (state is! JokeState) {
          return Container();
        }

        if (state.joke?.value == null) {
          return Center(
            child: Text(
              'Try changing filters',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                unescape.convert(state.joke!.value!),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 13,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            categoriesLayer(context),
            jokeLayer(context),
          ],
        ),
      ),
    );
  }
}
