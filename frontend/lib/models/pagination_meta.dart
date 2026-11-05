class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPrevPage => currentPage > 1;

  factory PaginationMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: 10);
    }
    return PaginationMeta(
      currentPage: json['current_page'] is int ? json['current_page'] : 1,
      lastPage: json['last_page'] is int ? json['last_page'] : 1,
      total: json['total'] is int ? json['total'] : 0,
      perPage: json['per_page'] is int ? json['per_page'] : 10,
    );
  }
}

