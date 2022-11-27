import 'dart:convert';

import 'package:earthquake/models/earthquake_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EarthquakeProvider extends ChangeNotifier{
  EarthquakeResponse? earthquakeResponse;
  String startDate = '2022-11-20';
  String endDate = '2022-11-23';
  double magnitude = 5.0;

  bool get hasDataLoaded => earthquakeResponse != null ;

  void setData(String sDate, String eDate, double mgtd){
    startDate = sDate;
    endDate = eDate;
    magnitude = mgtd;
  }

  Future<void> getData() async{
    final url = 'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startDate&endtime=$endDate&minmagnitude=$magnitude';
    try{
      final response = await get(Uri.parse(url));
      final map = json.decode(response.body);
      if(response.statusCode == 200){
        earthquakeResponse = EarthquakeResponse.fromJson(map);
        print(earthquakeResponse!.metadata!.title!);
        notifyListeners();
      }else{
        print(response.statusCode.toString());
      }
    }catch(error){
      print(error.toString());
    }
  }
}