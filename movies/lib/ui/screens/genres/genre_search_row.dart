import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movies/ui/theme/theme.dart';

typedef OnSearch = void Function(String searchString);

class GenreSearchRow extends ConsumerStatefulWidget {
  final OnSearch onSearch;
  final String initialValue;

  const GenreSearchRow(this.onSearch,
      {this.initialValue = '', super.key});

  @override
  ConsumerState<GenreSearchRow> createState() => _GenreSearchRowState();
}

class _GenreSearchRowState extends ConsumerState<GenreSearchRow> {
  late TextEditingController movieTextController;
  final FocusNode textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    movieTextController = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant GenreSearchRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      movieTextController.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    movieTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: TextField(
            style: Theme.of(context).textTheme.bodyLarge,
            focusNode: textFocusNode,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            autofocus: false,
            onSubmitted: (value) {
              widget.onSearch(value);
            },
            controller: movieTextController,
            autocorrect: false,
            decoration: InputDecoration(
              filled: true,
              focusColor: searchBarBackgroundColor(context),
              focusedBorder: null,
              enabledBorder: null,
              fillColor: searchBarBackgroundColor(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintText: 'movie name, genre',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: posterBorderColor(context)),
              suffixIcon: IconButton(
                onPressed: () {
                  movieTextController.clear();
                },
                icon: const Icon(Icons.close, color: Colors.white,), // Close icon
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white,),
                onPressed: () {
                  widget.onSearch(movieTextController.text);
                },
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
