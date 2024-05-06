import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/transaction.dart';

class Budget {
  final int id;
  final Category category;
  final int limit;
  final int month;
  final int year;
  final List<Transaction> transactions;

  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.month,
    required this.year,
    required this.transactions,
  });

  @override
  String toString() {
    return 'Budget{ id: $id, category: $category, amountLimit: $limit, month: $month, year: $year, transactions: $transactions,}';
  }

  int get spent {
    int total = 0;
    for (Transaction transaction in transactions) {
      total += transaction.money;
    }
    return total;
  }

  int get remaining => limit - spent;

  int get percentage {
    final per = (spent * 100) / limit;
    return (per <= 100) ? per.toInt() : 100;
  }

  Budget copyWith({
    int? id,
    Category? category,
    int? limit,
    int? month,
    int? year,
    List<Transaction>? transactions,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      month: month ?? this.month,
      year: year ?? this.year,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': category.id,
      'budget_limit': limit,
      'month': month,
      'year': year,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as int,
      category: Category.fromMap(map['category']),
      limit: map['limit'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      transactions: const [],
    );
  }
}
