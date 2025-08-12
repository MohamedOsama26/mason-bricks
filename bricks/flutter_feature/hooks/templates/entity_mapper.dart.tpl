import '../../entities/{{snake}}.dart';
import '../../../data/models/{{snake}}_dto.dart';

extension {{Pascal}}DetailsMapper on {{Pascal}}Dto {
  /// Maps the {{Pascal}}Dto to a {{Pascal}} entity.
  {{Pascal}} toEntity() {
    return {{Pascal}}(
      id: id,
      title: title,
    );
  }
}

extension {{Pascal}}ToDto on {{Pascal}} {
  /// Maps a [{{Pascal}}] to a [{{Pascal}}Dto].
  {{Pascal}}Dto toDto() {
    return {{Pascal}}Dto(
      id: id,
      title: title,
    );
  }
}
