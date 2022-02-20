import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../cubit/joke.dart';
import 'joke_info_modal.dart';

class FloatingControl extends StatelessWidget {
  const FloatingControl({Key? key}) : super(key: key);

  void _launchURL(BuildContext context, String url) async {
    if (!await canLaunch(url) || !await launch(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Widget urlButton(BuildContext context) {
    return BlocBuilder<JokeCubit, BaseJokeState>(
      buildWhen: (prev, next) {
        if (next is JokeState) {
          return prev is! JokeState || next.joke?.url != prev.joke?.url;
        }
        return false;
      },
      builder: (context, state) {
        if (state is! JokeState || state.joke?.url == null) {
          return const SizedBox();
        }

        return FloatingActionButton.small(
          tooltip: 'Open in browser',
          child: const Icon(Icons.open_in_new),
          onPressed: () => _launchURL(context, state.joke!.url!),
        );
      },
    );
  }

  Widget shareButton(BuildContext context) {
    return BlocBuilder<JokeCubit, BaseJokeState>(
      buildWhen: (prev, next) {
        if (next is JokeState) {
          return prev is! JokeState || next.joke?.value != prev.joke?.value;
        }
        return false;
      },
      builder: (context, state) {
        if (state is! JokeState || state.joke?.value == null) {
          return const SizedBox();
        }

        var cats = state.joke!.categories?.map((cat) => '#$cat').join(' ');
        var text = state.joke!.value! + (cats != null ? ' $cats' : '');

        return FloatingActionButton(
          tooltip: 'Share joke',
          child: const Icon(Icons.share_outlined),
          onPressed: () => Share.share(text),
        );
      },
    );
  }

  Widget refreshButton(BuildContext context) {
    return BlocSelector<JokeCubit, BaseJokeState, bool>(
        selector: (state) => state is JokeLoadingState,
        builder: (context, state) {
          var loader = Builder(
            builder: (context) => CircularProgressIndicator(
              color: IconTheme.of(context).color,
            ),
          );

          var refresh = Builder(builder: (context) {
            var size = IconTheme.of(context).size;
            return Icon(Icons.refresh, size: size != null ? size * 1.5 : size);
          });

          return FloatingActionButton.large(
            tooltip: 'Show next joke',
            child: state ? loader : refresh,
            onPressed: () => BlocProvider.of<JokeCubit>(context).refresh(),
          );
        });
  }

  Widget infoButton(BuildContext context) {
    return BlocBuilder<JokeCubit, BaseJokeState>(
      buildWhen: (prev, next) {
        if (next is JokeState) {
          return prev is! JokeState || next.joke?.id != prev.joke?.id;
        }
        return false;
      },
      builder: (context, state) {
        if (state is! JokeState || state.joke?.id == null) {
          return const SizedBox();
        }

        return FloatingActionButton.small(
          tooltip: 'Show joke details',
          child: const Icon(Icons.info_outline),
          onPressed: () => showJokeInfo(context, state.joke!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              shareButton(context),
            ],
          ),
        ),
        const SizedBox(width: 20),
        refreshButton(context),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              urlButton(context),
              const SizedBox(width: 12),
              infoButton(context),
            ],
          ),
        ),
      ],
    );
  }
}
