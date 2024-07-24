import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListNotifier extends StateNotifier<List<Place>> {
  PlacesListNotifier() : super([]);

  void addNewPlace(Place place) {
    state = [place, ...state];
  }
}

final placesListProvider =
    StateNotifierProvider<PlacesListNotifier, List<Place>>((ref) {
  return PlacesListNotifier();
});
