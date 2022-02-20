import 'dart:convert';

import 'package:flutter/material.dart';

import '../repository/chjokes.dart';

void showJokeInfo(BuildContext context, Joke joke) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => JokeInfoModal(joke),
  );
}

class JokeInfoModal extends StatelessWidget {
  final Joke joke;

  const JokeInfoModal(this.joke, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> attrs = joke
        .toJson()
        .entries
        .map(
          (e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(opacity: 0.5, child: Text('${e.key}:\u202f')),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  e.value is String ? e.value : jsonEncode(e.value),
                ),
              ),
            ],
          ),
        )
        .toList();

    return SimpleDialog(
      title: const Text('Joke deep details'),
      contentPadding: const EdgeInsets.all(8),
      children: <Widget>[
        if (joke.iconUrl != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image(image: NetworkImage(joke.iconUrl!))],
          ),
        ...attrs,
      ],
    );
  }
}
