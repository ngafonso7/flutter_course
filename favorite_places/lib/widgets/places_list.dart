import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text('No places added!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            )),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(places[index].imageFile),
        ),
        title: Text(
          places[index].title,
          style: Theme.of(ctx)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(ctx).colorScheme.onSurface),
        ),
        subtitle: Text(places[index].location.address,
            style: Theme.of(ctx)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(ctx).colorScheme.onSurface)),
        onTap: () {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (ctx) => PlaceDetailsScreen(
                currentPlace: places[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
