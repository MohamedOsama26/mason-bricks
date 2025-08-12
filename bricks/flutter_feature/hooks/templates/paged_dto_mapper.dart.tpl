import '../../../domain/entities/{{snake}}.dart';
import '../../../domain/entities/{{snake}}_paged.dart';
import '../../models/{{snake}}_paged_dto.dart';
import '../../models/{{snake}}_dto.dart';

extension Paged{{Pascal}}DtoToEntity2 on Paged{{Pascal}}Dto {
  Paged{{Pascal}} toEntity() => Paged{{Pascal}}(
        items: items.map((e) => e.toEntity()).toList(),
        page: page,
        limit: limit,
        total: total,
        hasMore: hasMore,
      );
}

extension Paged{{Pascal}}EntityToDto2 on Paged{{Pascal}} {
  Paged{{Pascal}}Dto toDto() => Paged{{Pascal}}Dto(
        items: items.map((e) => {{Pascal}}Dto(id: e.id, title: e.title)).toList(),
        page: page,
        limit: limit,
        total: total,
        hasMore: hasMore,
      );
}
