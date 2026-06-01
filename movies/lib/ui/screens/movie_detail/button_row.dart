import 'package:flutter/material.dart';

import 'package:movies/utils/utils.dart';
import 'package:movies/ui/widgets/text_icon.dart';

typedef OnFavoriteSelected = void Function();

class ButtonRow extends StatefulWidget {
  final bool favoriteSelected;
  final OnFavoriteSelected onFavoriteSelected;

  const ButtonRow({
    super.key,
    required this.favoriteSelected,
    required this.onFavoriteSelected,
  });

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust pulse duration
    )..repeat(reverse: true); // Make animation repeat

    _sizeAnimation = Tween<double>(
      begin: 1.0, // Original size
      end: 1.5, // Scaled-up size
    ).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust color change duration
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.white, // Starting color
      end: Colors.red, // Ending color
    ).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextIcon(
            text: Text(
              'Favorite',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            icon: IconButton(
              onPressed: () {
                widget.onFavoriteSelected();
              },
              icon: widget.favoriteSelected
                  ? AnimatedBuilder(
                      animation:
                          Listenable.merge([_sizeController, _colorController]),
                      builder: (context, child) {
                        return Icon(
                          Icons.favorite_outlined,
                          size: 21 * _sizeAnimation.value,
                          color: _colorAnimation.value,
                        );
                      })
                  : Icon(
                      Icons.favorite_border,
                      color: iconColor,
                    ),
            ),
          ),
          addHorizontalSpace(32),
          TextIcon(
            text: Text(
              'Rate',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.thumb_up_alt_outlined,
                color: iconColor,
              ),
            ),
          ),
          addHorizontalSpace(32),
          TextIcon(
            text: Text(
              'Share',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.ios_share,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
