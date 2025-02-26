import 'package:flutter/material.dart';
import 'package:abdullah2/pages/choose_location.dart';
import 'package:abdullah2/pages/home.dart';
import 'package:abdullah2/pages/loading.dart';

void main() {

 runApp(
     MaterialApp(
      initialRoute: '/',
      routes: {//map
       '/': (context) {
        return const Loading();
       },
       "/home": (context) {
        return const Home();
       },
       "/location": (context) {
        return ChooseLocation();
       }
      },
     )
 );
}
