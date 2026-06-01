import 'package:flutter/material.dart';

typedef OnMoreClicked = void Function();

class TitleRow extends StatelessWidget {
  final String text;
  final OnMoreClicked onMoreClicked;
  const TitleRow({super.key, required this.text, required this.onMoreClicked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16.0, 0.0, 8.0),
          child: Text(text, style: theme.titleLarge),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16.0, 8.0, 0.0),
          child: TextButton(
            onPressed: onMoreClicked,
            child: Text(
              'More',
              style: theme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
