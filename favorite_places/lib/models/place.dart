import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Map<String, dynamic> get placeInformation {
    return {
      'id': id,
      'title': title,
      'image': imagePath,
      'lat': location.latitude,
      'lng': location.longitude,
      'address': location.address
    };
  }

  Place(
    id,
    this.title,
    this.imagePath,
    this.location,
  ) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String imagePath;
  final PlaceLocation location;

  File get imageFile {
    return File(imagePath);
  }
}
