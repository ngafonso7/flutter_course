import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  //void _openPlaceDetails(BuildContext ctx, Place place) {}

  late Future<void> _placesFuture;

  // String _batteryLevel = '??? %';
  // static const platform = MethodChannel('samples.flutter.dev/battery');

  // Future<void> _getBatteryLevel() async {
  //   String batteryLevel;
  //   try {
  //     final result = await platform.invokeMethod<int>('getBatteryLevel');
  //     batteryLevel = '$result % .';
  //   } on PlatformException catch (e) {
  //     batteryLevel = "Failed";
  //     print(e.message);
  //   }

  //   setState(() {
  //     _batteryLevel = batteryLevel;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesListProvider.notifier).loadPlaces();
    //_getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesListProvider);
    return Scaffold(
      appBar: AppBar(
        //title: Text('Your Places - $_batteryLevel'),
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlacesList(
                      places: placesList,
                    ),
        ),
      ),
    );
  }
}
