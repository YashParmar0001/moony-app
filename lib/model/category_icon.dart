class CategoryIcon {
  final int id;
  final String iconCategory;
  final String icon;
  static const _path = 'assets/category_icons';

  const CategoryIcon({
    required this.id,
    required this.iconCategory,
    required this.icon,
  });

  String get iconPath => '$_path/$iconCategory/$icon.png';

  @override
  String toString() {
    return 'CategoryIcon{ iconCategory: $iconCategory, icon: $icon,}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryIcon) return false;
    return iconCategory == other.iconCategory && icon == other.icon;
  }

  @override
  int get hashCode => iconCategory.hashCode ^ icon.hashCode;

  CategoryIcon copyWith({
    int? id,
    String? iconCategory,
    String? icon,
  }) {
    return CategoryIcon(
      id: id ?? this.id,
      iconCategory: iconCategory ?? this.iconCategory,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'icon_category': iconCategory,
      'icon': icon,
    };
  }

  factory CategoryIcon.fromMap(Map<String, dynamic> map) {
    return CategoryIcon(
      id: map['icon_id'] as int,
      iconCategory: map['icon_category'] as String,
      icon: map['icon'] as String,
    );
  }
}