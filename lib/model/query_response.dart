class QueryResponse<T> {
  const QueryResponse({required this.data, required this.error});

  final T? data;
  final String? error;

  QueryResponse<T> copyWith({T? data, String? error}) {
    return QueryResponse<T>(
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
