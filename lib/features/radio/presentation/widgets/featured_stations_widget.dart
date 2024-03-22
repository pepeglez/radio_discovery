import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class FeaturedStationsWidget extends StatelessWidget {
  final List<RadioStation> radioStations;
  final Function(RadioStation) onRadioStationClicked;

  const FeaturedStationsWidget({
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
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Featured Stations',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          height: 250,
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
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.network(
                                radioStations[index].favicon.isNotEmpty
                                    ? radioStations[index].favicon
                                    : 'https://via.placeholder.com/150',
                                width: 150,
                                height: 200,
                                fit: BoxFit.fitHeight,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height:
                                      250 / 2, // 1/3 of the height of the Image
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.9),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom:
                                    10, // adjust this to position the Text correctly
                                left:
                                    10, // adjust this to position the Text correctly
                                child: Text(
                                  'Your Text Here',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
