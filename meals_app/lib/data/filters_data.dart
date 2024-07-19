import 'package:meals_app/models/filter_info.dart';

List<FilterInfo> filtersData = [
  FilterInfo(
    id: '1',
    title: 'Gluten-free',
    subtitle: 'Only include gluten-free meals',
    type: FilterType.gluttenFree,
    checked: false,
  ),
  FilterInfo(
    id: '2',
    title: 'Lactose-free',
    subtitle: 'Only include lactose-free meals',
    type: FilterType.lactoseFree,
    checked: false,
  ),
  FilterInfo(
    id: '3',
    title: 'Vegetarian',
    subtitle: 'Only include vegetarian meals',
    type: FilterType.vegetarian,
    checked: false,
  ),
  FilterInfo(
    id: '4',
    title: 'Vegan',
    subtitle: 'Only include vegan meals',
    type: FilterType.vegan,
    checked: false,
  ),
];

class FilterData {
  bool isFilterSelected(FilterType type) {
    // var ret = false;
    // for (FilterInfo filter in filtersData) {
    //   if (filter.type == type) ret = filter.checked;
    // }
    // return ret;
    return filtersData.firstWhere((filter) => filter.type == type).checked;
  }
}
