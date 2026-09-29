import 'package:flutter/material.dart';

class TimelineSearchField extends StatelessWidget {
  const TimelineSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: 'Cari peristiwa...',
      leading: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}