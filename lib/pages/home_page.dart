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
  double? magnitude;
  late EarthquakeProvider earthquakeProvider;
  bool isFilteredData = false;

  @override
  void didChangeDependencies() {
    earthquakeProvider = Provider.of<EarthquakeProvider>(context, listen: true);

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
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  label: Text(
                    startDate == null
                        ? 'Start Date'
                        : getFormattedDate(startDate!),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _selectDate(false);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    endDate == null ? "End Date" : getFormattedDate(endDate!),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                DropdownButton<double>(
                  hint: const Text(
                    'Magnitude',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                  value: magnitude,
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () {
                  _getData();
                },
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isFilteredData)
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
                            subtitle: Text(getFormattedDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    properties!.time!.toInt()))),
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

  void _selectDate(bool isStartDate) async {
    final selectDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selectDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectDate;
        } else {
          endDate = selectDate;
        }
      });
    }
  }

  void _getData() {
    if (startDate == null) {
      return;
    }
    if (endDate == null) {
      return;
    }
    if (magnitude == null) {
      return;
    }
    setState(() {
      isFilteredData = true;
    });
    earthquakeProvider.setData(
        getFormattedDate(startDate!), getFormattedDate(endDate!), magnitude!);
    earthquakeProvider.getData();
  }
}
