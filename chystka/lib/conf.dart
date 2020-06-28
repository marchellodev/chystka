import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String get getServer => 'http://localhost:8070';
String get getHashTagPref => 'сhystka';

List<SocialLink> get getSocial => [
      SocialLink('https://facebook.com', MdiIcons.facebook),
      SocialLink('https://twitter.com', MdiIcons.twitter),
      SocialLink('mailto:marchellodev@gmail.com', MdiIcons.email),
      SocialLink('https://marchello.cf', MdiIcons.web),
    ];

class SocialLink {
  IconData icon;
  String url;
  SocialLink(this.url, this.icon);
}
