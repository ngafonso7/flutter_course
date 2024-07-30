import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedImagePath = '';
  PlaceLocation? _selectedLocation;

  var _enteredTitle = '';

  void _addNewItem() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagePath == '' || _selectedLocation == null) {
        return;
      }
      _formKey.currentState!.save();
      ref.read(placesListProvider.notifier).addNewPlace(
            Place(
              null,
              _enteredTitle,
              _selectedImagePath,
              _selectedLocation!,
            ),
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Title must have at least 1 letter';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _enteredTitle = newValue!,
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickImage: (path) {
                    _selectedImagePath = path;
                  },
                ),
                const SizedBox(height: 10),
                const LocationInput(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _addNewItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            ),
          ),
        ));
  }
}
