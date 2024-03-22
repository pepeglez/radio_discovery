import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class RecentlyPlayedWidget extends StatelessWidget {
  final List<RadioStation> radioStations;
  final Function(RadioStation) onRadioStationClicked;

  const RecentlyPlayedWidget({
    super.key,
    required this.radioStations,
    required this.onRadioStationClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24, top: 36),
          child: Text(
            'Recently played',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          height: 120,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
                itemCount: radioStations.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () => onRadioStationClicked(radioStations[index]),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  radioStations[index].favicon.isNotEmpty
                                      ? radioStations[index].favicon
                                      : 'https://via.placeholder.com/150',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                                width: 60,
                                child: Text(
                                  radioStations[index].name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        )),
                  );
                })),
          ),
        ),
      ],
    );
  }
}