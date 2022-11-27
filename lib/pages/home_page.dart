import 'package:earthquake/providers/earthquake_provider.dart';
import 'package:earthquake/utils/constants.dart';
import 'package:earthquake/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? startDate;
  DateTime? endDate;
  double magnitude = 5.0;
  late EarthquakeProvider earthquakeProvider;
  bool isCalledOnce = true;

  @override
  void didChangeDependencies() {
    if (isCalledOnce) {
      earthquakeProvider =
          Provider.of<EarthquakeProvider>(context, listen: true);
      earthquakeProvider.getData();
    }
    isCalledOnce = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Earthquake Data'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _selectDate(true);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Start Date'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('End Date'),
                ),
                DropdownButton<double>(
                  hint: const Text('Magnitude'),
                  onChanged: (value) {
                    setState(() {
                      magnitude = value!;
                    });
                  },
                  items: magList
                      .map((e) => DropdownMenuItem<double>(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('GO'),
                ),
              ],
            ),
            Expanded(
              child: earthquakeProvider.hasDataLoaded
                  ? ListView.builder(
                      itemCount: earthquakeProvider
                          .earthquakeResponse!.features!.length,
                      itemBuilder: (context, index) {
                        final features = earthquakeProvider
                            .earthquakeResponse!.features![index];
                        final properties = features.properties;
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(properties!.mag.toString()),
                          ),
                          title: Text(properties.place.toString()),
                          subtitle: Text(getFormattedDate(DateTime.fromMillisecondsSinceEpoch(properties!.time!.toInt()))),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ));
  }

  void _selectDate(bool isStartDate) async{

  }
}
