import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'filter_modal.dart';
import 'floating_control.dart';
import 'joke_body.dart';

class JokesPage extends StatelessWidget {
  const JokesPage({Key? key}) : super(key: key);

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const AutoSizeText('Chuck Norris Jokes', maxLines: 1),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Filter jokes',
            onPressed: () => showFilterModal(context),
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About app',
            onPressed: () => showAboutDialog(
              context: context,
              applicationIcon: const FlutterLogo(),
              applicationLegalese: 'Created by Aleksandr Krotov',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: const JokeBody(),
      floatingActionButton: const FloatingControl(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
