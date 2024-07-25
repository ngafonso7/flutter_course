import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place(
    this.title,
    this.imagePath,
    //this.location,
  ) : id = uuid.v4();

  final String id;
  final String title;
  final String imagePath;
  //final PlaceLocation location;

  File get imageFile {
    return File(imagePath);
  }
}
