import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/model/saving_history.dart';

class Saving {
  final int id;
  final int desiredAmount;
  final String title;
  final DateTime date;
  final CategoryIcon icon;
  final List<SavingHistory> history;

  const Saving({
    required this.id,
    required this.desiredAmount,
    required this.title,
    required this.date,
    required this.icon,
    required this.history,
  });

  int get savedMoney {
    int sum = 0;
    for (SavingHistory transaction in history) {
      if (transaction.moneyIn) {
        sum += transaction.amount;
      }else {
        sum -= transaction.amount;
      }
    }
    return sum;
  }

  int get remainingMoney {
    return desiredAmount - savedMoney;
  }

  int get remainingDays {
    return date.difference(DateTime.now()).inDays;
  }

  int get percentage {
    int per = (savedMoney * 100) ~/ desiredAmount;
    return per <= 100 ? per : 100;
  }

  @override
  String toString() {
    return 'Saving{ id: $id, desiredAmount: $desiredAmount, title: $title, date: $date, icon: $icon, history: $history,}';
  }

  Saving copyWith({
    int? id,
    int? desiredAmount,
    String? title,
    DateTime? date,
    CategoryIcon? icon,
    List<SavingHistory>? history,
  }) {
    return Saving(
      id: id ?? this.id,
      desiredAmount: desiredAmount ?? this.desiredAmount,
      title: title ?? this.title,
      date: date ?? this.date,
      icon: icon ?? this.icon,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'amount': desiredAmount,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'icon_id': icon.id,
      // 'history': history,
    };
  }

  factory Saving.fromMap(Map<String, dynamic> map) {
    return Saving(
      id: map['id'] as int,
      desiredAmount: map['amount'] as int,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      icon: CategoryIcon.fromMap(map['icon']),
      history: [],
      // history: map['history'] as List<SavingHistory>,
    );
  }
}