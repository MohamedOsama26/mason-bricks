import '../../entities/{{snake}}.dart';
import '../../entities/{{snake}}_paged.dart';
import '../../../data/models/{{snake}}_paged_dto.dart';
import '../../../data/models/{{snake}}_dto.dart';

extension Paged{{Pascal}}DtoToEntity on Paged{{Pascal}}Dto {
  Paged{{Pascal}} toEntity() => Paged{{Pascal}}(
        items: items.map((e) => e.toEntity()).toList(),
        page: page,
        limit: limit,
        total: total,
        hasMore: hasMore,
      );
}

extension Paged{{Pascal}}EntityToDto on Paged{{Pascal}} {
  Paged{{Pascal}}Dto toDto() => Paged{{Pascal}}Dto(
        items: items.map((e) => {{Pascal}}Dto(id: e.id, title: e.title)).toList(),
        page: page,
        limit: limit,
        total: total,
        hasMore: hasMore,
      );
}
