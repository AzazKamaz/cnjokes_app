import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/filter.dart';
import '../cubit/joke.dart';
import '../repository/chjokes.dart';
import 'jokes_page.dart';

class JokesApp extends StatelessWidget {
  const JokesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => ChuckNorrisIoRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (BuildContext context) => FilterCubit(
              RepositoryProvider.of<ChuckNorrisIoRepository>(context),
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (BuildContext context) => JokeCubit(
              BlocProvider.of<FilterCubit>(context),
              RepositoryProvider.of<ChuckNorrisIoRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Chuck Norris Jokes',
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system,
          home: const JokesPage(),
        ),
      ),
    );
  }
}
