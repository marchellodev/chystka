import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';

class EventDialogView extends StatelessWidget {
  // todo remove all cupertino imports
  // todo nice config file

  final EventModel model;

  EventDialogView(this.model);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: 340,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                // SECTION 1
                Row(
                  children: [
                    Text(
                      'Location',
                      style: GoogleFonts.montserratAlternates(
                          color: Colors.green, fontSize: 20),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.location_on,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      model.place,
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    FlatButton(
                      onPressed: () {
                        launch(
                            "https://www.google.com/maps/place/${model.coordinates.latitude},${model.coordinates.longitude}");
                      },
                      child: Text(
                        'Open in Google Maps',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
                // SECTION 2
                Text(
                  'Date',
                  style: GoogleFonts.montserratAlternates(
                      color: Colors.green, fontSize: 20),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.access_time,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm')
                          .format(model.date.toLocal()),
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    FlatButton(
                      onPressed: () {
                        print('launching');
                        launch(
                            'https://www.google.com/calendar/render?action=TEMPLATE&text=title&details=desc&location=loc&dates=${DateFormat('yyyyMMdd Hms').format(model.date).replaceAll(' ', 'T')}00/${DateFormat('yyyyMMdd Hms').format(model.date).replaceAll(' ', 'T')}00');
                      },
                      child: Text(
                        'Open in Google Calendar',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
                // SECTION 3
                Text(
                  'Stage',
                  style: GoogleFonts.montserratAlternates(
                      color: Colors.green, fontSize: 20),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.explore,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      model.state.toString().split('.')[1] == 'explore'
                          ? 'planning'
                          : model.state.toString().split('.')[1],
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    FlatButton(
                      onPressed: () {
                        launch(model.mediaLink);
                      },
                      child: Text(
                        'Open post on ${model.socialMedia}',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
                // SECTION 4
                Text(
                  'Hashtag',
                  style: GoogleFonts.montserratAlternates(
                      color: Colors.green, fontSize: 20),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.attach_file,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '#$getHashTagPref${model.id}',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    FlatButton(
                      onPressed: () {
                        launch(
                            'https://instagram.com/tags/$getHashTagPref${model.id}');
                      },
                      child: Text(
                        'Find photos on Instagram',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
