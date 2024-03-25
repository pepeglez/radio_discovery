import 'package:flutter/material.dart';

class GenresListWidget extends StatelessWidget {
  final List<String> genres;
  final Function(String) onGenreSelected;
  const GenresListWidget({
    super.key,
    required this.genres,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24,),
            child: Row(
              children: [
                Icon(
                  Icons.music_note,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'By Genres',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 2,
            runSpacing: 2,
            alignment: WrapAlignment.spaceEvenly,
            children: genres.map((tag) {
              if (tag.isEmpty) return const SizedBox.shrink();
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ActionChip(
                    avatar: const Icon(
                      Icons.music_note,
                      size: 20,
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.all(12),
                    label: Text(tag),
                    onPressed: () => onGenreSelected(tag),
                  ));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
