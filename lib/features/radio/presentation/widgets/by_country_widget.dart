import 'package:flutter/material.dart';

class ByCountryWidget extends StatelessWidget {
  final List<String> countries;
  final Function(String) onCountryClicked;

  const ByCountryWidget({
    super.key,
    required this.countries,
    required this.onCountryClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'By country',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(countries.length, (index) {
                  return Card(
                    //color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 4,
                    child: InkWell(
                      onTap: () => onCountryClicked(countries[index]),
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child:
                            Center(child: Text(countries[index].toUpperCase())),
                      ),
                    ),
                  );
                }),
              ),
            )),
      ],
    );
  }
}
