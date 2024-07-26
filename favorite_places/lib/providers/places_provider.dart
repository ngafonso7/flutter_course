import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlacesListNotifier extends StateNotifier<List<Place>> {
  PlacesListNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');

    final places = data
        .map(
          (row) => Place(
            row['id'] as String,
            row['title'] as String,
            row['image'] as String,
            PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addNewPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.imagePath);

    final copiedImage =
        await File(place.imagePath).copy('${appDir.path}/$fileName');
    final newPlace = Place(null, place.title, copiedImage.path, place.location);

    final db = await _getDataBase();

    // db.insert('users_places', {
    //   'id': newPlace.id,
    //   'title': newPlace.title,
    //   'image': newPlace.imagePath,
    //   'lat': newPlace.location.latitude,
    //   'lng': newPlace.location.longitude,
    //   'address': newPlace.location.address
    // });

    print(await db.insert('user_places', newPlace.placeInformation));

    state = [newPlace, ...state];
  }
}

final placesListProvider =
    StateNotifierProvider<PlacesListNotifier, List<Place>>((ref) {
  return PlacesListNotifier();
});
