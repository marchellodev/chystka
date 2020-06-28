import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class EventModel {
  int id;
  DateTime date;
  String place;
  int likes;
  EventState state;
  LatLng coordinates;
  bool liked;
  String socialMedia;
  String mediaLink;

  EventModel(
      {this.state,
      this.place,
      this.likes,
      this.liked,
      this.coordinates,
      this.date,
      this.socialMedia,
      this.mediaLink,
      this.id});
}

enum EventState { explore, active, finished }

Color modelState2Color(EventState state) {
  switch (state) {
    case EventState.explore:
      return Colors.green;
      break;
    case EventState.active:
      return Colors.red;
      break;
    case EventState.finished:
      return Colors.blueGrey;
      break;
  }
  throw UnimplementedError();
}

EventState int2EventState(int i) {
  if (i == 0) {
    return EventState.explore;
  }
  if (i == 1) {
    return EventState.active;
  }
  if (i == 2) {
    return EventState.finished;
  }
  throw UnimplementedError();
}
