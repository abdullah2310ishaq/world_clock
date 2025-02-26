import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:abdullah2/services/helperFunctions.dart';
import 'package:abdullah2/services/world_time.dart';
import 'package:localstore/localstore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map<String, dynamic> data;
  final db = Localstore.instance;

  @override
  void initState() {
    super.initState();
    data = {};
  }

  @override
  Widget build(BuildContext context) {
    String bgImage = data.containsKey('isDaytime') && data['isDaytime'] == true
        ? 'daya.png'
        : 'nigga.png';

    // Get the current date and time
    DateTime currentTime = DateTime.now();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("World Clock"),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          WorldTime instance = WorldTime(
            location: data["location"] ?? "",
            url: data["url"] ?? "",
          );

          if (await HelperFunctions.checkInternetConnection()) {
            await instance.getTime();

            setState(() {
              data["location"] = instance.location;
              data["time"] = instance.time;
              data["isDaytime"] = instance.isDaytime;
            });
          } else {
            HelperFunctions.showNoConnectionDialog(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height:1), // Adjust the spacing
                Text(
                  "Current Area Time: ${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.5,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 30), // Adjust the spacing
                ElevatedButton.icon(
                  onPressed: () async {
                    dynamic result =
                    await Navigator.pushNamed(context, "/location");

                    if (result != null) {
                      setState(() {
                        data = result;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Select Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 150),
                Text(
                  data["location"] ?? "",
                  style:  TextStyle(
                    fontSize: 50,
                    letterSpacing: 2.0,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  data['time'] ?? "",
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
