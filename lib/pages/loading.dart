import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abdullah2/services/helperFunctions.dart';
import 'package:abdullah2/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MaterialApp(home: Loading()));

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> setupWorldTime() async {
    await Future.delayed(Duration(seconds: 5)); // Wait for 5 seconds

    if (await HelperFunctions.checkInternetConnection()) {
      final prefs = await SharedPreferences.getInstance();
      final location = prefs.getString('location') ?? 'Berlin';
      final url = prefs.getString('url') ?? 'Europe/Berlin';
      WorldTime instance = WorldTime(
        location: location,
        url: url,
      );
      await instance.getTime();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "location": instance.location,
        "time": instance.time,
        "isDaytime": instance.isDaytime,
        "url": instance.url,
      });
    } else {
      HelperFunctions.showNoConnectionDialog(context).then((data) async {
        await setupWorldTime();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("World Clock"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand, // Make the background image cover the entire screen
        children: [
          // Background Image
          Image.asset(
            'assets/clock2.jpg', // Replace with the path to your image
            fit: BoxFit.cover, // Cover the entire screen
          ),
          Container(
            color: Colors.blueGrey[900]!.withOpacity(0.6), // Dark blue-grey background color with opacity
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ripple loading animation
                  SpinKitPouringHourGlassRefined(
                    color: Colors.white70, // Change the color as needed
                    size: 120.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Please wait...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5, // Increased spacing
                      fontFamily: 'OpenSans', // Use your desired font family
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Fetching world time data",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      letterSpacing: 1.5, // Increased spacing
                      fontFamily: 'OpenSans', // Use your desired font family
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
