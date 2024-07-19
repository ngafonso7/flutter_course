enum FilterType {
  gluttenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterInfo {
  FilterInfo(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.type,
      required this.checked});

  final String id;
  final String title;
  final String subtitle;
  final FilterType type;

  bool checked;

  set filterChecked(bool check) {
    checked = check;
  }
}
