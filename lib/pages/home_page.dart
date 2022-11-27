import 'package:earthquake/providers/earthquake_provider.dart';
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
  
  @override
  void didChangeDependencies() {
    earthquakeProvider = Provider.of<EarthquakeProvider>(context, listen: true);
    earthquakeProvider.getData();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Data'),
      ),
      body: ListView(
        children: [
          Text('${earthquakeProvider.earthquakeResponse!.metadata!.status!}')
        ],
      ),
    );
  }
}
