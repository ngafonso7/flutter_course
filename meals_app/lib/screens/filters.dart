import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/filters_data.dart';
import 'package:meals_app/models/filter_info.dart';
import 'package:meals_app/providers/filters_provider.dart';
// import 'package:meals_app/screens/tabs.dart';
// import 'package:meals_app/widgets/main_drawer.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      // drawer: MainDrawer(
      //   onSelectedScreen: (identifier) {
      //     Navigator.of(context).pop(); //Close the Drawer screen
      //     if (identifier == 'filters') {
      //       //Navigator.of(context).pop(); //Close the Drawer screen
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      //     }
      //   },
      // ),
      body: Column(
        children: [
          for (FilterInfo filter in filtersData)
            SwitchListTile(
              value: activeFilters[filter.type]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(filter.type, isChecked);
              },
              title: Text(
                filter.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                filter.subtitle,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            )
          // SwitchListTile(
          //   value: _gluttenFreeFilterSet,
          //   onChanged: (isChecked) {
          //     setState(() {
          //       _gluttenFreeFilterSet = isChecked;
          //     });
          //   },
          //   title: Text(
          //     'Gluten-free',
          //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
          //           color: Theme.of(context).colorScheme.onSurface,
          //         ),
          //   ),
          //   subtitle: Text(
          //     'Only include gluten-free meals.',
          //     style: Theme.of(context).textTheme.labelMedium!.copyWith(
          //           color: Theme.of(context).colorScheme.onSurface,
          //         ),
          //   ),
          //   activeColor: Theme.of(context).colorScheme.tertiary,
          //   contentPadding: const EdgeInsets.only(left: 34, right: 22),
          // )
        ],
      ),
    );
  }
}
