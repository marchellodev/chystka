import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:sqflite_common/sqlite_api.dart' as sq;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

export 'dart:async';
export 'dart:io';

export 'package:aqueduct/aqueduct.dart';

Future<void> main(List<String> arguments) async {
  // state: 0 - browse, 1 - active, 2 - done

  // todo
/*
  await (await db).execute('''
create table events
(
    id    integer
        constraint events_pk
            primary key autoincrement,
    name  varchar,
    state integer,
    social_media varchar,
    media_link varchar,
    lat   double,
    long  double,
    date  integer,
    likes  integer
);
  ''');

  await (await db).execute('''
create table likes
(
	id integer
		constraint like_list_pk
			primary key autoincrement,
	ip varchar,
	event integer,
	date integer
);
  ''');

  var data = await db;
  await data.insert('events', {
    'name': 'Kyiv Fortress',
    'state': 0,
    'media_link': 'https://facebook.com',
    'social_media': 'Facebook',
    'lat': 50.434341,
    'long': 30.527756,
    'date': 1599901200,
    'likes': 0
  });

  await data.insert('events', {
    'name': 'Teacher\'s House',
    'state': 2,
    'media_link': 'https://instagram.com',
    'social_media': 'Instagram',
    'lat': 50.444412,
    'long': 30.515659,
    'date': 1598457600,
    'likes': 0
  });

  await data.insert('events', {
    'name': 'Kyiv Planetarium',
    'state': 1,
    'media_link': 'https://facebook.com',
    'social_media': 'Facebook',
    'lat': 50.431782,
    'long': 30.516382,
    'date': 1593352800,
    'likes': 0
  });
  await data.insert('events', {
    'name': 'A. V. fomin Botanic Garden',
    'state': 0,
    'media_link': 'https://instagram.com',
    'social_media': 'Instagram',
    'lat': 50.441915,
    'long': 30.5110729,
    'date': 1599591600,
    'likes': 0
  });
*/
  final app = Application<AppChannel>()..options.port = 8070;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);
//
//  await db.insert('events', <String, dynamic>{
//    'name': 'Product 1',
//    'state': 0,
//    'lat': 1.01010101,
//    'long': '0.10010101010',
//    'date': DateTime.now().millisecondsSinceEpoch ~/ 1000
//  });
//  await db.insert('Product', <String, dynamic>{'title': 'Product 1'});
//
//  var result = await db.query('Product');
//  print(result);
//  // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
//  await db.close();
}

Future<sq.Database> get db async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase('data.db');
  return db;
}

class AppChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route('/get').linkFunction((request) async {
      var data = await db;
      var arr = await data.query('events');

      var newArr = [];

      for (var el in arr) {
        print(request.raw.headers['X-Real-IP'][0]);
        var ip = request.raw.headers['X-Real-IP'][0];

        var res = await data.rawQuery(
            'SELECT COUNT(*) as c FROM likes WHERE event = ${el['id']} AND ip = \'$ip\'');
        newArr.add({
          'id': el['id'],
          'name': el['name'],
          'state': el['state'],
          'lat': el['lat'],
          'long': el['long'],
          'date': el['date'],
          'likes': el['likes'],
          'liked': res[0]['c'] != 0,
          'social_media': el['social_media'],
          'media_link': el['media_link'],
        });
      }

      return Response.ok(newArr.toList());
    });

    router.route('/like/[:id]').linkFunction((request) async {
      if (!request.path.variables.containsKey('id')) {
        return Response.ok({'ok': 'error'});
      }

      final id = int.tryParse(request.path.variables['id']);
      if (id == null) {
        return Response.ok({'ok': 'error'});
      }
      print(request.raw.headers['X-Real-IP'][0]);

      var ip = request.raw.headers['X-Real-IP'][0];

      var data = await db;
      var res = await data.rawQuery(
          'SELECT COUNT(*) as c FROM likes WHERE event = $id AND ip = \'$ip\'');
      if (res[0]['c'] == 0) {
        await data.insert('likes', {
          'ip': ip,
          'event': id,
          'date': DateTime.now().millisecondsSinceEpoch ~/ 1000
        });
        await data
            .rawQuery('UPDATE events SET likes = likes + 1 WHERE id = $id');
        return Response.ok({'liked': true});
      } else {
        await data
            .rawQuery('DELETE FROM likes WHERE event = $id AND ip = \'$ip\'');
        await data
            .rawQuery('UPDATE events SET likes = likes - 1 WHERE id = $id');
        return Response.ok({'liked': false});
      }
    });

    return router;
  }
}
