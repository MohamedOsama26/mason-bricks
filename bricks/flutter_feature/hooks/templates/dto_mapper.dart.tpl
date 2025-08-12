import '../../models/{{snake}}_dto.dart';
import '../../../domain/entities/{{snake}}.dart';

extension {{Pascal}}DtoToEntity on {{Pascal}}Dto {
  {{Pascal}} toEntity() => {{Pascal}}(id: id, title: title);
}

extension {{Pascal}}EntityToDto on {{Pascal}} {
  {{Pascal}}Dto toDto() => {{Pascal}}Dto(id: id, title: title);
}
