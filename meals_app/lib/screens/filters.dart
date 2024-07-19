import 'package:flutter/material.dart';
import 'package:meals_app/data/filters_data.dart';
import 'package:meals_app/models/filter_info.dart';
// import 'package:meals_app/screens/tabs.dart';
// import 'package:meals_app/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  final List<FilterInfo> _filterData = List<FilterInfo>.from(filtersData);

  @override
  Widget build(BuildContext context) {
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
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Navigator.of(context).pop({
            FilterType.gluttenFree:
                FilterData().isFilterSelected(FilterType.gluttenFree),
            FilterType.lactoseFree:
                FilterData().isFilterSelected(FilterType.lactoseFree),
            FilterType.vegetarian:
                FilterData().isFilterSelected(FilterType.vegetarian),
            FilterType.vegan: FilterData().isFilterSelected(FilterType.vegan),
          });
        },
        child: Column(
          children: [
            for (FilterInfo filter in _filterData)
              SwitchListTile(
                value: filter.checked,
                onChanged: (isChecked) {
                  setState(() {
                    filter.filterChecked = isChecked;
                  });
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
      ),
    );
  }
}
