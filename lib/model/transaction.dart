import 'package:flutter/material.dart';

import 'category.dart';

class Transaction {
  final int id;
  final int money;
  final Category category;
  // final String categoryId;
  final String note;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.money,
    required this.category,
    // required this.categoryId,
    required this.note,
    required this.date,
  });

  @override
  String toString() {
    return 'Transaction{ id: $id, money: $money, category: $category, note: $note, date: $date,}';
  }

  Transaction copyWith({
    int? id,
    int? money,
    // String? categoryId,
    Category? category,
    String? note,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      money: money ?? this.money,
      category: category ?? this.category,
      // categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'money': money,
      'category_id': category.id,
      'note': note,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['tran_id'] as int,
      money: map['money'] as int,
      category: Category.fromMap(map['category']),
      // categoryId: (map['category_id'] as int).toString(),
      note: map['note'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
