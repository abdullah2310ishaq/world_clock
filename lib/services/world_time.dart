import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  late String location;
  String? time;
  String? flag;
  String? url;
  bool isDaytime = false;
  static const _endPoint = "http://worldtimeapi.org/api/timezone";

  WorldTime({required this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      var urlPath = Uri.parse('$_endPoint/$url');
      Response response = await get(urlPath);
      Map<String, dynamic> data = jsonDecode(response.body);
      DateTime now = DateTime.parse(data["datetime"]);
      int offset = int.parse(data["utc_offset"].substring(1, 3));
      String operator = data["utc_offset"].substring(0, 1);
      if (operator == "+") {
        now = now.add(Duration(hours: offset));
      } else if (operator == "-") {
        now = now.subtract(Duration(hours: offset));
      }
      // Set time property
      time = DateFormat.jm().format(now);
      isDaytime = now.hour > 6 && now.hour < 20;
    } catch (e) {
      print(e);
      time = "could not get time data";
    }
  }

  static Future<List<WorldTime>> getCountriesList() async {
    var urlPath = Uri.parse(_endPoint);
    Response response = await get(urlPath);
    List<dynamic> data = jsonDecode(response.body);
    List<WorldTime> countryList = data.map((e) {
      String cityName = e.substring(e.lastIndexOf('/') + 1);
      cityName = cityName.replaceAll('_', ' ');
      return WorldTime(url: e, location: cityName);
    }).toList();
    return countryList;
  }
}
