import 'package:flutter/material.dart';

import '../data/timeline_data.dart';
import '../data/timeline_entry.dart';
import 'widgets/empty_results_view.dart';
import 'widgets/era_filter_chips.dart';
import 'widgets/era_header.dart';
import 'widgets/timeline_entry_card.dart';
import 'widgets/timeline_search_field.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  static final List<String> _eras =
  timelineEntries.map((e) => e.era).toSet().toList();

  // State yang di-hoist di sini, dipakai bersama oleh anak-anaknya.
  bool _isLoading = true;
  String _query = '';
  String? _selectedEra;
  final Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Simulasi loading; nanti diganti pemanggilan data sungguhan.
  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (!_favoriteIds.remove(id)) _favoriteIds.add(id);
    });
  }

  // Dihitung dari state, bukan disimpan sebagai state terpisah.
  List<TimelineEntry> get _filteredEntries {
    final q = _query.trim().toLowerCase();
    return timelineEntries.where((e) {
      final matchesEra = _selectedEra == null || e.era == _selectedEra;
      final matchesQuery = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.summary.toLowerCase().contains(q);
      return matchesEra && matchesQuery;
    }).toList();
  }

  // Menyisipkan nama era (String) di antara entri (TimelineEntry).
  List<Object> _groupByEra(List<TimelineEntry> entries) {
    final rows = <Object>[];
    String? lastEra;
    for (final entry in entries) {
      if (entry.era != lastEra) {
        rows.add(entry.era);
        lastEra = entry.era;
      }
      rows.add(entry);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filteredEntries;
    final rows = _groupByEra(entries);

    return Scaffold(
      appBar: AppBar(title: const Text('Star Wars Timeline')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TimelineSearchField(
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          EraFilterChips(
            eras: _eras,
            selectedEra: _selectedEra,
            onSelected: (era) => setState(() => _selectedEra = era),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : entries.isEmpty
                ? const EmptyResultsView()
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final row = rows[index];
                if (row is! TimelineEntry) {
                  return EraHeader(era: row as String);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: TimelineEntryCard(
                    entry: row,
                    isFavorite: _favoriteIds.contains(row.id),
                    onTap: () {
                      // TODO: buka layar detail (layar ke-2).
                    },
                    onFavoriteToggled: _toggleFavorite,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}