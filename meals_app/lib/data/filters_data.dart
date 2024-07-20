import 'package:meals_app/models/filter_info.dart';

List<FilterInfo> filtersData = [
  FilterInfo(
    id: '1',
    title: 'Gluten-free',
    subtitle: 'Only include gluten-free meals',
    type: FilterType.gluttenFree,
  ),
  FilterInfo(
    id: '2',
    title: 'Lactose-free',
    subtitle: 'Only include lactose-free meals',
    type: FilterType.lactoseFree,
  ),
  FilterInfo(
    id: '3',
    title: 'Vegetarian',
    subtitle: 'Only include vegetarian meals',
    type: FilterType.vegetarian,
  ),
  FilterInfo(
    id: '4',
    title: 'Vegan',
    subtitle: 'Only include vegan meals',
    type: FilterType.vegan,
  ),
];
