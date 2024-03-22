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
      height: 100,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
            itemCount: genres.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: ((context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ActionChip(
                    avatar: const Icon(
                      Icons.music_note,
                      size: 20,
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.all(12),
                    label: Text(genres[index]),
                    onPressed: () => onGenreSelected(genres[index]),
                  ));
            })),
      ),
    );
  }
}