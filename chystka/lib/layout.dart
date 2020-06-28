import 'dart:io';

import 'package:chystka/components/events_card.dart';
import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';

import 'components/app_bar.dart';
import 'components/map.dart';

class AppLayout extends StatelessWidget {
  final List<EventModel> events;

  AppLayout(this.events);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var appBar = 68;
        try {
          if (Platform.isAndroid || Platform.isIOS) {
            appBar += 26;
          }
        } catch (_) {}

        if (constraints.maxWidth >= 992) {
          return Stack(
            children: [
              Positioned.fill(
                child: MapCard(true, events),
              ),
              Positioned.fill(
                left: MediaQuery.of(context).size.width * 0.5,
                top: 80,
                child: EventsCard(true, events),
              ),
              Positioned.fill(
                  left: MediaQuery.of(context).size.width * 0.5,
                  bottom: MediaQuery.of(context).size.height - appBar,
                  child: NavAppBar()),
            ],
          );
        } else {
          return Stack(
            children: [
              Positioned.fill(
                child: MapCard(false, events),
              ),
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.5,
                child: EventsCard(false, events),
              ),
              Positioned.fill(
                  bottom: MediaQuery.of(context).size.height - appBar,
                  child: NavAppBar()),
            ],
          );
        }
      },
    );
  }
}
