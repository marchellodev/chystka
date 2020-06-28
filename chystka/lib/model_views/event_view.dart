import 'dart:convert';

import 'package:chystka/conf.dart';
import 'package:chystka/model_views/event_dialog.dart';
import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventView extends StatefulWidget {
  final EventModel model;

  EventView(this.model);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: ListTile(
        onTap: () {
          // todo mobile safe area
          showDialog(
              context: context,
              builder: (ctx) => EventDialogView(widget.model));
        },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd MMMM', 'en_US').format(widget.model.date),
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
            Text(
              DateFormat('HH:mm', 'en_US').format(widget.model.date),
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
            ),
          ],
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: modelState2Color(widget.model.state),
            ),
            SizedBox(
              width: 8,
            ),
            Text(widget.model.place),
          ],
        ),
        trailing: InkWell(
          onTap: () async {
            setState(() {
              widget.model.liked = null;
            });
            var r = await http.read('$getServer/like/${widget.model.id}');
            var js = jsonDecode(r);

            setState(() {
              widget.model.likes += js['liked'] ? 1 : -1;
              widget.model.liked = js['liked'];
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.model.likes.toString(),
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              SizedBox(
                width: 6,
              ),
              if (widget.model.liked == null) CircularProgressIndicator(),
              if (widget.model.liked != null)
                Icon(
                  Icons.thumb_up,
                  color: widget.model.liked ? Colors.green : Colors.grey[800],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
