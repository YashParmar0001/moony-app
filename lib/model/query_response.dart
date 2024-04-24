import 'package:moony_app/model/transaction.dart';

class QueryResponse {
  const QueryResponse({required this.transaction, required this.error});

  final Transaction? transaction;
  final String? error;

  QueryResponse copyWith({Transaction? transaction, String? error}) {
    return QueryResponse(
      transaction: transaction ?? this.transaction,
      error: error ?? this.error,
    );
  }
}
