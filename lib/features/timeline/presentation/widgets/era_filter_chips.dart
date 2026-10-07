import 'package:flutter/material.dart';

class EraFilterChips extends StatelessWidget {
  const EraFilterChips({
    super.key,
    required this.eras,
    required this.selectedEra,
    required this.onSelected,
  });

  final List<String> eras;
  final String? selectedEra; // null = semua era
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: selectedEra == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final era in eras) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(era),
              selected: selectedEra == era,
              onSelected: (_) => onSelected(era),
            ),
          ],
        ],
      ),
    );
  }
}
