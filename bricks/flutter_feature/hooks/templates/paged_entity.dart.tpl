import '{{snake}}.dart';

class Paged{{Pascal}} {
  final List<{{Pascal}}> items;
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  const Paged{{Pascal}}({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
  });
}
