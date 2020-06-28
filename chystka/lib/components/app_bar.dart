// todo make text selectable
import 'package:chystka/conf.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
          ),
          child: Column(
            children: [
              Spacer(),
              Text(
                'Help us make Kyiv cleaner!',
                style: TextStyle(color: Colors.grey[900], fontSize: 22),
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getSocial
                      .map(
                        (e) => Material(
                          borderRadius: BorderRadius.circular(double.maxFinite),
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              launch(e.url);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                e.icon,
                                color: Colors.grey[900],
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
              Spacer(),
            ],
          ),
        ),
      );
}
