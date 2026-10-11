import 'pagination_entity.dart';

class PagedEntity<T> {
  const PagedEntity({required this.items, required this.pagination});

  final List<T> items;
  final PaginationEntity pagination;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PagedEntity<T> &&
          runtimeType == other.runtimeType &&
          pagination == other.pagination &&
          _listEquals(items, other.items);

  @override
  int get hashCode => items.hashCode ^ pagination.hashCode;

  static bool _listEquals<E>(List<E> a, List<E> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
