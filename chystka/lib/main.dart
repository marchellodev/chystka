import 'dart:convert';

import 'package:chystka/conf.dart';
import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

import 'layout.dart';

/*

screens:
main: map + list
intro: about & select your city

*/
void main() {
  runApp(MaterialApp(
    builder: (context, child) {
      return ScrollConfiguration(
        behavior: MyBehavior(),
        child: child,
      );
    },
    debugShowCheckedModeBanner: false,
    home: Scaffold(backgroundColor: Colors.grey[400], body: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: loadEvents(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AppLayout(snapshot.data);
            }));
  }
}

Future<List<EventModel>> loadEvents() async {
  var data = await http.read('$getServer/get');

  print('d');
  print(data);
  var json = jsonDecode(data);

  var list = <EventModel>[];
  for (var el in json) {
    list.add(
      EventModel(
          coordinates: LatLng(el['lat'], el['long']),
          liked: el['liked'],
          likes: el['likes'],
          place: el['name'],
          mediaLink: el['media_link'],
          socialMedia: el['social_media'],
          state: int2EventState(el['state']),
          id: el['id'],
          date: DateTime.fromMillisecondsSinceEpoch(el['date'] * 1000)),
    );
  }
  return list;
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
