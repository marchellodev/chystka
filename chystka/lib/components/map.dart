import 'package:chystka/model_views/event_dialog.dart';
import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class MapCard extends StatelessWidget {
  final bool horizontal;
  final List<EventModel> events;

  MapCard(this.horizontal, this.events);

  @override
  Widget build(BuildContext context) {
    var lat = 50.45466;
    var long = 30.5238;
//    var lat = 51.621164182;
//    var long = 24.956329508;
    var scale = 12.0;
    var latoffs = 0.0;
    var longoffs = 0.0;
    if (!horizontal) {
      var offset = MediaQuery.of(context).size.height;

      offset /= 2;
      offset -= 68;
      offset /= 2;
      offset *= 0.00024;
      offset = offset / 12 * scale;
      print(offset);
      lat -= offset;
      latoffs = offset;
      print('lat $offset');
    } else {
      var offset = MediaQuery.of(context).size.width;

      offset /= 2;
      offset /= 2;
      offset *= 0.00032;
      offset = offset / 12 * scale;
      print(offset);
      long += offset;
      longoffs = offset;
      print('long $offset');
    }

    return FlutterMap(
      options: MapOptions(
        center: LatLng(lat, long),
        zoom: scale,
        minZoom: scale / 2,
        maxZoom: scale * 2,
        plugins: [
          ZoomButtonsPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          tileProvider: CachedNetworkTileProvider(),
        ),
        MarkerLayerOptions(
            markers: events
                .map((e) => Marker(
                      point: e.coordinates,
                      width: 40,
                      height: 50,
                      builder: (_) => IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => EventDialogView(e));
                          },
                          icon: Icon(
                            Icons.location_on,
                            color: modelState2Color(e.state),
                          )),
                    ))
                .toList()),
        ZoomButtonsPluginOption(
            minZoom: scale ~/ 2,
            maxZoom: scale * 2 ~/ 1,
            mini: true,
            padding: 10,
            horizontal: horizontal,
            alignment: Alignment.center,
            lat: latoffs,
            long: longoffs)
      ],
    );
  }
}

class ZoomButtonsPluginOption extends LayerOptions {
  final int minZoom;
  final int maxZoom;
  final bool mini;
  final bool horizontal;
  final double padding;
  final Alignment alignment;
  final double long;
  final double lat;

  ZoomButtonsPluginOption(
      {this.minZoom = 1,
      this.maxZoom = 18,
      this.mini = true,
      this.horizontal = true,
      this.padding = 2,
      this.long,
      this.lat,
      this.alignment = Alignment.topRight});
}

class ZoomButtonsPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ZoomButtonsPluginOption) {
      return ZoomButtons(options, mapState, stream);
    }
    throw Exception('Unknown options type for ZoomButtonsPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ZoomButtonsPluginOption;
  }
}

class ZoomButtons extends StatelessWidget {
  final ZoomButtonsPluginOption zoomButtonsOpts;
  final MapState map;
  final Stream<Null> stream;
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12.0));

  ZoomButtons(this.zoomButtonsOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    var plus = Padding(
      padding: EdgeInsets.all(1),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'zoomInButton',
        mini: zoomButtonsOpts.mini,
        onPressed: () {
          var bounds = map.getBounds();
          var centerZoom = map.getBoundsCenterZoom(bounds, options);
          var zoom = centerZoom.zoom + 0.2;
          if (zoom < zoomButtonsOpts.minZoom) {
            zoom = zoomButtonsOpts.minZoom as double;
          } else {
            map.move(
                LatLng(centerZoom.center.latitude + zoomButtonsOpts.lat / 14,
                    centerZoom.center.longitude - zoomButtonsOpts.long / 14),
                zoom);
          }
        },
        child: Icon(
          Icons.zoom_in,
          color: Colors.grey[900],
        ),
      ),
    );

    var min = Padding(
      padding: EdgeInsets.all(1),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'zoomOutButton',
        mini: zoomButtonsOpts.mini,
        onPressed: () {
          var bounds = map.getBounds();

          var centerZoom = map.getBoundsCenterZoom(bounds, options);

          var zoom = centerZoom.zoom - 0.2;
          if (zoom > zoomButtonsOpts.maxZoom) {
            zoom = zoomButtonsOpts.maxZoom as double;
          } else {
            map.move(
                LatLng(centerZoom.center.latitude - zoomButtonsOpts.lat / 14,
                    centerZoom.center.longitude + zoomButtonsOpts.long / 14),
                zoom);
          }
        },
        child: Icon(
          Icons.zoom_out,
          color: Colors.grey[900],
        ),
      ),
    );

    return Align(
      alignment: zoomButtonsOpts.horizontal ? Alignment(0, 1) : Alignment(1, 0),
      child: zoomButtonsOpts.horizontal
          ? Padding(
              padding: const EdgeInsets.only(right: 90, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[plus, min],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 90, right: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [min, plus],
              ),
            ),
    );
  }
}
