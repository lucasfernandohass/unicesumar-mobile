import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movies/utils/utils.dart';

typedef OnSortSelected = void Function(Sorting);

class SortPicker extends ConsumerStatefulWidget {
  final bool useSliver;
  final Sorting initialSelectedSort;
  final OnSortSelected onSortSelected;

  const SortPicker(
      {required this.useSliver,
      required this.initialSelectedSort,
      required this.onSortSelected,
      super.key});

  @override
  ConsumerState<SortPicker> createState() => _SortPickerState();
}

class _SortPickerState extends ConsumerState<SortPicker> {
  late Sorting selectedSort;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.initialSelectedSort;
  }

  @override
  void didUpdateWidget(covariant SortPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedSort != oldWidget.initialSelectedSort) {
      selectedSort = widget.initialSelectedSort;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSliver) {
      return SliverToBoxAdapter(
          child: buildRow()
      );
    } else {
      return buildRow();
    }
  }

  Widget buildRow() {
    return Row(
      children: [
        const Spacer(),
        Text(
          selectedSort.name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        addHorizontalSpace(16),
        PopupMenuButton<Sorting>(
          icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).iconTheme.color,
        ),
          onSelected: (Sorting value) {
            widget.onSortSelected(value);
          },
          itemBuilder: (BuildContext context) {
            return Sorting.values
                .mapIndexed<PopupMenuItem<Sorting>>((int index, Sorting sort) {
              return CheckedPopupMenuItem<Sorting>(
                checked: selectedSort == sort,
                value: sort,
                onTap: () {
                  setState(() {
                    selectedSort = sort;
                  });
                },
                child: Text(sort.name),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}