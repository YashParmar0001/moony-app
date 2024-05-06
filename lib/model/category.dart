import 'category_icon.dart';

class Category {
  final int id;
  final bool isIncome;
  final String name;
  final CategoryIcon icon;
  // final int iconId;

  const Category({
    required this.id,
    required this.isIncome,
    required this.name,
    required this.icon,
    // required this.iconId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category{ isIncome: $isIncome, name: $name, icon: $icon,}';
  }

  Category copyWith({
    bool? isIncome,
    String? name,
    CategoryIcon? icon,
    // int? iconId,
  }) {
    return Category(
      id: id,
      isIncome: isIncome ?? this.isIncome,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      // iconId: iconId ?? this.iconId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_income': isIncome ? 1 : 0,
      'name': name,
      'icon_id': icon.id,
      // 'icon_id' : iconId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['category_id'] as int,
      isIncome: (map['is_income'] as int) == 1 ? true : false,
      name: map['name'] as String,
      icon: CategoryIcon.fromMap(map['icon']),
      // iconId: map['icon_id'] as int
    );
  }
}
