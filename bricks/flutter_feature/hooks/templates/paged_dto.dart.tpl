import '{{snake}}_dto.dart';

class Paged{{Pascal}}Dto {
  final List<{{Pascal}}Dto> items;
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  const Paged{{Pascal}}Dto({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  factory Paged{{Pascal}}Dto.fromJson(Map<String, dynamic> json) => Paged{{Pascal}}Dto(
        items: (json['items'] as List<dynamic>).map((e) => {{Pascal}}Dto.fromJson(e as Map<String, dynamic>)).toList(),
        page: json['page'] as int,
        limit: json['limit'] as int,
        total: json['total'] as int,
        hasMore: json['hasMore'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'page': page,
        'limit': limit,
        'total': total,
        'hasMore': hasMore,
      };
}
