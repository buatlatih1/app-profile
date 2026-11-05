class MenuItemModel {
  final int id;
  final String label;
  final String url;
  final String type;
  final int sortOrder;
  final List<MenuItemModel> children;

  MenuItemModel({
    required this.id,
    required this.label,
    required this.url,
    required this.type,
    this.sortOrder = 0,
    this.children = const [],
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    var rawChildren = json['children'];
    List<MenuItemModel> childList = [];
    if (rawChildren is List) {
      childList = rawChildren
          .whereType<Map<String, dynamic>>()
          .map((c) => MenuItemModel.fromJson(c))
          .toList();
    }

    return MenuItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      label: json['label']?.toString() ?? '',
      url: json['url']?.toString() ?? '/',
      type: json['type']?.toString() ?? 'custom',
      sortOrder: json['sort_order'] is int ? json['sort_order'] : 0,
      children: childList,
    );
  }
}

class MenuModel {
  final int id;
  final String name;
  final String location;
  final List<MenuItemModel> items;

  MenuModel({
    required this.id,
    required this.name,
    required this.location,
    this.items = const [],
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'];
    List<MenuItemModel> itemList = [];
    if (rawItems is List) {
      itemList = rawItems
          .whereType<Map<String, dynamic>>()
          .map((item) => MenuItemModel.fromJson(item))
          .toList();
    }

    return MenuModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? 'header',
      items: itemList,
    );
  }
}

