import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/filter_info.dart';
import 'package:meals_app/providers/meals_provider.dart';

class FiltersNotifier extends StateNotifier<Map<FilterType, bool>> {
  FiltersNotifier()
      : super({
          FilterType.gluttenFree: false,
          FilterType.lactoseFree: false,
          FilterType.vegetarian: false,
          FilterType.vegan: false,
        });

  void setFilters(Map<FilterType, bool> chosenFilters) {
    //print('FiltersNotifier.setFilters');
    state = chosenFilters;
  }

  void setFilter(FilterType filter, bool isActive) {
    //print('FiltersNotifier.setFilter');
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<FilterType, bool>>(
        (ref) => FiltersNotifier());

final filteredMealProvider = Provider((ref) {
  //print('filteredMealProvider.Provider');
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[FilterType.gluttenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[FilterType.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[FilterType.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[FilterType.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
