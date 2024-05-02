class SavingHistory {
  final int id;
  final int savingId;
  final bool moneyIn;
  final DateTime date;
  final int amount;
  final String description;

  const SavingHistory({
    required this.id,
    required this.savingId,
    required this.moneyIn,
    required this.date,
    required this.amount,
    required this.description,
  });

  @override
  String toString() {
    return 'SavingHistory{ id: $id, savingId: $savingId, moneyIn: $moneyIn, date: $date, amount: $amount, description: $description,}';
  }

  SavingHistory copyWith({
    int? id,
    int? savingId,
    bool? moneyIn,
    DateTime? date,
    int? amount,
    String? description,
  }) {
    return SavingHistory(
      id: id ?? this.id,
      savingId: savingId ?? this.savingId,
      moneyIn: moneyIn ?? this.moneyIn,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'saving_id': savingId,
      'money_in': moneyIn ? 1 : 0,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'description': description,
    };
  }

  factory SavingHistory.fromMap(Map<String, dynamic> map) {
    return SavingHistory(
      id: map['history_id'] as int,
      savingId: map['saving_id'] as int,
      moneyIn: (map['money_in'] as int) == 1 ? true : false,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      amount: map['amount'] as int,
      description: map['description'] as String,
    );
  }
}
