import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

String _templatesDirFrom(Directory start, HookContext context) {
  final scriptDir = start.path;
  final candidates = <String>[
    // next to compiled script
    p.join(scriptDir, 'templates'),
    // go up from build/hooks/post_gen/
    p.join(scriptDir, '..', 'templates'),
    p.join(scriptDir, '..', '..', 'templates'),
    p.join(scriptDir, '..', '..', '..', 'templates'),      // <-- important on Windows
    p.join(scriptDir, '..', '..', '..', '..', 'templates'),// extra safety
    // project-relative fallbacks (in case your brick is not under /bricks)
    p.join(Directory.current.path, 'flutter_feature', 'hooks', 'templates'),
    p.join(Directory.current.path, 'bricks', 'flutter_feature', 'hooks', 'templates'),
    p.join(Directory.current.path, 'hooks', 'templates'),
  ].map((e) => p.normalize(e)).toList();

  for (final d in candidates) {
    if (Directory(d).existsSync()) return d;
  }
  context.logger.err('Could not locate templates dir. Looked in:\n${candidates.join('\n')}');
  throw Exception('templates not found');
}

String readTpl(String name, String templatesDir) {
  final filePath = p.join(templatesDir, name);
  return File(filePath).readAsStringSync();
}

String render(String tpl, Map data) {
  var s = tpl;
  data.forEach((k, v) => s = s.replaceAll('{{$k}}', '$v'));
  return s;
}

void writeFile(String path, String content) {
  final f = File(path);
  f.parent.createSync(recursive: true);
  f.writeAsStringSync(content);
}

void run(HookContext context) {
  final logger = context.logger;
  final vars = context.vars;
  final feature = vars['feature_name'] as String;
  final models = (vars['models'] as List).cast<Map>();

  final templatesDir = _templatesDirFrom(Directory(p.dirname(Platform.script.toFilePath())), context);
  logger.detail('Using templates at: $templatesDir');

  final outRoot = Directory.current.uri.toFilePath();
  final base = p.normalize(p.join(outRoot, 'lib', 'features', feature));

  for (final m in models) {
    final pascal = m['pascal'];
    final snake = m['snake'];
    final camel = m['camel'];
    final hasPagination = m['hasPagination'] == true;

    // Entity
    writeFile(
      p.join(base, 'domain', 'entities', '$snake.dart'),
      render(readTpl('entity.dart.tpl', templatesDir), {
        'Pascal': pascal,
        'snake': snake,
        'camel': camel,
      }),
    );

    // DTO
    writeFile(
      p.join(base, 'data', 'models', '${snake}_dto.dart'),
      render(readTpl('dto.dart.tpl', templatesDir), {
        'Pascal': pascal,
        'snake': snake,
        'camel': camel,
      }),
    );

    // Mappers (both sides)
    writeFile(
      p.join(base, 'domain', 'entities', 'mappers', '${snake}_mapper.dart'),
      render(readTpl('entity_mapper.dart.tpl', templatesDir), {
        'Pascal': pascal,
        'snake': snake,
        'camel': camel,
        'feature': feature,
      }),
    );

    writeFile(
      p.join(base, 'data', 'models', 'mappers', '${snake}_dto_mapper.dart'),
      render(readTpl('dto_mapper.dart.tpl', templatesDir), {
        'Pascal': pascal,
        'snake': snake,
        'camel': camel,
        'feature': feature,
      }),
    );

    if (hasPagination) {
      writeFile(
        p.join(base, 'domain', 'entities', '${snake}_paged.dart'),
        render(readTpl('paged_entity.dart.tpl', templatesDir), {
          'Pascal': pascal,
          'snake': snake,
          'camel': camel,
        }),
      );

      writeFile(
        p.join(base, 'data', 'models', '${snake}_paged_dto.dart'),
        render(readTpl('paged_dto.dart.tpl', templatesDir), {
          'Pascal': pascal,
          'snake': snake,
          'camel': camel,
        }),
      );

      writeFile(
        p.join(base, 'domain', 'entities', 'mappers', '${snake}_paged_mapper.dart'),
        render(readTpl('paged_entity_mapper.dart.tpl', templatesDir), {
          'Pascal': pascal,
          'snake': snake,
          'camel': camel,
          'feature': feature,
        }),
      );

      writeFile(
        p.join(base, 'data', 'models', 'mappers', '${snake}_paged_dto_mapper.dart'),
        render(readTpl('paged_dto_mapper.dart.tpl', templatesDir), {
          'Pascal': pascal,
          'snake': snake,
          'camel': camel,
          'feature': feature,
        }),
      );
    }
  }

  logger.success('Generated ${models.length} model(s) + DTOs + mappers (with pagination where requested).');
}